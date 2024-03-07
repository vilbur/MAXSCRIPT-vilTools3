
if VERTEX_DATA_CACHE == undefined then -- DEV
	global VERTEX_DATA_CACHE = Dictionary #string


/** Mesh vertex getter
 */
struct MeshVertexGetter_v
(
	/* construct */
	obj,	-- object used for getting data ( collapsed copy of obj  OR obj if it is Edit_Poly )

	/* properties */
	obj_original, --store original node if object needs to be collapsed

	verts_to_get	= #{},	-- selected or colored verts of  object
	verts_positions	= #(),	-- positions only of verts_to_get
	verts_normals	= #(),	-- normals only of verts_to_get
	vertex_colors	= Dictionary #string,	 -- vertex colors of all verts

	verts_data      = #(), -- 2d matrix #( #{verts_to_get}, #( verts_positions ), #( verts_normals ), #( vertex_colors )   )

	--platform_vertex_data_key = "platform_vertex_data",

	/* dependency */
	MeshVertToColorVertexConvert,

	/* reference */
	/* inhered */

	/** Get vertex positions, color and normals from Editable Poly object
	  *
	  * Verts used are stored in this.verts_to_get
	  *
	  * 	USED VERTEX BY
	  * 		1) Get selected verts if subobejctlevel is 1 and any vertex is selected
	  * 		2) Get all colored verts if nothing selected
	  * 		3) Get all verts in nothing is selected and vertex colors does not exists
	  *
	  *
	  * @param boolean remove_multi_colored_verts_from_white	TRUE: collect first non white color | FALSE: collect all colors for vert ( mesh vert is occuring in muliple colors )
	  * @param boolean quiet	Dont ask to continue if all verts of object used
	  *
	  * @return 2Dmatrix  #( #{ verts_to_get_bitarray }, #( verts_positions ), #( verts_normals ), #( vertex_colors )   )
	  */
	function getVetexData remove_multi_colored_verts_from_white:false quiet:false =
	(
		format "\n"; print "MeshVertexGetter_v.getVetexData()"
		max modify mode

		fn transformChanged	verts_cache = verts_cache != undefined and verts_cache[1] != this.obj.transform
		fn vertsSelChanged	verts_cache = verts_cache != undefined and ( verts_cache[2] - this.verts_to_get ).isEmpty == false
		fn positionChanged	verts_cache = verts_cache != undefined and( with PrintAllElements on verts_cache[3] as string == this.verts_positions as string )
		fn normalsChanged	verts_cache = verts_cache != undefined and verts_cache[4].count != this.verts_to_get.numberSet

		--this.obj = _obj

		object_pointer = (getHandleByAnim obj) as string
		verts_count	= getNumVerts obj.mesh
		verts_all	= #{1..(verts_count)}
		vertex_sel	= getVertSelection obj.mesh --else #{} -- ignore vertex selection if not suobject level active
		verts_count_VC	= getNumCPVVerts obj.mesh

		/* SET COLORS FIRST - needed for getting verts_to_get by color  */
		this._setVertexColors verts_to_get_colors:verts_all vertex_colors_exists:(verts_count_VC != 0) remove_multi_colored_verts_from_white:remove_multi_colored_verts_from_white


		/* GET VERTS TO GENERATE FROM */
		verts_to_get = case of
		(
			/* GET SELECTED VERTS */
			(not vertex_sel.isEmpty and subObjectLevel == 1 ): vertex_sel

			/* GET COLORED VERTS - NOT WHITE COLOR */
			(vertex_colors.keys.count > 1): verts_all - vertex_colors[ white as string ]

			/* VERTEX COLORS NOT EXISTS */
			default: verts_all
		)

		format "VERTS_TO_GET: %\n" verts_to_get
		/* SET VERTS POSITIONS WHEN verts_to_get is known  */
		this._setVertexPositions()

		/* WARNING IF ALL VERTS ARE USED */
		if verts_count != verts_to_get.numberSet or quiet or queryBox ("USE ALL "+ verts_count as string +" VERTS ?") title:"SET VERTS DATA"  then
		(
			verts_cache 	= VERTEX_DATA_CACHE[ object_pointer ]

			this.verts_normals =	if verts_cache == undefined	   	\
				or transformChanged(verts_cache)	\
				or vertsSelChanged(verts_cache)	\
				or positionChanged(verts_cache)	\
				or normalsChanged(verts_cache)		\

								then
									this._getVertNormals()
								else
									verts_cache[4]


			------this.verts_normals =	this._getVertNormals() -- FOR DEBUG for case of debbuging cache


			this.verts_data = #( verts_to_get, verts_positions, verts_normals, this._getVertexColorsByVerts()  )

			--format "verts_data[1] count: % array: % \n" verts_data[1].numberSet verts_data[1]
			--format "verts_data[2] count: % array: % \n" verts_data[2].count verts_data[2]
			--format "verts_data[3] count: % array: % \n" verts_data[3].count verts_data[3]
			--format "verts_data[4] count: % array: % \n" verts_data[4].count verts_data[4]

			VERTEX_DATA_CACHE[ object_pointer ] = #( obj.transform, verts_to_get, verts_positions, verts_normals ) --return

			if  obj_original != undefined then
				delete obj

			this.verts_data --return
		)
		else
		(
			if  obj_original != undefined then -- HOTFIX
				delete obj

			undefined -- return
		)

	),


	/** Get colors and its mesh verts
	  *
	  * IMPORTANT - SINGLE MESH VERT CAN APPEAR IN MULTIPLE COLORS - since each map vert can has its own color
	  *
	  * @return Dictionary #string BitArrays of mesh verts sorted by color E.G.: #( "color 255 255 255", #{1..999}  )  #( "color 0 255 255", #{1..3}  )
	  *
	 */
	function getColoredVerts  =
	(
		--format "\n"; print "MeshVertexGetter_v._getColoredVerts()"
		--object_pointer = (getHandleByAnim obj) as string
		verts_count	= getNumVerts obj.mesh
		verts_all	= #{1..(verts_count)}
		vertex_sel	= getVertSelection obj.mesh --else #{} -- ignore vertex selection if not suobject level active
		verts_count_VC	= getNumCPVVerts obj.mesh

		/* SET COLORS FIRST - needed for getting verts_to_get by color  */
		this._setVertexColors verts_to_get_colors:( if not vertex_sel.isEmpty then vertex_sel else verts_all) vertex_colors_exists:(verts_count_VC != 0)

		this.vertex_colors --return
	),

	private

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
	function _setVertexColors verts_to_get_colors: vertex_colors_exists: remove_multi_colored_verts_from_white:false =
	(
		--format "\n"; print "MeshVertexGetter_v._setVertexColors()"
		/** White verts exists
		 */
		function whiteVertsExists = HasDictValue this.vertex_colors ( white as string )

		local color_of_vert

		local white_clr = white as string

		if vertex_colors_exists then
		(
			--format "START verts_to_get_colors	= % \n" verts_to_get_colors
			--format "verts_to_get_colors.numberSet	= % \n" verts_to_get_colors.numberSet

			MeshVertToColorVertexConvert.get_single_vert = false

			while not verts_to_get_colors.isEmpty do
			(
				mesh_vert = (verts_to_get_colors as Array )[1]

				map_verts_of_mesh_vert = makeUniqueArray (MeshVertToColorVertexConvert.meshVertsToMapVerts (mesh_vert) flat:true )

				color_of_vert = this._searchNewVertexColor (map_verts_of_mesh_vert)

				mesh_verts_by_color = meshop.getVertsByColor obj.mesh color_of_vert 0.01 0.01 0.01 	-- get all verts by thath color

				this.vertex_colors[ color_of_vert as string ] = mesh_verts_by_color

				verts_to_get_colors -= mesh_verts_by_color

			)

			/* REMOVE MULTI COLORED VERTS FROM WHITE - (if one of vert colors is not white, then vert is not white) */
			if remove_multi_colored_verts_from_white and whiteVertsExists() then
				for clr in this.vertex_colors.keys  where clr != white_clr do
					this.vertex_colors[white_clr] -= vertex_colors[clr]
		)
		else
			vertex_colors[ obj.wirecolor as string ] = verts_to_get_colors
	),

	/** SET VERTEX POSITIONS only of verts_to_get
	 */
	function _setVertexPositions =
	(
		--format "\n"; print "MeshVertexGetter_v._setVertexPositions()"
		this.verts_positions = meshop.getVerts obj.mesh verts_to_get node:obj
	),


	/** SET VERT NORMALS only of verts_to_get
	 */
	function _getVertNormals =
	(
		format "\n"; print "MeshVertexGetter_v._getVertNormals()"
		--this.verts_normals = for vert in verts_to_get collect ( getnormal obj.mesh vert )
		sub_object_level = subObjectLevel

		EditNormalsMod = Edit_Normals()

		addModifier obj EditNormalsMod

		verts_normals = for i = 1 to (verts_to_generate_arr = verts_to_get as Array ).count collect
		(
			normal_averaged	= [0,0,0]
			normals_per_vertex	= #{}

			vert = verts_to_generate_arr[i]

			EditNormalsMod.ConvertVertexSelection #{vert} (normals_per_vertex)

			for normal in normals_per_vertex as Array do normal_averaged += EditNormalsMod.getNormal(normal) node:obj

			normalize normal_averaged
		)

		--verts_normals = for vert in verts_to_get collect (EditNormalsMod.getNormal(vert)) * obj.transform

		deleteModifier obj EditNormalsMod

		subObjectLevel = sub_object_level

		verts_normals --return
	),



	/** GET VERTEX COLORS of map verts
	  *
	  *
	  * @retrun Color|#(Color) - color of mesh vert, array of colors if has multiple colors
	*/
	function _getVertexColorsByVerts =
	(
		--format "\n"; print "MeshVertexGetter_v._getVertexColorsByVerts()"

		colors = for key in vertex_colors.keys collect execute key

		/* FIND VERTEX IN 2D matrix */
		for vert in verts_to_get collect
		(
			colors_per_vert = for c = 1 to vertex_colors.count where this.vertex_colors[vertex_colors.keys[c]][vert] collect colors[c]

			colors_per_vert[1]  --return
			--colors_per_vert  --return
		)
	),

	/** Loop map verts of single mesh vert
	  *
	  * Test if vertex color is new
	  *
	  * @retrun color of map vertex
	 */
	function _searchNewVertexColor map_verts =
	(
		--format "\n"; print "MeshVertexGetter_v._searchNewVertexColor()"
		local color_of_vert

		i = 1

		while hasDictValue vertex_colors ( (color_of_vert = getvertcolor obj.mesh map_verts[i]) as string )  do
			i += 1

		color_of_vert --return
	),

	/** Ask to continue
	  *
	  */
	function _askToContinue verts_count =
	(
		----format "\n"; print "MeshVertexGetter_v._askToContinue()"
		_continue = true

		--if verts_to_get.count > 500 and not queryBox ( verts_to_get.count as string +" platforms will be generated.\n\nEstimated time: "+ estimated_time as string +" s\n\n   CONTINUE ?" ) title:"PLATFORMS GENERATION"  then
		if verts_count > 100 and not queryBox ( "Object " + obj.name + " has " + verts_count as string +" verts selected.\n\nIt may take some time.\n\nCONTINUE ?" ) title:"PLATFORMS GENERATION"  then
			 _continue =  false

		_continue --return
	),

	/** Collapse object if vertex count of top|current mesh is differrent then baseobject



	 */
	function _collapseObjectIfNeeded =
	(
		--format "\n"; print "MeshVertexGetter_v.coolapseObjectIfNeeded()"
		if getNumVerts obj.mesh != getNumVerts obj.baseobject.mesh then
		(
			--max modify mode
			sub_object_level = subObjectLevel

			snapshot_obj = snapshot obj

			convertTo snapshot_obj PolyMeshObject

			this.obj_original = obj

			this.obj = snapshot_obj

			select this.obj

			if  sub_object_level != undefined then
				subObjectLevel = sub_object_level
		)

	),

	/**
	 */
	on create do
	(
		this._collapseObjectIfNeeded()

		MeshVertToColorVertexConvert = MeshVertToColorVertexConvertor_v(obj)
	)

)
