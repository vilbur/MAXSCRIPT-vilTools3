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
		nodes = this._getNodesInScene()
		
		
		_Rollout = ROLLOUTS.get "ROLLOUT_unreal"
		
		--format "_Rollout	= % \n" _Rollout
		--format "ROLLOUT_unreal	= % \n" ROLLOUT_unreal			 
		--format "_Rollout==ROLLOUT_unreal	= % \n" (_Rollout==ROLLOUT_unreal)
		--format "_Rollout.controls	= % \n" _Rollout.controls
			
		
		--format "nodes	= % \n" nodes 
		_Rollout.MULTILISTBOX_nodes.items = this._getNodeNames()
		--_Rollout.MULTILISTBOX_nodes.items = #("goood")
		
		--format "classOf ROLLOUT_unreal	= % \n" (classOf ROLLOUT_unreal)
	),
	
	/** Get nodes in scene
	 */
	function _getNodesInScene =
	(
		for _shape in shapes where classOf _shape == text and getUserProp _shape user_prop != undefined collect _shape		
		--for _shape in shapes collect _shape		
	),
	
	/** _get node names
	 */
	function _getNodeNames =
	(
		for _node in nodes collect _node.name 
	),
	
	on create do ()
)
