/** Support object
 */
struct SupportObject_v
(
	/* construct */

	/* properties */
	support,
	raft_mode = false,

	/* dependency */
	/* reference */
	/* inhered */
	Options,

	/** Generate support
	 */
	function generateSupport point_helper =
	(
		--format "\n"; print "SupportObject_v.generateSupport()"
		--format "point_helper	= % \n" point_helper

		support = SplineShape name:( point_helper.name + "-support" ) wirecolor:point_helper.wirecolor pos:point_helper.pos

		helpers_chain =  this._getPointsChain (point_helper)

		this._createLineFromPoints(helpers_chain)

		support.parent = helpers_chain[helpers_chain.count]

		support --return
	),

	private

	/** Create line netween point helpers
	  */
	function _createLineFromPoints helpers_chain =
	(
		--format "\n"; print "SupportObject_v._createLineForVertex()"
		--format "HELPERS_TREE: %\n" helpers_chain

		spline_index = 1

		addNewSpline support

		/*------------------------------------------------------------------------------
			ADD KNOTS FROM TOP TO BOTTOM
		--------------------------------------------------------------------------------*/
		for point_helper in helpers_chain do
			addKnot support spline_index #corner #line point_helper.pos

		if raft_mode then
			setMaterialID support spline_index 1 this.Options.mat_ids[#MIDDLE] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID>

		/*------------------------------------------------------------------------------
			ABOVE POINT ABOVE GROUND - NOT IF RAFT MODE
		--------------------------------------------------------------------------------*/
		if not raft_mode then
		(
			pos =  helpers_chain[helpers_chain.count].pos -- get pos of last point above ground

			pos.z = this.Options.base_height -- set knot above ground to set base height and keep last segment straight for extrude

			addKnot support spline_index #corner #line pos

			pos.z = 0 -- set support to ground


			/*------------------------------------------------------------------------------
				GROUND POINT
			--------------------------------------------------------------------------------*/
			addKnot support spline_index #corner #line pos


			/*------ SET MATERIAL TO SEGMENTS ------*/
			num_of_segments = numSegments support ( numSplines support)

			for segment_i = 1 to num_of_segments do
				setMaterialID support spline_index segment_i this.Options.mat_ids[#MIDDLE] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID>

			/*------ SET MATERIAL TO BOTTOM SEGMENT ------*/

			setMaterialID support spline_index num_of_segments this.Options.mat_ids[#BASE] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID>
		)

		updateShape support
	),

	/** Get points hierarchy
	  *
	  * @param Boolean pop_last retrun only last point of hierarchy
	  * @return Array|Point array of  point hierarchy
	 */
	function _getPointsChain master_point pop_last:false =
	(
		--format "\n"; print "SupportObject_v.getPointsTree()"
		--format "MASTER_POINT	= % \n" master_point

		if isValidNode master_point then
		(
			children = #(master_point)

			this.getAllChildPoints(master_point) (children)

			--for child in children do
			--format "child	= % \n" child

			if pop_last then children[children.count] else children --return
		)
		else
			#() --return
	),

	mapped function getAllChildPoints _node &children = ( if isValidNode _node then join children _node.children else return children; if _node.children.count > 0 and classOf _node.children[1] == Point then this.getAllChildPoints _node.children &children ),

	--mapped function getAllChildren _node &children = ( join children _node.children; if _node.children.count > 0 then this.getAllChildren _node.children &children ),

	/**
	 */
	on create do
	(
		--format "\n"; print "SupportObject_v.onCreate()"
		--format "Options	= % \n" Options
	)
)