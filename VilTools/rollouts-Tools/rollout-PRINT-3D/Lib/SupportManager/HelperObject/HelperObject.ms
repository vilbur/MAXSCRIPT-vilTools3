/** Helper object
 */
struct HelperObject_v
(
	/* construct */
	source_obj,
	vertex_index,
	pos,
	normal,
	wirecolor,

	/* properties */
	point_helper,

	points_positions = #(), -- vertex positions to generate platforms

	/* dependency */
	/* reference */
	/* inhered */
	Options,

	/** Create helper
	 */
	function createHelper =
	(
		format "\n"; print "HelperObject_v.createOrUpdateHelper()"
		format "point_helper	= % \n" this.point_helper

		points_created	= #()

		/*------------------------------------------------------------------------------
			GENERATE POINTS
		--------------------------------------------------------------------------------*/


		for i = 1 to this.points_positions.count do
		(
			--_point = Point pos:this.points_positions[i] size:(this.Options.bar_width) wirecolor:(this._shiftWirecolor(copy this.wirecolor)(i)) Box:(i==1) showLinks:true -- shift wirecolor slightly , to group each level of point selectabel by wirecolor
			_point = Point pos:this.points_positions[i] size:(this.Options.bar_width) wirecolor:wirecolor Box:(i==1) showLinks:true -- shift wirecolor slightly , to group each level of point selectabel by wirecolor

			/* SET FIRST TOP POINT OF SUPPORT AS MAIN POINT HELPER */
			if i == 1 then
				this.point_helper = _point

			/* LINK FIRST POINT TO SOURCE OBJECT, OTHER POINTS ARE LINKED IN CHAIN  */
			_point.parent = if i == 1 then source_obj else points_created[points_created.count]

			this._addToLayer (this.source_obj) (_point)

			this._saveUserDataToPointHelper()

			append points_created _point
		)

		point_helper --return first point

	),

	--/** Get points hierarchy
	--  *
	--  * @param Boolean pop_last retrun only last point of hierarchy
	--  * @return Array|Point array of  point hierarchy
	-- */
	--function getPointsTree pop_last:false =
	--(
	--	--format "\n"; print "PlatformObject_v.getPointsTree()"
	--	--mapped function getAllChildPoints _node &children = ( join children _node.children; if isValidNode _node and _node.children.count > 0 and classOf _node.children[1] == Point then getAllChildPoints _node.children &children )
	--
	--	if isValidNode point_helper then
	--	(
	--		children = #(point_helper)
	--
	--		this.getAllChildPoints(point_helper) (children)
	--
	--		if pop_last then children[children.count] else children --return
	--	)
	--	else
	--		#() --return
	--),

	private

	/** Add vert pos
	  *
	  */
	function _setPointPositions vert_pos =
	(
		--format "\n"; print "HelperObject_v._setPointPositions()"

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

	--/** Shift wirecolor sligtly
	--  * Each level of points has different wirecolor for better selection
	--  */
	--function _shiftWirecolor wirecolor i =
	--(
	--	--format "\n"; print "PlatformGenerator_v.shiftWirecolor()"
	--	--format "wirecolor:	% \n" wirecolor
	--	if wirecolor.r >= i then wirecolor.r -= i
	--	if wirecolor.g >= i then wirecolor.g -= i
	--	if wirecolor.b >= i then wirecolor.b -= i
	--	--format "wirecolor:	% \n" wirecolor
	--
	--	wirecolor --return
	--),

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


	/**
	 */
	function _saveUserDataToPointHelper =
	(
		--format "\n"; print "HelperObject_v.saveUserData()"
		setUserPropVal point_helper "helper_source" ( getHandleByAnim source_obj )
		setUserPropVal point_helper "this_pointer"	  ( getHandleByAnim point_helper )
		setUserPropVal point_helper "source_vert"	  ( vertex_index )

	),

	/**
	 */
	on create do
	(
		this._setPointPositions (pos)
	)
)