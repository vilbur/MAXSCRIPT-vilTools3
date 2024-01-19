/** Editable poly vertex getter
 */
struct EditablePolyVertexGetter_v
(
	/* construct */
	obj_source,
	obj_copy,	-- copy of object if obj_source must be collapsed

	obj_used, -- object used for getting data

	PlatformObjectInstance,

	/* properties */
	PlatformObjects = #(),


	normal_length,
	/* dependency */
	/* reference */
	/* inhered */


	/** Get vertex positions, color and normals from Editable Poly obejct
	  *
	  */
	function getVertsData =
	(
		--format "\n"; print "EditablePolyVertexGetter_v.getVertsData()"
		--format "obj_source:	% \n" obj_source


		this._setObjectUsed()

		vertex_sel  	= (getVertSelection obj_used.mesh )	as Array

		verts_all	= #{1..(getNumVerts obj_used.mesh)}

		vertex_colors	= this._getVertexColors verts_all:verts_all vertex_sel:vertex_sel colored_verts_num:(getNumCPVVerts obj_used.mesh)

		verts_to_generate = if vertex_sel.count != 0 then vertex_sel else verts_all   -- get all verts if nothing selected

		/*------------------------------------------------------------------------------
			GET VERTEX POSITIONS FROM EDITABLE POLY
		--------------------------------------------------------------------------------*/

		for i in verts_to_generate as Array do
		(
			format "i:	% \n" i
			vert_pos =  polyop.getVert obj_used i

			normal = ( getnormal obj_used.mesh i) * obj_used.transform - obj_used.pos
			--format "normal:	% \n" normal
			wirecolor = if vertex_colors["white"][i] then obj_used.wirecolor else this.getColorByVertex (vertex_colors) (i)

			/* USE ONLY VERTICES FACING DOWN */
			if normal.z <= 0 then
			(
				PlatformObject = this._getPlatformObject(wirecolor)

				PlatformObject.addVert(vert_pos)

				/* BUT NOT FACING STRAIGHT DOWN */
				if normal.z > -0.9 then -- dont use on platforms facing straight down ( -1 is is facing down, 1 is facing up )
					PlatformObject.addVert(vert_pos + normal_length * normalize( normal ) )
			)
		)

		if obj_copy != undefined then
		(
			delete obj_copy

			select obj_source
		)
		format "PlatformObjects.count:	% \n" PlatformObjects.count

	),

	/** Get color by vertex
	  *
	  */
	function getColorByVertex vertex_colors i =
	(
		for key in vertex_colors.keys where vertex_colors[key][i] do return execute key
	),

	/** Set object used for getting data
	  * Copy object if obj_source must be collapsed
	  */
	function _setObjectUsed =
	(
		format "\n"; print "PlatformGenerator_v.copyObjectIfNotEditableLy()"
		obj_used =	if classOf obj_source != Editable_Poly then
		(
			--obj_copy = obj_source
			nnl = #()

			maxOps.cloneNodes obj_source cloneType:#copy newNodes:&nnl

			convertTo nnl Editable_Poly

			select nnl[1]

			obj_copy = nnl[1]
		)
		else
			obj_source

	),

	private

	/** Get vertex colors
	  *
	  * return Dictionary #( "Color 128 128 128", #{1..n} ) KEY: color VALUE: verts of that color
	  */
	function _getVertexColors verts_all: vertex_sel: colored_verts_num: =
	(
		--format "\n"; print "PlatformGenerator_v._getVertexColors()"

		/*------------------------------------------------------------------------------
			GET ALL VERTS IF ANY VERTEX COLOR EXISTS
		--------------------------------------------------------------------------------*/

		vertex_colors	= Dictionary #( "white", verts_all  )

		/*------------------------------------------------------------------------------
			GET OTEH VERTEX COLORS
		--------------------------------------------------------------------------------*/

		if colored_verts_num > 0 then
		(
			verts_white = this._getVertsByColor (white)

			vertex_colors["white"] = verts_white

			colored_verts = verts_all - verts_white

			while not colored_verts.isEmpty do
			(
				vert_color = getvertcolor obj_used.mesh (colored_verts as Array )[1]

				verts_by_color = this._getVertsByColor (vert_color)

				vertex_colors[ vert_color as string ] = verts_by_color

				colored_verts -= verts_by_color

			)

			polyop.setVertSelection obj_used vertex_sel
		)

		vertex_colors --return
	),

	/** Get verts by color
	  */
	function _getVertsByColor clr =
	(
		format "\n"; print "PlatformGenerator_v.getVertsByColor()"
		obj_used.vertSelectionColor = clr

		max modify mode

		curr_mod = modPanel.getCurrentObject()
		format "curr_mod:	% \n" curr_mod

		curr_mod.ButtonOp #SelectByVertexColor

		getVertSelection obj_used.mesh
	),


	/** Set platform object
	  *
	  */
	function _getPlatformObject wirecolor =
	(
		--format "\n"; print "PlatformGenerator_v._getPlatformObject()"
		--format "obj_source:	% \n" obj_source
		--format "wirecolor:	% \n" wirecolor

		PlatformObject = deepCopy PlatformObjectInstance

		PlatformObject.source_obj	= obj_source
		PlatformObject.wirecolor	= wirecolor

		append PlatformObjects PlatformObject

		PlatformObject --return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "EditablePolyVertexGetter.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

	)
)
