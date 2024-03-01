
if VERTEX_DATA_CACHE == undefined then -- DEV
	global VERTEX_DATA_CACHE = Dictionary #string


/** Mesh vertex getter
 */
struct MeshVertexGetter_v
(
	/* construct */
	obj,	-- object used for getting data ( collapsed copy of obj  OR obj if it is Edit_Poly )

	/* properties */
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
	  * @return 2Dmatrix  #( #{ verts_to_get_bitarray }, #( verts_positions ), #( verts_normals ), #( vertex_colors )   )
	  */
	function getVetexData quiet:false =
	(
		--format "\n"; print "MeshVertexGetter_v.getVetexData()"
		max modify mode

		fn transformChanged	verts_cache = verts_cache != undefined and verts_cache[1] != this.obj.transform
		fn vertsSelChanged	verts_cache = verts_cache != undefined and ( verts_cache[2] - this.verts_to_get ).isEmpty == false
		fn positionChanged	verts_cache = verts_cache != undefined and( with PrintAllElements on verts_cache[3] as string == this.verts_positions as string )

		--this.obj = _obj

		object_pointer = (getHandleByAnim obj) as string
		verts_count	= getNumVerts obj.mesh
		verts_all	= #{1..(verts_count)}
		vertex_sel	= getVertSelection obj.mesh --else #{} -- ignore vertex selection if not suobject level active
		verts_count_VC	= getNumCPVVerts obj.mesh

		/* SET COLORS FIRST - needed for getting verts_to_get by color  */
		this._setVertexColors verts_to_get_colors:verts_all vertex_colors_exists:(verts_count_VC != 0)

		--format "VERTEX_COLORS.COUNT	= % \n" vertex_colors.count
		--for vertex_color in vertex_colors do
		--	format "VERTEX_COLOR	= % \n" vertex_color

		verts_to_get = case of
		(
			/* GET SELECTED VERTS */
			(not vertex_sel.isEmpty and subObjectLevel == 1 ): vertex_sel

			/* GET COLORED VERTS - NOT WHITE COLOR */
			(vertex_colors.keys.count > 1): verts_all - vertex_colors[ white as string ]

			/* VERTEX COLORS NOT EXISTS */
			default: verts_all
		)

		/* SET VERTS POSITIONS WHEN verts_to_get is known  */
		this._setVertexPositions()

		/* WARNING IF ALL VERTS ARE USED */
		if verts_count != verts_to_get.numberSet or quiet or queryBox ("USE ALL "+ verts_count as string +" VERTS ?") title:"SET VERTS DATA"  then
		(
			verts_cache 	= VERTEX_DATA_CACHE[ object_pointer ]

			this.verts_normals =	if verts_cache == undefined \
				or transformChanged(verts_cache)\
				or vertsSelChanged(verts_cache)\
				or positionChanged(verts_cache)
				then
					this._getVertNormals()
				else
					verts_cache[4]

			this.verts_data = #( verts_to_get, verts_positions, verts_normals, this._getVertexColorsByVerts()  )

			--format "verts_data[1] count: % array: % \n" verts_data[1].numberSet verts_data[1]
			--format "verts_data[2] count: % array: % \n" verts_data[2].count verts_data[2]
			--format "verts_data[3] count: % array: % \n" verts_data[3].count verts_data[3]
			--format "verts_data[4] count: % array: % \n" verts_data[4].count verts_data[4]

			VERTEX_DATA_CACHE[ object_pointer ] = #( obj.transform, verts_to_get, verts_positions, verts_normals ) --return


			this.verts_data --return
		)
		else
			false -- return

	),


	/** Get colored verts
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

	--/** Load vertex data
	-- */
	--function _loadVertexNormals verts_data =
	--(
	--	--format "\n"; print "MeshVertexGetter_v._laodVertexData()"
	--	--this.verts_positions 	= verts_data[2]
	--	this.verts_normals	= verts_data[4]
	--),

	/** SET VERTEX POSITIONS only of verts_to_get
	 */
	function _setVertexPositions =
	(
		format "\n"; print "MeshVertexGetter_v._setVertexPositions()"
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

	/** GET VERTEX COLORS
	 */
	function _getVertexColorsByVerts =
	(
		format "\n"; print "MeshVertexGetter_v._getVertexColorsByVerts()"

		colors = for key in vertex_colors.keys collect execute key

		/* FIND VERTEX IN 2D matrix */
		for vert in verts_to_get collect
		(
			colors_per_vert = for c = 1 to vertex_colors.count where this.vertex_colors[vertex_colors.keys[c]][vert] collect colors[c]

			colors_per_vert[1]  --return
		)
	),

	/** Set vertex colors Ditionary
	  *
	  * IMPORTANT:
	  *		1) getvertcolor()	IS USING CPV vertex
	  *		2) getVertsByColor()	RETURN MESH VERTEX
	  *
	  *
	  * return Dictionary #( "Color 128 128 128", #{1..n} ) KEY: color VALUE: verts of that color
	  */
	function _setVertexColors verts_to_get_colors: vertex_colors_exists: =
	(
		format "\n"; print "MeshVertexGetter_v._setVertexColors()"

		local color_of_vert

		if vertex_colors_exists then
		(
			--format "START verts_to_get_colors	= % \n" verts_to_get_colors
			--format "verts_to_get_colors.numberSet	= % \n" verts_to_get_colors.numberSet

			MeshVertToColorVertexConvert.get_single_vert = false

			--counter = 1 -- DEV
			--while counter < 5 do  -- DEV
			while not verts_to_get_colors.isEmpty do
			(
				--format "\n\n\n"

				mesh_vert = (verts_to_get_colors as Array )[1]
				--format "mesh_vert	= % \n" mesh_vert

				map_verts = makeUniqueArray (MeshVertToColorVertexConvert.meshVertsToMapVerts (mesh_vert) flat:true )
				--format "map_verts	= % \n" map_verts


				i = 1
				/* LOOP EACH GEOMETRY VERTEX OF FACE and find which vert share same faces as faces_of_vertex_pattern ( it means that it is the same geometry vert ) */
				while HasDictValue vertex_colors ( (color_of_vert = getvertcolor obj.mesh map_verts[i]) as string )  do
					i += 1

				mesh_verts_by_color = meshop.getVertsByColor obj.mesh color_of_vert 0.01 0.01 0.01 	-- get all verts by thath color
				--format "\nmesh_verts_by_color = % \n" mesh_verts_by_color
				--format "mesh_verts_by_color.numberSet	= % \n" verts_to_get_colors.numberSet

				vertex_colors[ color_of_vert as string ] = mesh_verts_by_color

				verts_to_get_colors -= mesh_verts_by_color
				--format "\nverts_to_get_colors	= % \n" verts_to_get_colors
				--format "verts_to_get_colors.numberSet	= % \n" verts_to_get_colors.numberSet
				--counter += 1  -- DEV
			)
		)
		else
			vertex_colors[ obj.wirecolor as string ] = verts_to_get_colors
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
	/**
	 */
	on create do
	(
		MeshVertToColorVertexConvert = MeshVertToColorVertexConvertor_v(obj)


	)

)
