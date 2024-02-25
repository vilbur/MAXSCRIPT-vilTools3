

if VERTEX_POS_AND_NORMALS == undefined then
	global VERTEX_POS_AND_NORMALS = Dictionary #string



/** Editable poly vertex getter
 */
struct EditablePolyVertexGetter_v
(
	/* construct */
	obj,	-- object used for getting data ( collapsed copy of obj  OR obj if it is Edit_Poly )

	/* properties */

	verts_to_generate	= #{},	-- selected or colored verts of  object
	verts_positions	= #(),	-- positions only of verts_to_generate
	verts_normals	= #(),	-- normals only of verts_to_generate
	vertex_colors	= Dictionary #string,	 -- vertex colors of all verts

	verts_data      = #(), -- 2d matrix #( #{verts_to_generate}, #( verts_positions ), #( verts_normals ), #( vertex_colors )   )

	--platform_vertex_data_key = "platform_vertex_data",

	/* dependency */

	/* reference */
	/* inhered */

	/** Get vertex positions, color and normals from Editable Poly obejct
	  *
	  */
	function setVertsData _obj quiet:false =
	(
		format "\n"; print "EditablePolyVertexGetter_v.setVertsData()"
		--format "_obj	= % \n" _obj

		timer_setVertsData = timeStamp()

		this.obj = _obj

		object_pointer = (getHandleByAnim obj) as string
		verts_count	= getNumVerts obj.mesh
		verts_all	= #{1..(verts_count)}
		vertex_sel	= getVertSelection obj.mesh --else #{} -- ignore vertex selection if not suobject level active
		verts_count_VC	= getNumCPVVerts obj.mesh

		--format "verts_count	= % \n" verts_count
		--format "verts_count_VC	= % \n" verts_count_VC


		this._setVertexColors verts_to_get:verts_all vertex_colors_exists:(verts_count_VC != 0)
		--format "\n _setVertexColors: % ms\n" (( timeStamp()) - timer_setVertsData)

		 --for vert_color in vertex_colors.keys do
			--format "%	= % \n" vert_color vertex_colors[vert_color]

		verts_to_generate = case of
		(
			/* GET SELECTED VERTS */
			(not vertex_sel.isEmpty and subObjectLevel == 1 ): vertex_sel

			/* GET COLORED VERTS - NOT WHITE COLOR */
			(vertex_colors.keys.count > 1): verts_all - vertex_colors[ white as string ]

			/* VERTEX COLORS NOT EXISTS */
			default: verts_all
		)

		/* WARNING IF ALL VERTS ARE USED */
		if verts_count != verts_to_generate.numberSet or queryBox ("USE ALL "+ verts_count as string +" VERTS ?") title:"SET VERTS DATA"  then
		(
			verts_data 	= VERTEX_POS_AND_NORMALS[ object_pointer ]
			verts_changed	= verts_data != undefined and ( verts_data[1] - verts_to_generate ).isEmpty == false

			if verts_data == undefined or verts_changed then
			(
				this._setVertexPositions()
				--format "\n\n getVerts: % ms\n" (( timeStamp()) - timer_setVertsData)
				--format "VERTS_POSITIONS	= % \n" VERTS_POSITIONS
				--format "verts_positions.count	= % \n" verts_positions.count

				this._setVertNormals()

				--format "\n\n getnormals: % ms\n" (( timeStamp()) - timer_setVertsData)
				--format "VERTS_NORMALS	= % \n" verts_normals
				--format "verts_normals.count	= % \n" verts_normals.count
			)
			else
				this._loadVertexData(verts_data)

			this.verts_data = #( verts_to_generate, verts_positions, verts_normals, this._getVertexColors()  )

			--format "\n setVertsData: % ms\n" (( timeStamp()) - timer_setVertsData)
			format "verts_data[1] count: % array: % \n" verts_data[1].numberSet verts_data[1]
			format "verts_data[2] count: % array: % \n" verts_data[2].count verts_data[2]
			format "verts_data[3] count: % array: % \n" verts_data[3].count verts_data[3]
			format "verts_data[4] count: % array: % \n" verts_data[4].count verts_data[4]


			--gc()
			VERTEX_POS_AND_NORMALS[ object_pointer ] = verts_data --return
		)

		this.verts_data --return
	),

	private

	/** Load vertex data
	 */
	function _loadVertexData verts_data =
	(
		--format "\n"; print "EditablePolyVertexGetter_v._laodVertexData()"
		this.verts_positions 	= verts_data[2]
		this.verts_normals	= verts_data[3]
	),

	/** Set vertex positions only of verts_to_generate
	 */
	function _setVertexPositions =
	(
		--format "\n"; print "EditablePolyVertexGetter_v._setVertexPositions()"
		this.verts_positions = meshop.getVerts obj.mesh verts_to_generate node:obj
	),

	/** Set vert normals only of verts_to_generate
	 */
	function _setVertNormals =
	(
		--format "\n"; print "EditablePolyVertexGetter_v._setVertNormals()"
		--this.verts_normals = for vert in verts_to_generate_arr collect ( getnormal obj.mesh vert )
		addModifier obj (_mod = Edit_Normals())

		this.verts_normals = for vert in verts_to_generate collect _mod.getNormal(vert)

		deleteModifier obj _mod
	),

	/** Get vertex colors
	 */
	function _getVertexColors =
	(
		format "\n"; print "EditablePolyVertexGetter_v._getVertexColors()"

		--for key in vertex_colors.keys where vertex_colors[key][vert] do return execute key
		--verts_arr = verts_to_generate as Array

		colors = for key in vertex_colors.keys collect execute key

		format "colors	= % \n" colors
		/* FIND VERTEX IN 2D matrix */

		--for v = 1 to verts_arr.numberSet collect
		for vert in verts_to_generate collect
		(
			colors_per_vert = for c = 1 to vertex_colors.count where this.vertex_colors[vertex_colors.keys[c]][vert] collect colors[c]

			colors_per_vert[1]  --return
		)
	),

	/** Set vertex colors Ditionary
	  *
	  * IMPORTAANT: OLORS ARE GET FRO MESH VERTS - NOT CVP VERTS !
	  *
	  * return Dictionary #( "Color 128 128 128", #{1..n} ) KEY: color VALUE: verts of that color
	  */
	function _setVertexColors verts_to_get: vertex_colors_exists: =
	(
		--format "\n"; print "EditablePolyVertexGetter_v._setVertexColors()"

		local map_verts = copy verts_to_get

		if vertex_colors_exists then
		(
			counter = 1

			while not map_verts.isEmpty do
			--while counter < 10 do
			(
				--format "\n\n"
				vertex_index = (map_verts as Array )[1]
				--format "MAP_VERTS	= % \n" map_verts

				color_of_vert = getvertcolor obj.mesh vertex_index -- get color of vertex
				--format "color_of_vert	= % \n" color_of_vert

				verts_by_color = meshop.getVertsByColor obj.mesh color_of_vert 0.01 0.01 0.01 	-- get all verts by thath color
				--format "verts_by_color	= % \n" verts_by_color
				vertex_colors[ color_of_vert as string ] = verts_by_color

				map_verts -= verts_by_color
				--counter = 1
			)
		)
		else
			vertex_colors[ obj.wirecolor as string ] = verts_to_get
	),


	/** Ask to continue
	  *
	  */
	function _askToContinue verts_count =
	(
		----format "\n"; print "EditablePolyVertexGetter_v._askToContinue()"
		_continue = true

		--if verts_to_generate.count > 500 and not queryBox ( verts_to_generate.count as string +" platforms will be generated.\n\nEstimated time: "+ estimated_time as string +" s\n\n   CONTINUE ?" ) title:"PLATFORMS GENERATION"  then
		if verts_count > 100 and not queryBox ( "Object " + obj.name + " has " + verts_count as string +" verts selected.\n\nIt may take some time.\n\nCONTINUE ?" ) title:"PLATFORMS GENERATION"  then
			 _continue =  false

		_continue --return
	),
	/**
	 */
	on create do
	(
	)
)
