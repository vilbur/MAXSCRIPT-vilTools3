/** Attach selected object to selected group
 */
struct GroupAttacher_v
(

	/** Attach
	 */
	function attachSelectionToGroups =
	(
		selected_groups = for obj in selection where isGroupMember obj or isGroupHead obj collect obj 
		
		if( selected_groups.count > 0 ) then
			this._attach selected_groups[1]
	),

	/** Attach test
	 */
	function _attach dest_obj =
	(
		/** CREDITS:
		 *	https://forums.cgsociety.org/t/attach-object-group-to-all-group-instances/1579888
		 */
		with undo "attach_to_groups" on
		(
			with redraw off
			(

				--dest_obj = selection[1]

				attaching_nodes           = #()
				destination_groups        = #()
				attaching_nodes_instances = #()

				local root_group = this._getRootGroupHead dest_obj

				InstanceMgr.GetInstances root_group &groups
				for i = 1 to groups.count do
					appendIfUnique destination_groups (this._getRootGroupHead groups[i])

				for s in selection where isGroupHead s == false do
					if (q=(this._getRootClosedGroupHead s)) != root_group then 
						appendIfUnique attaching_nodes q

				node_counts = 0

				format "attaching_nodes = % \n" attaching_nodes
				format "destination_groups = % \n" destination_groups
				format "attaching_nodes_instances = % \n" attaching_nodes_instances

				if destination_groups.count > 1 and attaching_nodes.count>0 then 
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

			)
		)
	),
	
	/**  
	 *	
	 */
	function _getRootClosedGroupHead node =
	(
		if node != undefined do
		(
		   if isgroupmember node then
		   (
			   if isOpenGroupHead node.parent then 
			   (
				   detachNodesFromGroup node
				   node
			   )
			   else
				   this._getRootClosedGroupHead node.parent
		   )
		   else node
		)
	),
	
	/**  
	 *	
	 */
	function _getRootGroupHead node =

	(
		if node != undefined do
		(
		   if isgroupmember node then
		   (
			   this._getRootGroupHead node.parent
		   )
		   else node
		)
	),
	
	/**  
	 */
	on create do
	(

	)
)


