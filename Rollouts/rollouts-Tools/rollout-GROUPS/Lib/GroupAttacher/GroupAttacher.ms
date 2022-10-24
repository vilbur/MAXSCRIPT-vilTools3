/** Attach selected objects to selected group
  *
  * Works with instanced groups
  *
 */
struct GroupAttacher_v
(
	root_group,
	attaching_nodes	= #(),
	destination_groups	= #(),

	/** Attach
	 */
	function attachSelectionToGroups =
	(
		--format "already_attached_nodes	= % \n" already_attached_nodes
		selected_groups = for obj in selection where isGroupHead obj collect obj
		--format "selected_groups	= % \n" selected_groups
		
		root_group = selected_groups[1]
		format "root_group	= % \n" root_group
		--attaching_nodes = for obj in selection where findItem selected_groups obj == 0 and findItem selected_groups obj.parent == 0 collect obj
		attaching_nodes = for obj in selection where findItem root_group.children obj == 0 and findItem root_group.children obj.parent == 0 collect obj
		--format "attaching_nodes	= % \n" attaching_nodes
	
		InstanceMgr.GetInstances selected_groups[1] &destination_groups

		deleteItem destination_groups (findItem destination_groups root_group)
		--format "destination_groups	= % \n" destination_groups
		
		for destination_group in destination_groups do
			this.instanceToGroups(destination_group)
			
		this._attachNodesToGroup (root_group) (attaching_nodes)
	),
	
	/** Instance to groups
	 */
	function instanceToGroups destination_group =
	(
		--format "\n"; print "GroupAttacher_v.instanceToGroups()"
		--format "root_group	= % \n" root_group
		maxOps.cloneNodes attaching_nodes cloneType:#instance newNodes:&new_instances
		
		for new_instance in new_instances do
			this._moveNewInstanceToDestinationGroup(destination_group)(new_instance)
	),
	
	/** Move instance to group position
	 */
	function _moveNewInstanceToDestinationGroup destination_group new_instance =
	(
		--format "\n"; print "GroupAttacher_v._moveNewInstanceToDestinationGroup()"
		transform_matrix = new_instance.transform * ( Inverse root_group.transform)
		
		new_instance.transform = transform_matrix*destination_group.transform
		
		this._attachNodesToGroup (destination_group) (new_instance)
	),
	
	
	/** Attach nodes to group
	 */
	function _attachNodesToGroup _group _nodes =
	(
		--format "\n"; print "GroupAttacher_v.attachNodesToGroup()"
		already_attached_nodes = for _node in _nodes where isGroupMember _node collect _node

		if already_attached_nodes.count > 0 then
			detachNodesFromGroup already_attached_nodes
		
		attachNodesToGroup _nodes _group
	),
	
	/**  
	 */
	on create do
	(
	)
)