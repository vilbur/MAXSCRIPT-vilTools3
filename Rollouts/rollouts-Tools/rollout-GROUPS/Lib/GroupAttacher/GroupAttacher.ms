/** Attach selected object to selected group
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
		format "selected_groups	= % \n" selected_groups
		
		root_group = selected_groups[1]
		format "root_group	= % \n" root_group
		attaching_nodes = for obj in selection where findItem selected_groups obj == 0 and findItem selected_groups obj.parent == 0 collect obj
		format "attaching_nodes	= % \n" attaching_nodes
	
		InstanceMgr.GetInstances selected_groups[1] &destination_groups

		deleteItem destination_groups (findItem destination_groups root_group)

		format "destination_groups	= % \n" destination_groups
		
		for destination_group in destination_groups do
			this.instanceToGroups(destination_group)
		
		attachNodesToGroup attaching_nodes root_group

	),
	
	/** Instance to groups
	 */
	function instanceToGroups destination_group =
	(
		format "\n"; print "GroupAttacher_v.instanceToGroups()"
		format "root_group	= % \n" root_group
		
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
		
		attachNodesToGroup new_instance destination_group
	),
	

	/** Attach test
	 */
	function _attach dest_obj =
	(
		--format "dest_obj	= % \n" dest_obj
		attaching_nodes           = #()
		destination_groups        = #()
		attaching_nodes_instances = #()

		
		local root_group = this._getRootGroupHead dest_obj
		format "root_group	= % \n" root_group
		InstanceMgr.GetInstances root_group &groups
		
		for i = 1 to groups.count do
			appendIfUnique destination_groups (this._getRootGroupHead groups[i])
		
		format "destination_groups	= % \n" 
		
		

		format "q	= % \n" q
	
		node_counts = 0

		if destination_groups.count > 0 and attaching_nodes.count>0 then 
		(
			--with redraw off 
			--(
			for i = 1 to destination_groups.count where destination_groups[i] != root_group do
			(
				maxOps.cloneNodes attaching_nodes cloneType:#instance newNodes:&objs
				
				for o in objs do
				(
					appendIfUnique attaching_nodes_instances (this._getRootGroupHead o)
					
					if attaching_nodes_instances.count>node_counts then
					(	
						node_counts+=1
						tm = o.transform * (inverse root_group.transform)
						o.transform = tm*destination_groups[i].transform
					)
				)
				attachNodesToGroup objs destination_groups[i]
			)
			
			attachNodesToGroup attaching_nodes root_group

			--)
			--print "Successful :)" 
		)
		else print "make another selection :("

	),
	
	
	/** Unknown method
	 */
	function _unknownMethod =
	(
		--format "\n"; print "GroupAttacher_v._unknownMethod()"
		--for obj in selection where isGroupHead obj == false do
		--	if (q = (this._getRootClosedGroupHead obj)) != root_group then 
		--		appendIfUnique attaching_nodes q

	),

	/**  
	 *	
	 */
	function _getRootClosedGroupHead _node =
	(
		if _node != undefined do
		(
		   if isGroupMember _node then
		   (
			   if isOpenGroupHead _node.parent then 
			   (
				   detachNodesFromGroup _node
				   _node
			   )
			   else
				   this._getRootClosedGroupHead _node.parent
		   )
		   else _node
		)
	),

	/**  
	 *	
	 */
	function _getRootGroupHead _node =

	(
		if _node != undefined do
		(
		   if isgroupmember _node then
		   (
			   this._getRootGroupHead _node.parent
		   )
		   else _node
		)
	),

	/**  
	 */
	on create do
	(

	)
)

