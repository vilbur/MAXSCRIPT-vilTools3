/** Editable poly vertex getter
 */
struct EditablePolyVertexGetter_v
(
	/* construct */
	obj_source,
	obj_copy,	-- copy of object if obj_source must be collapsed
	obj_used, -- object used for getting data

	/* properties */
	PlatformObjects = #(),

	normal_length,
	vertex_colors,

	/* dependency */
	PlatformObjectInstance,

	/* reference */
	/* inhered */

	/** Get vertex positions, color and normals from Editable Poly obejct
	  *
	  */
	function getVertsData obj quiet:false =
	(
		--format "\n"; print "EditablePolyVertexGetter_v.getVertsData()"
		--format "obj:	% \n" obj
		this._setObjectUsed(obj)

		vertex_sel = getVertSelection obj_used.mesh

		verts_all = #{1..(getNumVerts obj_used.mesh)}

		vertex_colors	= this._getVertexColors verts_all:verts_all colored_verts_num:(getNumCPVVerts obj_used.mesh)

		verts_to_generate = if vertex_sel.isEmpty then verts_all else vertex_sel   -- get all verts if nothing selected

		/*------------------------------------------------------------------------------
			GET VERTEX POSITIONS FROM EDITABLE POLY
		--------------------------------------------------------------------------------*/

		verts_to_generate_arr = verts_to_generate as Array

		if not quiet and this._askToContinue (verts_to_generate_arr.count) then
			for i = 1 to verts_to_generate_arr.count do
			(
				format "\nGet Vert: % of %" i verts_to_generate_arr.count

				this._getVertexData(verts_to_generate_arr[i])
			)
			--for i in verts_to_generate as Array do

		--format "PlatformObjects.count:	% \n" PlatformObjects.count
		if obj_copy != undefined then
			delete obj_copy

		PlatformObjects --return
	),

	private


	/** Get vertex colors
	  *
	  * return Dictionary #( "Color 128 128 128", #{1..n} ) KEY: color VALUE: verts of that color
	  */
	function _getVertexColors verts_all: colored_verts_num: =
	(
		format "\n"; print "EditablePolyVertexGetter_v._getVertexColors()"

		/*------------------------------------------------------------------------------
			GET ALL VERTS IF ANY VERTEX COLOR EXISTS
		--------------------------------------------------------------------------------*/
		vertex_colors	= Dictionary #( "white", verts_all  )
		--format "1 vertex_colors:	% \n" vertex_colors.keys
		/*------------------------------------------------------------------------------
			GET OTEH VERTEX COLORS
		--------------------------------------------------------------------------------*/

		if colored_verts_num > 0 then
		(
			max modify mode
			--( modPanel.getCurrentObject()).unhideAll #Vertex

			verts_white = this._getVertsByColor(white)

			vertex_colors["white"] = verts_white

			colored_verts = verts_all - verts_white

			while not colored_verts.isEmpty do
			(
				vert_color = getvertcolor obj_used.mesh (colored_verts as Array )[1]

				verts_by_color = this._getVertsByColor (vert_color)

				vertex_colors[ vert_color as string ] = verts_by_color

				colored_verts = colored_verts - verts_by_color
			)
		)

		vertex_colors --return
	),

	/** Get vertex positions, color and normals from Editable Poly obejct
	  *
	  */
	function _getVertexData i =
	(
		----format "\n"; print "EditablePolyVertexGetter_v.getVertexData()"

		vert_pos =  polyop.getVert obj_used i

		normal = ( getnormal obj_used.mesh i) * obj_used.transform - obj_used.pos
		--format "normal:	% \n" normal
		wirecolor = if vertex_colors["white"][i] then obj_used.wirecolor else this._getColorByVertex (vertex_colors) (i)

		/* USE ONLY VERTICES FACING DOWN - dont use on platforms facing straight down ( -1 is is facing down, 1 is facing up ) */
		if normal.z <= 0 then
		(
			PlatformObject = this._getPlatformObject(wirecolor)

			PlatformObject.addVert(vert_pos)

			/* ADD ADDITIONAL VERT TO KEEP NORMAL */
			if normal.z > -0.95 and vert_pos.z > normal_length * 1.5 then -- if vert is little rotated horizontaly AND platform has enough space verticaly
			(
				--vert_pos = vert_pos + normal_length * normalize( normal )
				vert_pos += normal_length * normalize( normal )
				--format "normal:	% \n" normal

				/* MOVE POINT LITTLE DOWN IF NORMAL IS FACING TO SIDE */
				if normal.z > -0.25 then
					vert_pos.z -= normal_length

				PlatformObject.addVert( vert_pos )
			)

		)
		else
			format " NOT USED - VERTEX NORMAL IS FACING UP:  %" normal.z
	),

	/** Get color by vertex
	  *
	  */
	function _getColorByVertex vertex_colors i =
	(
		for key in vertex_colors.keys where vertex_colors[key][i] do return execute key
	),

	/** Get verts by color
	  */
	function _getVertsByColor clr =
	(
		--format "\n"; print "EditablePolyVertexGetter_v.getVertsByColor()"
		meshop.getVertsByColor obj_used.mesh clr 0.001 0.001 0.001 --return TRESHOLD FLOAT MUST NOT BE 0.0 - it causeses error in whie loop in this._getVertexColors()
	),

	/** Set object used for getting data
	  * Copy object if obj_source must be collapsed
	  */
	function _setObjectUsed obj =
	(
		--format "\n"; print "EditablePolyVertexGetter_v._setObjectUsed()"
		this.obj_source = obj

		this.obj_copy = undefined -- reset for next run on another object

		this.obj_used =	if classOf obj != Editable_Poly then
		(
			nnl = #()

			maxOps.cloneNodes obj cloneType:#copy newNodes:&nnl

			convertTo nnl Editable_Poly

			this.obj_copy = nnl[1]
		)
		else
			obj

	),

	/** Set platform object
	  *
	  */
	function _getPlatformObject wirecolor =
	(
		--format "\n"; print "EditablePolyVertexGetter_v._getPlatformObject()"
		--format "obj_source:	% \n" obj_source
		--format "wirecolor:	% \n" wirecolor

		PlatformObject = deepCopy PlatformObjectInstance

		PlatformObject.source_obj	= obj_source
		PlatformObject.wirecolor	= wirecolor

		append PlatformObjects PlatformObject

		PlatformObject --return
	),
	/** Ask to continue
	  *
	  */
	function _askToContinue verts_count =
	(
		--format "\n"; print "EditablePolyVertexGetter_v._askToContinue()"
		_continue = true

		--if verts_to_generate.count > 500 and not queryBox ( verts_to_generate.count as string +" platforms will be generated.\n\nEstimated time: "+ estimated_time as string +" s\n\n   CONTINUE ?" ) title:"PLATFORMS GENERATION"  then
		if verts_count > 100 and not queryBox ( "Object " + obj_used.name + " has " + verts_count as string +" verts selected.\n\nIt may take some time.\n\nCONTINUE ?" ) title:"PLATFORMS GENERATION"  then
			 _continue =  false

		_continue --return
	),
	/**
	 */
	on create do
	(
	)
)
