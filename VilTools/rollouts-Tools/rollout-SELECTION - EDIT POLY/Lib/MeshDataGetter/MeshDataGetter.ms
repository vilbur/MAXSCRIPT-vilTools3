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

	  * @return Dictionary KEYS: #VERTS|#POSITIONS|#COLORS|#FACES|#NORMALS  VALUES:vertex_ids|vertex_positions|vertex_colors|faces_ids|faces_normals
	 */
	function getData verts: positions: colors: normals: =
	(
		--format "\n"; print "MeshDataGetter_v.getData()"
		function pararmExists param = param != unsupplied and param
		/* ALL APRAMS ARE TRUE IF ARE NOT DEFINED */
		if positions == unsupplied and colors == unsupplied and normals == unsupplied then
			positions = colors = normals = true

		data = Dictionary()

		/* GET VERTS INDEXES */
		data[#VERTS] = this._setVertsToProcess(verts)

		if this.Normals.limitsExists() then
			this._filterVertsByNormals()

		/* GET POSITIONS */
		if pararmExists(positions) then
			data[#POSITIONS] = this._getVertsPositions()


		/* GET COLORS */
		if pararmExists(colors) then
			data[#COLORS] = this._getVertexColors()


		/* GET NORMALS */
		if pararmExists(normals) and data[#NORMALS] == undefined then -- if normals are not already set by this._filterVertsByNormals()
			data[#NORMALS] = this._getFaceNormals()


		data --return
	),

	/** Get position

	  * @param #X|#Y|#Z axis
	 */
	function getPosition vert axis: =
	(
		--format "\n"; print "VertDataGetter_v.getPosition()"
		if ( pos = data[#POSITIONS][this.dataIndex(vert)] ) != undefined and axis != unsupplied then
			getProperty pos axis
		else
			pos
	),

	/** Get positions of each vert splitted to XYZ
	  * Usefull for gettin min and max values oe verts by each axis separatly
	  *
	  * @return #( #(X pos), #(Y pos), #(Z pos) )
	 */
	function getPositionsSplitByAxis =
	(
		--format "\n"; print "MeshDataGetter_v.getPositionsSplitted()"
		x_positions = y_positions = z_positions = #()

		for pos in data[#POSITIONS] do
		(
			append x_positions pos.x
			append y_positions pos.y
			append z_positions pos.z
		)

		#( x_positions, z_positions, z_positions  ) --return
	),

	/* Get index of data by vertex number in this.positions|normlas|colors|
	*
	* Bitarray way to accomplish : findItem (this.verts_arr) vertex_index
	*
	*/
	function dataIndex vertex_index =
	(
		--format "\n"; print "VertDataGetter_v.dataIndex()"
		--format "vertex_index: %\n" vertex_index
		--format "verts: %\n" verts
		--format "-verts: %\n" -verts
		missing = -data[#VERTS] - #{vertex_index..(vertex_count)} -- find how many indexes is false before vertex_index
		--format "missing: %\n" missing
		--format "missing.numberSet: %\n" missing.numberSet

		vertex_index - missing.numberSet
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

	/** Filter verts by normals
	 */
	function _filterVertsByNormals =
	(
		--format "\n"; print "MeshDataGetter_v._filterVertsByNormals()"
		this._getFaceNormals()

		verts_of_valid_faces = polyop.getVertsUsingFace obj data[#FACES]

		data[#VERTS] *= verts_of_valid_faces -- left only valid verts in BitArray
	),

	/** Get normals of faces which belongs to this.verts_process
	 */
	function _getFaceNormals =
	(
		format "\n"; print "MeshVertexGetter_v._getFaceNormals()"
		local face_normal

		local face_normals = #()

		data[#FACES] = polyop.getFacesUsingVert obj data[#VERTS]


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

		this.verts_process --return

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
