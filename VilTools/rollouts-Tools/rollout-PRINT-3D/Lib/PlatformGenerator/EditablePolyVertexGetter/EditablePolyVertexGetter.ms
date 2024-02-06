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

	verts_to_generate_arr = #(),
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
	function getVertsData _obj quiet:false =
	(
		--format "\n"; print "EditablePolyVertexGetter_v.getVertsData()"
		----format "obj:	% \n" obj
		--format "this.verts_data	= % \n" this.verts_data

		this._setObjectUsed(_obj)

		verts_count	= getNumVerts obj.baseobject.mesh
		verts_all	= #{1..(verts_count)}
		vertex_sel	= getVertSelection obj.baseobject.mesh
		verts_count_VC	= polyop.getNumMapVerts obj.baseobject 0

		verts_to_generate = if vertex_sel.isEmpty then verts_all else vertex_sel   -- get all verts if nothing selected
		--
		----format "verts_count	= % \n" verts_count
		----format "verts_all	= % \n" verts_all
		----format "verts_count_VC	= % \n" (polyop.getNumMapVerts obj.baseobject 0)

		/* FIX CPV vertex count -- getVErtColor doesn not work if verts_count and verts_count_VC is not equal  */
		if verts_count == verts_count_VC then
		(

			--format "verts_count	= % \n" verts_count
			--format "verts_count_VC	= % \n" (polyop.getNumMapVerts obj.baseobject 0)

			this._setVertexColors verts_to_get:verts_all colored_verts_num:( polyop.getNumMapVerts obj.baseobject 0)

			verts_to_generate_arr = verts_to_generate as Array

			verts_positions = polyop.getVerts obj.baseobject verts_all node:obj

			this._setUserPropData()

			if not quiet and this._askToContinue (verts_to_generate_arr.count) then
				for i = 1 to verts_to_generate_arr.count do
					this._getVertexData(i)

			----format "PlatformVerts.count:	% \n" PlatformVerts.count
			if obj_copy != undefined then
				delete obj_copy

			setUserPropVal obj_source platform_vertex_data_key verts_data
		)
		else
		(
			--format "getNumVerts	= % \n" verts_count
			--format "getNumMapVerts	= % \n" verts_count_VC

			messageBox "VERTEX COUNT AND COUNT OF COLORED VERTS IS NOT EQUAL" title:"ERROR"
			--polyop.setNumMapVerts obj.baseObject 0 verts_count keep:true
		)

		verts_data --return
	),

	/** Add point helper
	 */
	function addPointHelper PlatformObject =
	(
		--format "\n"; print "EditablePolyVertexGetter_v.addPointHelper()"

		verts_data[PlatformObject.vertex_index][4] = PlatformObject.point_helper

		setUserPropVal obj_source platform_vertex_data_key verts_data
	),

	private

	/** Set user prop data
	 */
	function _setUserPropData =
	(
		--format "\n"; print "EditablePolyVertexGetter_v.setUserPropData()"
		_user_prop_data = getUserPropVal obj_source platform_vertex_data_key

		if _user_prop_data  == undefined then
			for vert in verts_to_generate_arr do
				this._setVertData (vert)
		else
			this.verts_data = _user_prop_data

	),

	/** Set vert data

	  *  #( vert pos, vert normal, vertex color  )
	  *
	 */
	function _setVertData vert =
	(
		--format "\n"; print "EditablePolyVertexGetter_v._setVertData()"
		--format "this.verts_data	= % \n" this.verts_data
		this.verts_data[vert] = #( verts_positions[vert], getnormal obj.mesh vert, this._getColorByVertex (vert) )
	),

	/** Get vertex colors
	  *
	  * return Dictionary #( "Color 128 128 128", #{1..n} ) KEY: color VALUE: verts of that color
	  */
	function _setVertexColors verts_to_get: colored_verts_num: =
	(
		format "\n"; print "EditablePolyVertexGetter_v._setVertexColors()"

		/* GET VERTEX COLORS CRASH IF GET VERTEX COUNT AND COUNT OF COLORED VERTS IS NOT EQUAL

			CODE BELLOW FIX PROBLEM< BUT IT RESET VERTEX COLORS TOO


			if verts_count != colored_verts_num then
				polyop.defaultMapFaces obj.baseobject 0 --true

		*/

		/*------------------------------------------------------------------------------
			GET OTEH VERTEX COLORS
		--------------------------------------------------------------------------------*/
			format "verts_to_get.count START	= % \n" (verts_to_get as Array ).count


		processed_verts = #{}

		last_count = 0

		while not verts_to_get.isEmpty do
		(
			format "\n\n\n"
			vertex_index = (verts_to_get as Array )[1]
			format "vertex_index	= % \n" vertex_index

			format "processed_verts[vertex_index]	= % \n" processed_verts[vertex_index]

			if not  processed_verts[vertex_index]  then
			(
				color_of_vert = getvertcolor obj.baseobject.mesh  vertex_index
				format "color_of_vert	= % \n" color_of_vert

				verts_by_color = this._getVertsByColor (color_of_vert)

				format "verts_by_color[511443]	= % \n" verts_by_color[511443]


				processed_verts += verts_by_color

				format "verts_by_color	= % \n" verts_by_color
				format "verts_by_color.count	= % \n" (verts_by_color as Array ).count

				verts_by_colors[ color_of_vert as string ] = verts_by_color
				format "verts_by_colors.keys	= % \n" verts_by_colors.keys


				--verts_to_get = verts_to_get - verts_by_color
				verts_to_get -= verts_by_color
				format "VERTS_TO_GET	= % \n" verts_to_get

				if last_count == (verts_to_get as Array ).count then
				(
					print "------------- EXIT ----------"

					$.EditablePoly.SetSelection #Vertex verts_to_get

					subObjectLevel = 1
					exit
				)

				last_count = (verts_to_get as Array ).count
				format "verts_to_get.count	= % \n" (verts_to_get as Array ).count

			) else
			(

				print "------------- SHIT ----------"



				exit
			)

			--i +=1
		)
	),

	/** Get vertex positions, color and normals from Editable Poly obejct
	  *
	  */
	function _getVertexData i =
	(
		--format "\n"; print "EditablePolyVertexGetter_v.getVertexData()"
		format "\nGet Vert: % of %" i verts_to_generate_arr.count

		vert = verts_to_generate_arr[i] -- vertex index

		vert_pos =  verts_positions[vert]

		if verts_data[vert] == undefined or vert_pos != verts_data[vert][1]  then
			this._setVertData (vert)
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
		--format "\n"; print "EditablePolyVertexGetter_v.getVertsByColor()"
		meshop.getVertsByColor obj.baseobject.mesh clr 0.0001 0.0001 0.0001 --return TRESHOLD FLOAT MUST NOT BE 0.0 - it causeses error in whie loop in this._setVertexColors()
	),

	/** Set object used for getting data
	  * Copy object if obj_source must be collapsed
	  */
	function _setObjectUsed obj =
	(
		--format "\n"; print "EditablePolyVertexGetter_v._setObjectUsed()"
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
	--	--format "\n"; print "EditablePolyVertexGetter_v._getPlatformVert()"
	--	--format "obj_source:	% \n" obj_source
	--	--format "wirecolor:	% \n" wirecolor
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
		--format "\n"; print "EditablePolyVertexGetter_v._askToContinue()"
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
