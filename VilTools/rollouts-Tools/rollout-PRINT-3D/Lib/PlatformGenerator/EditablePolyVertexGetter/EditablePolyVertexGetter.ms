/** Editable poly vertex getter
 */
struct EditablePolyVertexGetter_v
(
	/* construct */
	obj,	-- object used for getting data ( collapsed copy of obj_source  OR obj_source if it is Edit_Poly )

	obj_source,	-- source object used for getting data
	obj_copy,	-- collapsed object used for getting data

	/* properties */
	--normal_length,

	--PlatformVerts = #(),

	verts_to_generate = #(),
	verts_positions	= #{},
	verts_by_colors = Dictionary #string,
	verts_data		= Dictionary #integer, -- 	  KEY:vert_index,  VALUE: #( vert pos, vert normal, vertex color, pointer to point helper or platform object )


	platform_vertex_data_key = "platform_vertex_data",

	/* dependency */
	--PlatformVertInstance,

	/* reference */
	/* inhered */

	/** Get vertex positions, color and normals from Editable Poly obejct
	  *
	  */
	function setVertsData _obj quiet:false =
	(
		format "\n"; print "EditablePolyVertexGetter_v.getVertsData()"
		------format "obj:	% \n" obj
		----format "this.verts_data	= % \n" this.verts_data

		this._setObjectUsed(_obj)

		verts_count	= getNumVerts obj.baseobject.mesh
		verts_all	= #{1..(verts_count)}
		vertex_sel	= getVertSelection obj.baseobject.mesh
		verts_count_VC	= polyop.getNumMapVerts obj.baseobject 0

		verts_to_generate = (if vertex_sel.isEmpty then verts_all else vertex_sel ) as Array   -- get all verts if nothing selected

		/* FIX CPV vertex count -- getVErtColor doesn not work if verts_count and verts_count_VC is not equal  */
		if verts_count == verts_count_VC then
		(
			this._setVertexColors verts_to_get:verts_all colored_verts_num:( polyop.getNumMapVerts obj.baseobject 0)

			verts_positions = polyop.getVerts obj.baseobject verts_all node:obj

			this._loadVertsData()

			--if not quiet and this._askToContinue (verts_to_generate.count) then
			for i = 1 to verts_to_generate.count do
				this._updateVertexData(i)

			this._saveVertsData()

			if obj_copy != undefined then
				delete obj_copy
		)
		else
		(
			messageBox "VERTEX COUNT AND COUNT OF COLORED VERTS IS NOT EQUAL" title:"ERROR"
			--polyop.setNumMapVerts obj.baseObject 0 verts_count keep:true
		)

		this.verts_data --return
	),

	/** Add point helper
	 */
	function addPointHelper vertex_index point_helper =
	(
		--format "\n"; print "EditablePolyVertexGetter_v.addPointHelper()"
		--format "POINT_HELPER	= % \n" point_helper
		verts_data[vertex_index][4] = getHandleByAnim point_helper

		this._saveVertsData()
	),

	private

	/** Set user prop data
	 */
	function _loadVertsData =
	(
		--format "\n"; print "EditablePolyVertexGetter_v._loadVertsData()"
		if ( user_prop_data_loaded = getUserPropVal obj_source platform_vertex_data_key asString:false ) != undefined then
			this.verts_data = user_prop_data_loaded
	),

	/** Set user prop data
	 */
	function _saveVertsData =
	(
		setUserPropVal obj_source platform_vertex_data_key verts_data quoteStrings:true
	),

	/** Get vertex positions, color and normals from Editable Poly obejct
	  *
	  */
	function _updateVertexData i =
	(
		--format "\n"; print "EditablePolyVertexGetter_v._updateVertexData()"

		fn positionChanged p1 p2 eps:1e-3 = distance p1 p2 > eps

		vert = verts_to_generate[i] -- vertex index

		vert_pos =  verts_positions[vert]

		verts_data_loaded = deepCopy this.verts_data[vert]

		position_changed = verts_data_loaded == undefined or (verts_data_loaded != undefined and positionChanged (vert_pos) (verts_data_loaded[1]) )

		/* UPDATE VERTEX DATA */
		if position_changed then
		(
			format "\nGet Vert: % of %" i verts_to_generate.count

			this.verts_data[vert] = this._getVertData (vert)
		)

		/* RESTORE POINT HELPER from loaded data */
		 if verts_data_loaded != undefined and isValidNode (getAnimByHandle verts_data_loaded[4]) then
			this.verts_data[vert][4] = verts_data_loaded[4]
	),

	/** Set vert data

	  *  #( vert pos, vert normal, vertex color  )
	  *
	 */
	function _getVertData vert =
	(
		--format "\n"; print "EditablePolyVertexGetter_v._getVertData()"
		#(
			verts_positions[vert],	-- vertext pos
			getnormal obj.mesh vert,	-- vertex normal
			this._getColorByVertex (vert)	-- vertex color
		)
	),

	/** Get vertex colors
	  *
	  * return Dictionary #( "Color 128 128 128", #{1..n} ) KEY: color VALUE: verts of that color
	  */
	function _setVertexColors verts_to_get: colored_verts_num: =
	(
		----format "\n"; print "EditablePolyVertexGetter_v._setVertexColors()"

		/* GET VERTEX COLORS CRASH IF GET VERTEX COUNT AND COUNT OF COLORED VERTS IS NOT EQUAL

			CODE BELLOW FIX PROBLEM< BUT IT RESET VERTEX COLORS TOO


			if verts_count != colored_verts_num then
				polyop.defaultMapFaces obj.baseobject 0 --true

		*/

		/*------------------------------------------------------------------------------
			GET OTEH VERTEX COLORS
		--------------------------------------------------------------------------------*/
			----format "verts_to_get.count START	= % \n" (verts_to_get as Array ).count


		processed_verts = #{}

		last_count = 0

		while not verts_to_get.isEmpty do
		(
			----format "\n\n\n"
			vertex_index = (verts_to_get as Array )[1]
			----format "vertex_index	= % \n" vertex_index

			----format "processed_verts[vertex_index]	= % \n" processed_verts[vertex_index]

			if not  processed_verts[vertex_index]  then
			(
				color_of_vert = getvertcolor obj.baseobject.mesh  vertex_index
				----format "color_of_vert	= % \n" color_of_vert

				verts_by_color = this._getVertsByColor (color_of_vert)

				----format "verts_by_color[511443]	= % \n" verts_by_color[511443]


				processed_verts += verts_by_color

				----format "verts_by_color	= % \n" verts_by_color
				----format "verts_by_color.count	= % \n" (verts_by_color as Array ).count

				verts_by_colors[ color_of_vert as string ] = verts_by_color
				----format "verts_by_colors.keys	= % \n" verts_by_colors.keys


				--verts_to_get = verts_to_get - verts_by_color
				verts_to_get -= verts_by_color
				----format "VERTS_TO_GET	= % \n" verts_to_get

				if last_count == (verts_to_get as Array ).count then
				(
					print "------------- EXIT ----------"

					$.EditablePoly.SetSelection #Vertex verts_to_get

					subObjectLevel = 1
					exit
				)

				last_count = (verts_to_get as Array ).count
				----format "verts_to_get.count	= % \n" (verts_to_get as Array ).count

			) else
			(

				print "------------- SHIT ----------"



				exit
			)

			--i +=1
		)
	),


	/** Get color by vertex
	  *
	  */
	function _getColorByVertex i =
	(
		for key in verts_by_colors.keys where verts_by_colors[key][i] do return execute key
	),

	/** Get verts by color
	  */
	function _getVertsByColor clr =
	(
		----format "\n"; print "EditablePolyVertexGetter_v.getVertsByColor()"
		meshop.getVertsByColor obj.baseobject.mesh clr 0.0001 0.0001 0.0001 --return TRESHOLD FLOAT MUST NOT BE 0.0 - it causeses error in whie loop in this._setVertexColors()
	),

	/** Set object used for getting data
	  * Copy object if obj_source must be collapsed
	  */
	function _setObjectUsed obj =
	(
		----format "\n"; print "EditablePolyVertexGetter_v._setObjectUsed()"
		this.obj_source = obj

		this.obj_copy = undefined -- reset for next run on another object

		this.obj =	if classOf obj != Editable_Poly then
		(
			nnl = #()

			maxOps.cloneNodes obj cloneType:#copy newNodes:&nnl

			convertTo nnl Editable_Poly

			this.obj_copy = nnl[1]
		)
		else
			obj

	),

	--/** Set platform object
	--  *
	--  */
	--function _getPlatformVert wirecolor =
	--(
	--	----format "\n"; print "EditablePolyVertexGetter_v._getPlatformVert()"
	--	----format "obj_source:	% \n" obj_source
	--	----format "wirecolor:	% \n" wirecolor
	--
	--	PlatformVert = deepCopy PlatformVertInstance
	--
	--	PlatformVert.source_obj	= obj_source
	--	PlatformVert.wirecolor	= wirecolor
	--
	--	append PlatformVerts PlatformVert
	--
	--	PlatformVert --return
	--),
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
