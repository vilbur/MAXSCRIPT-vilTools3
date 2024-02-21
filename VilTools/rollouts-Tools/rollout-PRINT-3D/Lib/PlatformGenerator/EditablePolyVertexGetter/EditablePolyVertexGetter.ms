/** Editable poly vertex getter
 */
struct EditablePolyVertexGetter_v
(
	/* construct */
	obj,	-- object used for getting data ( collapsed copy of obj_source  OR obj_source if it is Edit_Poly )

	obj_source,	-- source object used for getting data
	obj_copy,	-- collapsed object used for getting data

	/* properties */

	verts_to_generate = #(),
	verts_positions	= #{},
	verts_by_colors	= Dictionary #string,
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
		format "\n"; print "EditablePolyVertexGetter_v.getVertsData()"

		this._setObjectUsed(_obj)

		verts_count	= getNumVerts obj.baseobject.mesh
		verts_all	= #{1..(verts_count)}
		vertex_sel	= getVertSelection obj.baseobject.mesh --else #{} -- ignore vertex selection if not suobject level active
		verts_count_VC	= if polyop.getMapSupport obj.baseobject 0 then polyop.getNumMapVerts obj.baseobject 0

		if verts_count_VC != undefined then
			this._setVertexColors verts_to_get:verts_all colored_verts_num:verts_count_VC

		case of
		(
			/* GET SELECTED VERTS */
			(not vertex_sel.isEmpty): verts_to_generate = vertex_sel as Array

			/* GET COLORED VERTS - NOT WHITE COLOR */
			(verts_by_colors.keys.count > 1): for vert_color in verts_by_colors.keys where vert_color != white as string do
													join verts_to_generate (verts_by_colors[vert_color] as Array )

			/* VERTEX COLORS NOT EXISTS */
			default: verts_to_generate = verts_all as Array
		)

		/* WARN BEFORE USING ALL VERTS */
		if verts_count != verts_to_generate.count or queryBox ("USE ALL "+ verts_count +" VERTS ?") title:"SET VERTS DATA"  then
		(
			verts_positions = polyop.getVerts obj.baseobject verts_all node:obj

			this._loadVertsData()

			--if not quiet and this._askToContinue (verts_to_generate.count) then
			for i = 1 to verts_to_generate.count do
				this._updateVertexData(i)

			this._saveVertsData()

			if obj_copy != undefined then
				delete obj_copy
		)
		--else
		--(
		--	messageBox "VERTEX COUNT AND COUNT OF COLORED VERTS IS NOT EQUAL" title:"ERROR"
		--	--polyop.setNumMapVerts obj.baseObject 0 verts_count keep:true
		--)
		format "verts_to_generate.count	= % \n" verts_to_generate.count

		this.verts_data --return
	),

	/** Add point helper
	 */
	function addPointHelper vertex_index point_helper =
	(
		--format "\n"; print "EditablePolyVertexGetter_v.addPointHelper()"
		--format "POINT_HELPER	= % \n" point_helper

		if not isValidNode point_helper then
			return false

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

		vert	= verts_to_generate[i] -- vertex index
		vert_pos	=  verts_positions[vert]
		vert_data	= this.verts_data[vert]
		point_helper	= if vert_data != undefined and vert_data[4] != undefined and isValidNode (getAnimByHandle vert_data[4]) then vert_data[4]

		position_changed = vert_data == undefined or positionChanged (vert_pos) (vert_data[1])

		/* UPDATE VERTEX DATA */
		if position_changed then
			this.verts_data[vert] = this._getVertData (vert)(i)

		/* RESTORE POINT HELPER from loaded data */
		this.verts_data[vert][4] = point_helper
	),

	/** Set vert data

	  *  #( vert pos, vert normal, vertex color  )
	  *
	 */
	function _getVertData vert i =
	(
		--format "\n"; print "EditablePolyVertexGetter_v._getVertData()"
		format "\nGet Vert: % of %" i verts_to_generate.count

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
		--format "\n"; print "EditablePolyVertexGetter_v._setVertexColors()"

		/* GET VERTEX COLORS CRASH IF GET VERTEX COUNT AND COUNT OF COLORED VERTS IS NOT EQUAL

			CODE BELLOW FIX PROBLEM< BUT IT RESET VERTEX COLORS TOO


			if verts_count != colored_verts_num then
				polyop.defaultMapFaces obj.baseobject 0 --true

		*/

		/*------------------------------------------------------------------------------
			GET OTEH VERTEX COLORS
		--------------------------------------------------------------------------------*/
			----format "verts_to_get.count START	= % \n" (verts_to_get as Array ).count

		if colored_verts_num != undefined then
		(
			processed_verts = #{}

			--last_count = 0

			while not verts_to_get.isEmpty do
			(
				vertex_index = (verts_to_get as Array )[1]

				if not  processed_verts[vertex_index]  then
				(
					color_of_vert = getvertcolor obj.baseobject.mesh vertex_index -- get color of vertex

					verts_by_color = this._getVertsByColor (color_of_vert)	-- get all verts by thath color

					processed_verts += verts_by_color

					verts_by_colors[ color_of_vert as string ] = verts_by_color

					verts_to_get -= verts_by_color

					--last_count = (verts_to_get as Array ).count
				)
			)
		)
		else
			verts_by_colors[ obj_source.wirecolor as string ] = verts_to_get
	),


	/** Get color by vertex
	  *
	  */
	function _getColorByVertex i =
	(
		--format "\n"; print "EditablePolyVertexGetter_v._getColorByVertex()"
		--format "verts_by_colors.keys	= % \n" verts_by_colors.keys
		--format "verts_by_colors	= % \n" verts_by_colors
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
