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
	  */
	function generatePointHelpers source_obj point_helpers reset_helpers:true =
	(
		format "\n"; print "HelperGenerator_v.generatePointHelpers()"
		--format "POINT_HELPERS	= % \n" point_helpers

		fn helperExists vertex_index = this.point_helpers[vertex_index] != undefined

		/* USE OBJECT WIRE COLOR IF VERTEX COLOR IS WHITE */
		fn getWireColor source_obj wirecolor = if wirecolor != white then wirecolor else source_obj.wirecolor

		/* SET EXISTING POINT HELPERS */
		if point_helpers != undefined then this.point_helpers = point_helpers

		/* GET VERTEX DATA */
		verts_data = (MeshVertexGetter_v(source_obj)).getVetexData()

		/* IF USER CANCEL GETTIN DATA */
		if verts_data == false then
			return #()

		/* DELETE OLD POINTS */
		--if reset_helpers then
			--this._deleteOldPointHelpers(source_obj)(verts_data[1])

		this._saveSourcePointerToProps(source_obj)


		/* GENERATE POINTS FOR EACH VERTEX */
		for i = 1 to (verts_to_generate = verts_data[1] as Array ).count where not helperExists(verts_to_generate[i]) do -- where point helper does not exists
		(
			HelperObject = HelperObject_v Options:Options source_obj:source_obj source_obj:source_obj vertex_index:verts_to_generate[i] pos:verts_data[2][i] normal:verts_data[3][i] wirecolor:(getWireColor(source_obj)(verts_data[4][i])) --point_helper:point_helpers[verts_to_generate[i]] -- get point helepr by vertex number

			HelperObject.createHelper()

			this.point_helpers[HelperObject.vertex_index] = HelperObject.point_helper
		)

		--/* REINSTANCE ALL POINTS PER OBEJCT */
		--this._reinstanceAllPoints()

		point_helpers --return
	),


	private

	/** set current pointer to source object
	  *
	  * BECAUSE POINTER IS CHANGI EACH TIME IS CENE LOADED
	 */
	function _saveSourcePointerToProps source_obj =
	(
		--format "\n"; print "HelperGenerator_v._saveSourcePointerToProps()"
		if (getUserPropVal source_obj "pointer_sync") == undefined then
			 setUserPropVal source_obj "pointer_sync" (getHandleByAnim source_obj ) asString:true
	),

	/** Reinstance helper points
	  *S
	  * Each level of points is different instance
	  *
	  */
	function _reinstanceAllPoints =
	(
		--format "\n"; print "HelperGenerator_v._reinstancePoints()"
		fn helpersInSameLevel point_trees i = for point_level in point_trees where point_level[i] != undefined and isValidNode point_level[i] collect point_level[i]

		point_trees = for vertex_index in point_helpers.keys collect this._getPointsChain( point_helpers[vertex_index] )

		max_count = amax (for point_tree in point_trees collect point_tree.count)

		max create mode

		if max_count != undefined then
			for i = 1 to max_count do
				this._reinstancePoints( helpersInSameLevel(point_trees)(i) )
	),

	/** Reinstance points
	  */
	function _reinstancePoints points_created =
	(
		--format "\n"; print "HelperGenerator_v._reinstancePoints()"
		if points_created.count < 2 then
			return false

		master_object	= points_created[1]

		for_replace = deleteItem points_created 1

		for _point in for_replace do
			instanceReplace _point master_object
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
