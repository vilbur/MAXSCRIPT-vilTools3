filein( getFilenamePath(getSourceFileName()) + "/MeshVertToColorVertexConvertor/MeshVertToColorVertexConvertor.ms" )	--"./MeshVertToColorVertexConvertor/MeshVertToColorVertexConvertor.ms"
filein( getFilenamePath(getSourceFileName()) + "/NormalLimits/NormalLimits.ms" )	--"./NormalLimits/NormalLimits.ms"

/**
 */
struct MeshDataGetter_v
(
	/* required */
	obj,

	/* construct */
	absolute,

	/* properties */
	vertex_count,
    verts_process 	= #{}, -- source vertex to operate, selection or all verts if nothing selected

	data = Dictionary(),

	/* dependency */
	Normals = NormalLimits_v(),

	MeshVertToColorVertexConvert,

	/* reference */
	/* inhered */

	/** Get data
	 */
	function getData verts: positions: colors: normals: =
	(
		format "\n"; print "MeshDataGetter_v.getData()"

		/* ALL APRAMS ARE TRUE IF ARE NOT DEFINED */
		if positions == unsupplied and colors == unsupplied and normals == unsupplied then
			positions = colors = normals = true

		this._setVertsToProcess(verts)

		data[#VERTS] = this.verts_process

		if positions then
			data[#POSITIONS] = this._getVertsPositions()


		if colors then
			data[#COLORS] = this._getVertexColors()


		if normals then
		(
			data[#FACES] = polyop.getFacesUsingVert obj verts_process

			data[#NORMALS] = this._getFaceNormals()
		)

		data --return
	),

	/*------------------------------------------------------------------------------
		SETTERS
	--------------------------------------------------------------------------------*/


	/** Set verts positions
	 */
	function _getVertsPositions =
	(
		format "\n"; print "VertDataGetter_v._getVertsPositions()"
		meshop.getVerts obj.mesh this.verts_process node:obj
	),



	/** Get normals of faces which belongs to this.verts_process


		NOTE:
			abs (dot face_normal z_axis) returns float 0-1
				where in case of Z axis
					0: normal is parallel 	to axis ( facing side )
					1: normal is perpendicular	to axis ( facing top or bottom )

	 */
	function _getFaceNormals =
	(
		format "\n"; print "MeshVertexGetter_v._getFaceNormals()"
		local face_normal
		face_normals = #()

		if Normals.limitsExists() then
		(
			normal_limit = this.Normals.get #Z

			for face in data[#FACES] do
			(
				face_normal = polyop.getFaceNormal obj face

				dot_prod = dot face_normal z_axis

				normal_angle = if Normals.absolute then acos( abs dot_prod ) else acos dot_prod

				/* COPMMARE ANGLES OF NORMAL AND LIMIT */
				if normal_angle > normal_limit[1] and normal_angle < normal_limit[2] then
					/* ADD NORMAL IF FIT BETWEEN LIMITS */
					append face_normals face_normal

				else /* REMOVE FACE IF NOT FIT NORMAL LIMIT */
					data[#FACES][face] = false
			)
		)
		else
			face_normals = for face in data[#FACES] collect polyop.getFaceNormal obj face

		face_normals --return
	),

	/*
	 */
	function _setVertsToProcess verts_to_get =
	(
		--format "\n"; print "VertexGridSelector_v._setVertsToProcess()"
		this.vertex_count = getNumVerts obj.mesh

		this.verts_process = case verts_to_get of
		(
			(#SELECTION):	getVertSelection obj.mesh -- get verts by current selecion
			(unsupplied):	#{1..(vertex_count)}	-- get all verts if undefined
			default:	verts_to_get	-- get given verts
		)

		--format "this.verts: %\n" this.verts
		--this.verts_arr = this.verts as Array
	),

	/** Set vertex colors Ditionary
	  *
	  * SINGLE MESH VERT CAN APPEAR IN MULTIPLE COLORS - Each map vert can has its own color
	  *
	  * NOTES:
	  *		1) getvertcolor()	INPUT CPV vertex
	  *		2) getVertsByColor()	RETURN MESH VERTEX
	  *
	  *
	  * KNOWING ISSUE: remove_multi_colored_verts_from_white
	  *				If vertex has mutliple colors, then first is used, include white color.
	  *				Only way to make it work seem to iterate all map verts. THIS IS OVERKIL FOR SUCH SIPMPLE OPARTION ON HIGH VERTEX COUNT OBJECTS... MAX SUCKS !
	  *
	  * @param boolean remove_multi_colored_verts_from_white TRUE: collect first non white color | FALSE: collect all colors for vert ( mesh vert is occuring in muliple colors )
	  *
	  * @return Dictionary of BitArrays of mesh verts sorted by color E.G.: #( "color 255 255 255", #{1..999}  )  #( "color 0 255 255", #{1..3}  )
	  */
	function _getVertexColors =
	(
		format "\n"; print "MeshVertexGetter_v._getVertexColors()"
		/** Loop map verts of single mesh vert
		  *
		  * Test if vertex color is new
		  *
		  * @retrun color of map vertex
		 */
		function _searchNewVertexColor colors map_verts =
		(
			--format "\n"; print "MeshVertexGetter_v._searchNewVertexColor()"
			--format "map_verts: %\n" map_verts
			--format "this.colors: %\n" this.colors
			--format "COLOR: %\n" (getvertcolor obj.mesh map_verts[1])
			local color_of_vert

			i = 1
			while map_verts[i] != undefined and hasDictValue colors ( (color_of_vert = getvertcolor obj.mesh map_verts[i]) as string )  do
				i += 1

			color_of_vert --return
		)

		/** White verts exists
		 */
		function whiteVertsExists colors = hasDictValue colors ( white as string )

		local colors 	= Dictionary #string

		local white_clr = white as string

		local color_of_vert


		/* IF VERTEX COLORS EXISTS */
		if  (getNumCPVVerts obj.mesh != 0) then
		(
			MeshVertToColorVertexConvert.get_single_vert = false

			verts_get_colors = copy verts

			while not verts_get_colors.isEmpty do
			(
				mesh_vert = ( verts_get_colors as Array )[1]

				map_verts_of_mesh_vert = makeUniqueArray (MeshVertToColorVertexConvert.meshVertsToMapVerts (mesh_vert) flat:true )

				color_of_vert = _searchNewVertexColor (colors) (map_verts_of_mesh_vert)

				mesh_verts_by_color = meshop.getVertsByColor obj.mesh color_of_vert 0.01 0.01 0.01 	-- get all verts by thath color

				this.colors[ color_of_vert as string ] = mesh_verts_by_color

				verts_get_colors -= mesh_verts_by_color
			)

			/* REMOVE MULTI COLORED VERTS FROM WHITE - (if one of vert colors is not white, then vert is not white) */
			if whiteVertsExists(colors) then
				for clr in this.colors.keys  where clr != white_clr do
					this.colors[white_clr] -= colors[clr]
		)

		colors --return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "MeshDataGetter.onCreate()"

		MeshVertToColorVertexConvert	= MeshVertToColorVertexConvertor_v(obj)

		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
