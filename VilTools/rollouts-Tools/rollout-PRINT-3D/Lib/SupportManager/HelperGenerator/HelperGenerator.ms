/** Helper generator
 */
struct HelperGenerator_v
(
	/* construct */

	/* properties */
	point_helpers = Dictionary #integer,	-- Dictionary #( vert_number, point_helper )


	/* dependency */
	/* reference */
	/* inhered */
	Options,

	/** Generate instanced point helpers from selected verts
	  *
	  * @param node	source_obj to generate from
	  * @param Dictionary	point_helpers which allready exists
	  *
	  * @return Array of new created helpers
	  */
	function generatePointHelpers source_obj point_helpers_to_generate reset_helpers:true =
	(
		--format "\n"; print "HelperGenerator_v.generatePointHelpers()"
		--format "source_obj	= % \n" source_obj
		--format "point_helpers_to_generate	= % \n" point_helpers_to_generate

		function helperExists vertex_index = this.point_helpers[vertex_index] != undefined

		/* USE OBJECT WIRE COLOR IF VERTEX COLOR IS WHITE */
		function getWireColor source_obj wirecolor = if wirecolor != white then wirecolor else source_obj.wirecolor

		local point_helpers_new = #()

		/* SET EXISTING POINT HELPERS */
		if point_helpers_to_generate != undefined then this.point_helpers = point_helpers_to_generate

		/* GET VERTEX DATA */

		verts_data = if superClassOf source_obj != shape then
			(MeshVertexGetter_v(source_obj)).getVetexData()
		else
			(ShapeKnotGetter_v(source_obj)(Options.use_nth_vertex)).getVetexData()

		/* IF USER CANCEL GETTIN DATA */
		if verts_data == false then
			return point_helpers_new

		/* DELETE OLD POINTS */
		if reset_helpers then
			this._deleteOldPointHelpers(source_obj)(verts_data[1])

		this._setUserDataToSourceObject(source_obj)


		/* GENERATE POINTS FOR EACH VERTEX */
		for i = 1 to (verts_to_generate = verts_data[1] as Array ).count where not helperExists(verts_to_generate[i]) do -- where point helper does not exists
		(
			HelperObject = HelperObject_v Options:Options source_obj:source_obj vertex_index:verts_to_generate[i] pos:verts_data[2][i] normal:verts_data[3][i] wirecolor:(getWireColor(source_obj)(verts_data[4][i])) --point_helper:point_helpers[verts_to_generate[i]] -- get point helepr by vertex number

			if ( point_new = HelperObject.createHelper() ) != undefined then
			(
				this.point_helpers[HelperObject.vertex_index] = point_new -- IF POINT IS NOT CREATED, THEN VALUE IS undefined, so failed ponts can be managed too

				append point_helpers_new point_new
			)

		)

		--/* REINSTANCE ALL POINTS PER OBEJCT */
		this._reinstanceAllPoints()

		point_helpers_new --return
	),

	/** Get points
	 */
	function getMasterPointByObj obj =
	(
		--format "\n"; print "HelperGenerator_v.getMasterPointByObj()"

		while obj.parent != undefined and classOf obj.parent == Point do
			obj = obj.parent

		if (getUserPropVal obj "pointer_sync") != undefined then -- test if point is from support system
			obj --return
	),

	private
	/** Get vertex positions from spline
	  */
	function _getVertexPositionsFromShape source_shape =
	(
		--format "\n"; print "PlatformGenerator_v._getVertexPositionsFromShape()"
		/** Copy and collapse source spline
		  */
		function copyAndCollapseSourceObject source_objects =
		(
			nnl = #()

			maxOps.cloneNodes source_objects cloneType:#copy newNodes:&nnl

			convertTo nnl SplineShape

			nnl[1] --return
		)

		/** test if vertexx index is nth vertex in spline
		  */
		function isNthVertex index =
		(
			--format "\n"; print "PlatformGenerator_v.isNthVertex"
			is_nth_vertex = index == 1 or use_every_nth_vert_of_spline == 1 or ceil (test = (index - 1)/use_every_nth_vert_of_spline as float ) == test

			is_nth_vertex --return
		)


		--verts_data = #( #{ verts_to_get_bitarray }, #( verts_positions ), #( verts_normals ), #( vertex_colors )   )
		knots_data = #( #{ }, #(), #(), #()   )

		source_shapes = copyAndCollapseSourceObject( this._getSameChildren (source_shape) )

		/* Get platform object for each pline vertex */
		for spline_i = 1 to numSplines source_shapes do
			for knot_i = 1 to numKnots source_shapes spline_i where isNthVertex (knot_i) do
			(
				--PlatformObject = this._getPlatformObject(source_shape)(source_shape.wirecolor)
				/* add knot to generate */
				append knots_data[1] (knots_data[1].numberset +1)

				/* knot position  */
				append knots_data[2] (getKnotPoint source_shapes spline_i knot_i)

				/* knot normal  */
				append knots_data[3] [0,0, -1]

				/* knot wirecolor  */
				append knots_data[4] source_shapes.wirecolor
			)


		delete source_splines

		knots_data --return
	),

	/** set current pointer to source object
	  *
	  * BECAUSE POINTER IS CHANGI EACH TIME IS CENE LOADED
	 */
	function _setUserDataToSourceObject source_obj =
	(
		--format "\n"; print "HelperGenerator_v._setUserDataToSourceObject()"
		if (Options.getProp source_obj #source_object ) == undefined then
			 Options.setProp source_obj #source_object (getHandleByAnim source_obj )
	),

	/** Reinstance helper points
	  *S
	  * Each level of points is different instance
	  *
	  */
	function _reinstanceAllPoints =
	(
		--format "\n"; print "HelperGenerator_v._reinstanceAllPoints()"
		fn helpersInSameLevel point_trees i = for point_level in point_trees where point_level[i] != undefined and isValidNode point_level[i] collect point_level[i]

		point_trees = for vertex_index in point_helpers.keys collect this._getPointsChain( point_helpers[vertex_index] )

		max_count = amax (for point_tree in point_trees collect point_tree.count)

		max create mode

		if max_count != undefined then
			for i = 1 to max_count do
				this._reinstancePoint( helpersInSameLevel(point_trees)(i) )
	),

	/** Reinstance points
	  */
	function _reinstancePoint points_created =
	(
		--format "\n"; print "HelperGenerator_v._reinstancePoint()"
		if points_created.count < 2 then
			return false

		master_object	= points_created[1]

		for_replace = deleteItem points_created 1

		--for _point in for_replace do
		--	instanceReplace _point master_object

		for _point in for_replace do
			_point.baseobject = master_object.baseobject

	),


	/** Delete old points and platforms
	 */
	function _deleteOldPointHelpers source_obj verts_to_generate =
	(
		--format "\n"; print "HelperGenerator_v._deleteOldPointHelpers()"

		for vertex_index in point_helpers.keys where verts_to_generate[vertex_index] do
		(
			point_helper_cahin = this._getPointsChain(point_helpers[vertex_index])

			delete (this._getPointsChain(point_helpers[vertex_index]))

			this.point_helpers[vertex_index] = undefined
		)
	),

	/** Get point trees
	 */
	function _getPointsChain point_helper =
	(
		--format "\n"; print "HelperGenerator_v.getPointTrees()"
		children = #()

		if isValidNode point_helper then
		(
			children = #(point_helper)

			this._getAllChildPoints(point_helper) (children)
		)

		children --return
	),

	mapped function _getAllChildPoints _node &children = ( if isValidNode _node then join children _node.children else return children; if _node.children.count > 0 and classOf _node.children[1] == Point then this._getAllChildPoints _node.children &children ),

	--mapped function _getAllChildren _node &children = ( join children _node.children; if _node.children.count > 0 then this._getAllChildren _node.children &children ),

	/**
	 */
	on create do
	(
		--format "\n"; print "HelperGenerator.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
