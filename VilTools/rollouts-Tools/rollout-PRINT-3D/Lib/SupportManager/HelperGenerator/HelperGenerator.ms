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
	  */
	function generatePointHelpers source_obj point_helpers =
	(
		format "\n"; print "HelperGenerator_v.generatePointHelpers()"
		format "POINT_HELPERS	= % \n" point_helpers
		fn helperExists vertex_index = this.point_helpers[vertex_index] != undefined

		if point_helpers != undefined then
			this.point_helpers = point_helpers

		verts_data = (MeshVertexGetter_v(source_obj)).getVetexData()
		format "verts_data	= % \n" verts_data[1]

		for i = 1 to (verts_to_generate = verts_data[1] as Array ).count where not helperExists(verts_to_generate[i]) do -- where point helper does not exists
		(
			HelperObject = HelperObject_v Options:Options source_obj:source_obj vertex_index:verts_to_generate[i] pos:verts_data[2][i] normal:verts_data[3][i] wirecolor:verts_data[4][i] --point_helper:point_helpers[verts_to_generate[i]] -- get point helepr by vertex number

			HelperObject.createHelper()

			this.point_helpers[HelperObject.vertex_index] = HelperObject.point_helper
		)

		this._reinstanceAllPoints()

		point_helpers --return
	),


	private

	/** Reinstance helper points
	  *
	  * Each level of points is different instance
	  *
	  */
	function _reinstanceAllPoints =
	(
		--format "\n"; print "HelperGenerator_v._reinstancePoints()"
		fn helpersInSameLevel point_trees i = for point_level in point_trees where point_level[i] != undefined and isValidNode point_level[i] collect point_level[i]

		point_trees = for vertex_index in point_helpers.keys collect this._getPointTree( point_helpers[vertex_index] )

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

	/** Get point trees
	 */
	function _getPointTree point_helper =
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

	/**
	 */
	on create do
	(
		--format "\n"; print "HelperGenerator.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
