
/** 
 */
struct NodeList_v
(
	user_prop = "unreal-engine-export-node",
	
	--nodes_in_scene = #(),

	_rollout = ROLLOUTS_GLOBAL.get "ROLLOUT_unreal",

	nodelistBOX = _rollout.MULTILISTBOX_nodes,
	
	/** Load nodes
	 */
	function loadNodes =
	(
		print "NodeList_v.loadNodes()"

		nodelistBOX.items = this._getNodeNames (this._getNodesInScene())
	),
	
	/** Get selected items
	 */
	function getSelectedItems =
	(
		selected_index = nodelistBOX.selection as Array
		
		node_names	= nodelistBOX.items
		
		for index in selected_index collect node_names[index] -- return
	),
	
	/** Get nodes in scene
	 */
	function _getNodesInScene =
	(
		for _shape in shapes where classOf _shape == text and getUserProp _shape user_prop != undefined collect _shape		
	),
	
	/** _get node names
	 */
	function _getNodeNames nodes =
	(
		for _node in nodes collect _node.name --return
	),
	
	/** Test
	 */
	function test =
	(
		print "NodeList_v.test()"
	),
	
	
	
	on create do ()
)
