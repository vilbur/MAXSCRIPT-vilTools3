/** Create platform object from given data
 */
struct PlatformObject_v
(
	/* construct */
	source_obj,
	vertex_index,

	/* properties */
	platform, -- save node of platform


	/* vert_data */
	verts_positions = #(), -- vertex positions to generate platforms
	normal,
	wirecolor,	-- wirecolor of platform get from source object or vertex color
	point_helper,	-- IntegerPtr to point helper

	/* dependency */

	/* reference */
	/* inhered */
	Options,	--PlatformOptions_v(),


	/** Fill vert data

	  * return this
	 */
	function fillVertData vert_data =
	(
		format "\n"; print "PlatformObject_v.fillVertData()"
		format "VERT_DATA	= % \n" vert_data

		this.vertex_index = vert_data.key

		normal	= vert_data.value[2]
		wirecolor	= vert_data.value[3]

		this._addVert (vert_data.value[1])

		this --return
	),

	/** Generate platform
	  *l
	  */
	function generatePlatform =
	(
		--format "\n"; print "PlatformObject_v.generatePlatform()"
		--format "this.normal:	% \n" this.normal
		--format "this.wirecolor:	% \n" this.wirecolor

		platform = SplineShape name:( source_obj.name + "-platform" ) wirecolor:(this.shiftWirecolor(1))

		--format "verts_positions:	% \n" verts_positions

		platform_parent = this._getPlatformParent()
		--format "PLATFORM_PARENT	= % \n" PLATFORM_PARENT

		this._createLineFromPoints()

		platform.parent = platform_parent

		platform --return
	),

	/** Generate point helper
	 */
	function generatePointHelper =
	(
		--format "\n"; print "PlatformObject_v.generatePointHelper()"
		/** Shift wirecolor sligtly
		  * Each level of points has different wirecolor for better selection
		  */
		function shiftWirecolor wirecolor i =
		(
			--format "\n"; print "PlatformGenerator_v.shiftWirecolor()"
			--format "wirecolor:	% \n" wirecolor
			if wirecolor.r >= i then wirecolor.r -= i
			if wirecolor.g >= i then wirecolor.g -= i
			if wirecolor.b >= i then wirecolor.b -= i
			--format "wirecolor:	% \n" wirecolor

			wirecolor --return
		)

		/** Reinstance points
		  */
		function reinstancePoints points_created =
		(
			format "\n"; print "PlatformGenerator_v.reinstancePoints()"
			if points_created.count < 2 then
				return false

			master_object	= points_created[1]

			for_replace = deleteItem points_created 1

			for _point in for_replace do
				instanceReplace _point master_object
		)

		local point_helper
		points_created	= #()
		--points_first	= #()

		/*------------------------------------------------------------------------------
			GENERATE POINTS
		--------------------------------------------------------------------------------*/

		for i = 1 to this.verts_positions.count do
		(
			--i=1
			vert_pos = this.verts_positions[i]

			_point = Point pos:vert_pos size:(this.Options.bar_width / 2 ) wirecolor:(shiftWirecolor(copy this.wirecolor)(i)) Box:(i==1) showLinks:true -- shift wirecolor slightly , to group each level of point selectabel by wirecolor

			--_point.showLinks = true

			/* IF FIRST TOP POINT OF PLATFORM */
			if i == 1 then
			(
				/*------------------------------------------------------------------------------
					!!!!!!! ALL POINTS ARE LINKED TO FIRST OF SOURCEOBEJCT

					Should be improved to respect EACH source object
				--------------------------------------------------------------------------------*/
				--this.point_helper = getHandleByAnim  _point
				this.point_helper = _point

				_point.parent = source_object

				--append points_first _point
			)
			else
				_point.parent =  points_created[points_created.count]


			this._addToLayer (this.source_obj) (_point)

			append points_created _point
		)

		--reinstancePoints (points_first) --return

		point_helper --return
	),

	private

	/** Add vert pos
	  *
	  */
	function _addVert vert_pos =
	(
		format "\n"; print "PlatformObject_v.addVertPos()"

		local normal = this.normal * source_obj.transform - source_obj.pos


		/* USE ONLY VERTICES FACING DOWN - dont use on platforms facing straight down ( -1 is is facing down, 1 is facing up ) */
		if normal.z <= 0 then
		(
			append this.verts_positions vert_pos

			normal_length = this.Options.normal_length

			/* ADD ADDITIONAL VERT TO KEEP NORMAL */
			--if normal.z > -0.95 and vert_pos.z > normal_length * 1.5 then -- if vert is little rotated horizontaly AND platform has enough space verticaly
			if vert_pos.z > normal_length * 1.5 then -- if platform has enough space verticaly
			(
				--vert_pos = vert_pos + normal_length * normalize( normal )
				vert_pos += normal_length * normalize( normal )
				--format "normal:	% \n" normal

				/* MOVE POINT LITTLE DOWN IF NORMAL IS FACING TO SIDE */
				if normal.z > -0.25 then
					vert_pos.z -= normal_length

				append this.verts_positions vert_pos
			)
		)
		else
			format " NOT USED - VERTEX NORMAL IS FACING UP:  %" normal.z

		format "THIS.VERTS_POSITIONS	= % \n" this.verts_positions
	),

	/** Add to layer
	 */
	function _addToLayer source_obj obj =
	(
		layer_name = source_obj.name + "-platforms"

		if ( layer = LayerManager.getLayerFromName (layer_name) ) == undefined then
			layer = LayerManager.newLayerFromName (layer_name)

		layer.setParent (source_obj.layer)

		layer.addNode obj
	),

	/** Get last children of point
	  *
	  * @retrun node of last nested child point or source object, if chldren does not eists
	  *
	 */
	function _getPlatformParent =
	(
		--format "\n"; print "PlatformObject_v._getLastChildrenOfIn()"
		parent = source_obj

		if classOf source_obj == Point  then
		(
			--local child_point

			child_point = child = source_obj.children[1]
			--format "child	= % \n" child

			while child != undefined do
			(
				child = child.children[1]
				--format "child	= % \n" child

				if child != undefined then
					child_point = child
			)

			--format "CHILD_POINT	= % \n" child_point

			if child_point != undefined then
				parent = child_point
		)

		parent --return
	),

	/** Create line for vertex
	  *
	  */
	function _createLineFromPoints =
	(
		--format "\n"; print "PlatformObject_v._createLineForVertex()"
		spline_index = 1

		addNewSpline platform


		/*------------------------------------------------------------------------------
			ADD KNOTS FROM TOP TO BOTTOM
		--------------------------------------------------------------------------------*/
		for pos in verts_positions do
			addKnot platform spline_index #corner #line pos


		/*------------------------------------------------------------------------------
			ABOVE GROUND POINT
		--------------------------------------------------------------------------------*/
		pos = verts_positions[verts_positions.count]

		pos.z = this.Options.base_height -- set knot above ground to set base height and keep last segment straight for extrude

		addKnot platform spline_index #corner #line pos

		pos.z = 0 -- set platform to ground


		/*------------------------------------------------------------------------------
			GROUND POINT
		--------------------------------------------------------------------------------*/
		addKnot platform spline_index #corner #line pos


		/*------ SET MATERIAL TO SEGMENTS ------*/
		num_of_segments = numSegments platform ( numSplines platform)

		for segment_i = 1 to num_of_segments do
			setMaterialID platform spline_index segment_i this.Options.mat_ids[#MIDDLE] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID>

		/*------ SET MATERIAL TO BOTTOM SEGMENT ------*/

		setMaterialID platform spline_index num_of_segments this.Options.mat_ids[#BASE] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID>

		updateShape platform
	),

	/** Shift wirecolor
	  *
	  */
	function shiftWirecolor i =
	(
		--format "\n"; print "PlatformGenerator_v.shiftWirecolor()"
		--format "wirecolor:	% \n" wirecolor

		wirecolor_shifted = copy wirecolor

		for key in #( #R, #G, #B ) do
		(
			new_value = if ( val = ( getProperty wirecolor key) + i) <= 255 then val else 255

			setProperty wirecolor_shifted key new_value
		)

		wirecolor_shifted --return
	),

	on create do ()
)
