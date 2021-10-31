/** 
 */
struct NodeList_v
(
	user_prop = "unreal-engine-export-node",
	
	nodes = #(),
	

	
	/** Load nodes
	 */
	function loadNodes =
	(
		print "NodeList_v.loadNodes()"

		nodes = this._getNodesInScene()
		
		_Rollout = ROLLOUTS.get "ROLLOUT_unreal"
		
		format "ROLLOUTS	= % \n" ROLLOUTS
		format "_Rollout	= % \n" _Rollout
		--format "nodes	= % \n" (this._getNodeNames())
		
		_Rollout.MULTILISTBOX_nodes.items = this._getNodeNames()
		--_Rollout.MULTILISTBOX_nodes.items = #("Good")

	),
	
	/** Get nodes in scene
	 */
	function _getNodesInScene =
	(
		for _shape in shapes where classOf _shape == text and getUserProp _shape user_prop != undefined collect _shape		
	),
	
	/** _get node names
	 */
	function _getNodeNames =
	(
		for _node in nodes collect _node.name 
	),
	
	on create do ()
)
