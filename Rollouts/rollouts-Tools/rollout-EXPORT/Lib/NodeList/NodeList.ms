/** Methods for Lsitbox ROLLOUT_export.ML_nodes

 */
struct NodeList_v
(
	/* construct */
	nodelist_control,

	/* properties  */
	user_prop = "unreal-engine-export-node",

	/** Load nodes
	 */
	function loadNodes =
	(
		--print "NodeList_v.loadNodes()"
		nodelist_control.items = this._getNodeNames (this.getNodesInScene())
	),

	/** Select nodes in list
	 */
	function selectNodesInList nodes_to_select =
	(
		--format "\n"; print "NodeList_v.selectNodesInList()"

		nodes_to_select = this._getNodeNames(nodes_to_select)

		selected_indexes = for node_name in nodelist_control.items where findItem nodes_to_select node_name > 0 collect findItem nodelist_control.items node_name

		nodelist_control.selection = selected_indexes
	),

	/** Get selected items
	 */
	function getSelectedItemsInList =
	(
		selected_index = nodelist_control.selection as Array

		node_names	= nodelist_control.items

		for index in selected_index collect node_names[index] -- return
	),

	/** Gget selected nodes in mutlilistbox control
	 */
	function getSelectedNodesInScene =
	(
		--print "NodeList_v.getSelectedNodesInScene()"
		--nodes_selected_in_scene = this._getNodesInScene()
		for obj in selection where classOf obj == Export_Node collect obj
	),

	/** Get all nodes in scene
	 */
	function getNodesInScene =
	(
		for obj in shapes where classOf obj == Export_Node collect obj
	),

	/** _get node names
	 */
	function _getNodeNames nodes =
	(
		for _node in nodes collect _node.name --return
	),

	on create do
	(
		print "NodeList_v.onCreate()"
		--format "nodelist_control	= % \n" nodelist_control
	)
)