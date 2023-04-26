/** 
 */
struct NodeList_v
(
	/* construct */ 
	nodelist_control,
	
	/* properties  */ 
	user_prop = "unreal-engine-export-node",
	
	--nodes_in_scene = #(),

	--_rollout = ROLLOUTS_GLOBAL.get "ROLLOUT_unreal",

	
	/** Load nodes
	 */
	function loadNodes =
	(
		print "NodeList_v.loadNodes()"

		nodelist_control.items = this._getNodeNames (this._getNodesInScene())
	),
	
	/** Get selected items
	 */
	function getSelectedItems =
	(
		selected_index = nodelist_control.selection as Array
		
		node_names	= nodelist_control.items
		
		for index in selected_index collect node_names[index] -- return
	),
	
	/** _get selected nodes
	 */
	function getSelectedNodes =
	(
		--print "NodeList_v._getSelectedNodes()"
		for _node in (this._getNodesInScene()) where findItem (this.getSelectedItems()) _node.name > 0 collect _node --return
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
	
	on create do
	(
		--print "NodeList_v.onCreate()"
	)
)
