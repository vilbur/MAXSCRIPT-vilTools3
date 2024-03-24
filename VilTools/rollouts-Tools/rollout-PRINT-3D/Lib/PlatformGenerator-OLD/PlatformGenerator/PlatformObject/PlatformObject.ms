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
	points_positions = #(), -- vertex positions to generate platforms
	normal,
	wirecolor,	-- wirecolor of platform get from source object or vertex color
	point_helper,	-- generated point helper node

	/* dependency */

	/* reference */
	/* inhered */
	Options,	--PlatformOptions_v(),


	/** Fill vert data

	  * return this
	 */
	--function fillVertData vertex_index vert_data =
	function fillVertData vertex_index: pos: normal: wirecolor: =
	(
		--format "\n"; print "PlatformObject_v.fillVertData()"
		this.vertex_index	= vertex_index
		this.normal	= normal
		this.wirecolor	= wirecolor

		this._setPointPositions (pos)
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

		--format "points_positions:	% \n" points_positions

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

		points_created	= #()

		/*------------------------------------------------------------------------------
			GENERATE POINTS
		--------------------------------------------------------------------------------*/
		if not isValidNode point_helper then
			for i = 1 to this.points_positions.count do
			(
				vert_pos = this.points_positions[i]

				_point = Point pos:vert_pos size:(this.Options.bar_width) wirecolor:(shiftWirecolor(copy this.wirecolor)(i)) Box:(i==1) showLinks:true -- shift wirecolor slightly , to group each level of point selectabel by wirecolor

				/*------------------------------------------------------------------------------
					!!!!!!! ALL POINTS ARE LINKED TO FIRST OF SOURCEOBEJCT

					Should be improved to respect EACH source object
				--------------------------------------------------------------------------------*/
				/* IF FIRST TOP POINT OF PLATFORM */
				if i == 1 then
					this.point_helper = _point

				_point.parent = if i == 1 then source_obj else points_created[points_created.count]

				this._addToLayer (this.source_obj) (_point)

				append points_created _point
			)

		point_helper --return first point
	),

	/** Delete old points and platforms
	 */
	function deleteOldPointsAndPlatforms =
	(
		--format "\n"; print "PlatformObject_v.deleteOldPointsAndPlatforms()"
		--format "point_helper	= % \n" point_helper

		if isValidNode point_helper then
		(
			children = #(point_helper)

			this.getAllChildren(point_helper) (children)

			delete children
		)
	),

	/** Get points hierarchy
	  *
	  * @param Boolean pop_last retrun only last point of hierarchy
	  * @return Array|Point array of  point hierarchy
	 */
	function getPointsTree _point pop_last:false =
	(
		--format "\n"; print "PlatformObject_v.getPointsTree()"
		--mapped function getAllChildPoints _node &children = ( join children _node.children; if isValidNode _node and _node.children.count > 0 and classOf _node.children[1] == Point then getAllChildPoints _node.children &children )

		if isValidNode _point then
		(
			children = #(_point)

			this.getAllChildPoints(_point) (children)

			if pop_last then children[children.count] else children --return
		)
		else
			#() --return
	),

	private

	mapped function getAllChildPoints _node &children = ( if isValidNode _node then ( for child in _node.children where classOf child == Point do append children child ) else return children; if _node.children.count > 0 then this._getAllChildPoints _node.children &children ),

	mapped function getAllChildren _node &children = ( join children _node.children; if _node.children.count > 0 then this.getAllChildren _node.children &children ),

	/** Add vert pos
	  *
	  */
	function _setPointPositions vert_pos =
	(
		--format "\n"; print "PlatformObject_v._setPointPositions()"

		local normal = this.normal * source_obj.transform - source_obj.pos
		--local normal = this.normal

		/* USE ONLY VERTICES FACING DOWN OR SIDE - dont use on platforms facing straight down ( -1 is is facing down, 1 is facing up ) */
		if normal.z <= 0 then
		(
			append this.points_positions vert_pos

			normal_length = this.Options.normal_length

			/* ADD ADDITIONAL VERT TO KEEP NORMAL */
			if vert_pos.z > normal_length * 1.5 then -- if platform has enough space verticaly
			(
				--vert_pos = vert_pos + normal_length * normalize( normal )
				vert_pos += normal_length * normalize( normal )
				--format "normal:	% \n" normal

				/* MOVE POINT LITTLE DOWN IF NORMAL IS FACING TO SIDE */
				if normal.z > -0.25 then
					vert_pos.z -= normal_length

				append this.points_positions vert_pos
			)
		)
		else
			format "VERTEX: % NOT USED - VERTEX NORMAL IS FACING UP:  %" vertex_index normal.z

		--format "THIS.VERTS_POSITIONS	= % \n" this.points_positions
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

	/** Get parent of platform
	  *
	  * 1) RETURN LAST POINT OF HIERARCHY
	  * 2) RETURN SOURCE OBJECT IF POINTS DOES NOT EXITS
	  *
	  * @retrun node of last nested child point or source object
	  *
	 */
	function _getPlatformParent =
	(
		--format "\n"; print "PlatformObject_v._getLastChildrenOfIn()"
		parent = source_obj

		if classOf source_obj == Point  then
			this.getPointsTree (source_obj) pop_last:true
		--(
		--	child_point = child = source_obj.children[1]
		--
		--	while child != undefined do
		--	(
		--		child = child.children[1]
		--
		--		if child != undefined then
		--			child_point = child
		--	)
		--
		--	--format "CHILD_POINT	= % \n" child_point
		--
		--	if child_point != undefined then
		--		parent = child_point
		--)
		else
			source_obj --return
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
		for pos in points_positions do
			addKnot platform spline_index #corner #line pos


		/*------------------------------------------------------------------------------
			ABOVE GROUND POINT
		--------------------------------------------------------------------------------*/
		pos = points_positions[points_positions.count]

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
