global VERTEX_POS_AND_NORMALS = Dictionary #string

/** Editable poly vertex getter
 */
struct EditablePolyVertexGetter_v
(
	/* construct */
	obj,	-- object used for getting data ( collapsed copy of obj  OR obj if it is Edit_Poly )

	/* properties */

	verts_to_generate = #{},
	verts_positions	= #(),
	verts_normals	= #(),
	vertex_colors	= Dictionary #string,
	verts_data      = Dictionary #integer, -- KEY:vert_index,  VALUE: #( vert pos, vert normal, vertex color, pointer to point helper or platform object )


	platform_vertex_data_key = "platform_vertex_data",

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


		object_ponter = (getHandleByAnim obj) as string
		verts_count	= getNumVerts obj.mesh
		verts_all	= #{1..(verts_count)}
		vertex_sel	= getVertSelection obj.mesh --else #{} -- ignore vertex selection if not suobject level active
		verts_count_VC	= getNumCPVVerts obj.mesh

		format "verts_count	= % \n" verts_count
		format "verts_count_VC	= % \n" verts_count_VC


		this._setVertexColors verts_to_get:verts_all vertex_colors_exists:(verts_count_VC != 0)
		format "\n _setVertexColors: % ms\n" (( timeStamp()) - timer_setVertsData)

		 for vert_color in vertex_colors.keys do
			format "%	= % \n" vert_color vertex_colors[vert_color]

		verts_to_generate = case of
		(
			/* GET SELECTED VERTS */
			(not vertex_sel.isEmpty and subObjectLevel == 1 ): vertex_sel

			/* GET COLORED VERTS - NOT WHITE COLOR */
			(vertex_colors.keys.count > 1): verts_all - vertex_colors[ white as string ]

			/* VERTEX COLORS NOT EXISTS */
			default: verts_all
		)


		format "VERTS_TO_GENERATE	= % \n" VERTS_TO_GENERATE

		/* WARNING IF ALL VERTS ARE USED */
		if verts_count != verts_to_generate.numberSet or queryBox ("USE ALL "+ verts_count as string +" VERTS ?") title:"SET VERTS DATA"  then
		(
			verts_to_generate_arr = verts_to_generate as Array

			this._setVertexPositions()
			this._setVertNormals()

			format "verts_to_generate_arr.count	= % \n" verts_to_generate_arr.count

			format "\n\n getVerts: % ms\n" (( timeStamp()) - timer_setVertsData)

			format "VERTS_POSITIONS	= % \n" VERTS_POSITIONS
			format "verts_positions.count	= % \n" verts_positions.count

			format "\n\ngetnormals: % ms\n" (( timeStamp()) - timer_setVertsData)

			format "VERTS_NORMALS	= % \n" verts_normals
			format "verts_normals.count	= % \n" verts_normals.count


			for i = 1 to verts_to_generate_arr.count do
				this._getVertData(verts_to_generate_arr[i]) i

		--	--this._saveVertsData()
		--
		--	if obj_copy != undefined then
		--		delete obj_copy
		)

		VERTEX_POS_AND_NORMALS[ object_ponter ] = #( verts_to_generate, verts_positions, verts_normals )

		format "VERTEX_POS_AND_NORMALS	= % \n" VERTEX_POS_AND_NORMALS
		--else
		--(
		--	messageBox "VERTEX COUNT AND COUNT OF COLORED VERTS IS NOT EQUAL" title:"EditablePolyVertexGetter.ms"
		--	--polyop.setNumMapVerts obj.baseObject 0 verts_count keep:true
		--)
		--	--format "this.verts_data	= % \n" this.verts_data

		format "\n setVertsData: % ms\n" (( timeStamp()) - timer_setVertsData)

		gc()
		--this.verts_data --return
	),


	private

	/** Set vertex positions
	 */
	function _setVertexPositions =
	(
		--format "\n"; print "EditablePolyVertexGetter_v._setVertexPositions()"
		this.verts_positions = meshop.getVerts obj.mesh verts_to_generate node:obj
	),

	/** Set vert normals
	 */
	function _setVertNormals =
	(
		format "\n"; print "EditablePolyVertexGetter_v._setVertNormals()"
		--this.verts_normals = for vert in verts_to_generate_arr collect ( getnormal obj.mesh vert )
		addModifier obj (_mod = Edit_Normals())

		this.verts_normals = for i = 1 to (_mod.GetNumNormals()) collect
			_mod.getNormal(i)

		deleteModifier obj _mod

	),


	--/** Set user prop data
	-- */
	--function _saveVertsData =
	--(
	--	setUserPropVal obj platform_vertex_data_key verts_data quoteStrings:true
	--),

	/** Get vertex positions, color and normals from Editable Poly obejct
	  *
	  * @param integer vert
	  * @param integer index of vert in verts_to_generate_arr - just for message of progress
	  *
	  */
	function _getVertData vert i  =
	(
		--format "\n"; print "EditablePolyVertexGetter_v._getVertData()"

		if ( i / 10.0  ) == ceil ( i / 10.0 ) then
			format "Get Vert: % of %\n" i verts_to_generate.numberSet


		--fn positionChanged p1 p2 eps:1e-3 = distance p1 p2 > eps

		function _getColorByVertex vert =  for key in vertex_colors.keys where vertex_colors[key][vert] do return execute key
		--function _getColorByVertex vert =  red


		----vert	= verts_to_generate[i] -- vertex index
		----vert_pos	= verts_positions[vert]
		----vert_data	= this.verts_data[vert]
		----point_helper	= if vert_data != undefined and vert_data[4] != undefined and isValidNode (getAnimByHandle vert_data[4]) then vert_data[4]
		--
		----position_changed = vert_data == undefined or positionChanged (vert_pos) (vert_data[1])

		vert_data = #(
			verts_positions[vert],
			verts_normals[vert],
			_getColorByVertex (vert)
		)

		--if ( i / 10.0  ) == ceil ( i / 10.0 ) then
		--	format "vert_data	= % \n" vert_data
		--/* UPDATE VERTEX DATA */
		----if position_changed then
		this.verts_data[vert] = vert_data

		gc() -- IMPORTANT RUN AFTER EVERY ERTEX< OTHERWISE getnormal function CONSUME ALL MEMORY on objects with large vertex count > 500 000

		/* RESTORE POINT HELPER from loaded data */
		--this.verts_data[vert][4] = point_helper
	),


	/** Set vertex colors Ditionary
	  *
	  * IMPORTAANT: OLORS ARE GET FRO MESH VERTS - NOT CVP VERTS !
	  *
	  * return Dictionary #( "Color 128 128 128", #{1..n} ) KEY: color VALUE: verts of that color
	  */
	function _setVertexColors verts_to_get: vertex_colors_exists: =
	(
		format "\n"; print "EditablePolyVertexGetter_v._setVertexColors()"

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
