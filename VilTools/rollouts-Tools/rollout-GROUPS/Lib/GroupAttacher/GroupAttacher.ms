/** Attach objects to selected group
  *
  * Works with instanced groups
  *
 */
struct GroupAttacher_v
(
	_selection,

	attach_group,
	attaching_nodes	= #(),
	destination_groups	= #(),

	/** Attach
	 */
	function attachSelectionToGroups =
	(
		 _selection = selection as Array

		if ( attach_group = this._getGroupToAttach() ) == undefined then
			return false

		deleteItem _selection (findItem _selection attach_group)

		/*
			IF GROUP IS CLOSED THEN FILTER MEMBERS OF NESTED GROUPS
		*/
		if isOpenGroupHead attach_group == false then
		(
			/* FOR CLOSED GROUP */
			group_members = this._getGroupMembers ( attach_group )

			nested_groups = for obj in group_members where isGroupHead obj collect obj

			group_members_nested = this._getGroupMembers ( nested_groups )

			no_attach_memebers = join group_members group_members_nested
		)
		else
		(
			/* FOR OPEN GROUP */
			selected_groups = for obj in _selection where isGroupHead obj collect obj

			no_attach_memebers = this._getGroupMembers ( selected_groups )
		)


		attaching_nodes = this._diferrence(_selection)(no_attach_memebers)

		InstanceMgr.GetInstances attach_group &destination_groups

		deleteItem destination_groups (findItem destination_groups attach_group)
		--format "destination_groups	= % \n" destination_groups

		for destination_group in destination_groups do
			this._instanceToGroups(destination_group)

		this._attachNodesToGroup (attach_group) (attaching_nodes)
	),

	/** Instance to groups
	 */
	function _instanceToGroups destination_group =
	(
		--format "\n"; print "GroupAttacher_v._instanceToGroups()"
		--format "attach_group	= % \n" attach_group
		maxOps.cloneNodes attaching_nodes cloneType:#instance newNodes:&new_instances

		for new_instance in new_instances do
			this._moveNewInstanceToDestinationGroup(destination_group)(new_instance)
	),

	/** Move instance to group position
	 */
	function _moveNewInstanceToDestinationGroup destination_group new_instance =
	(
		--format "\n"; print "GroupAttacher_v._moveNewInstanceToDestinationGroup()"
		transform_matrix = new_instance.transform * ( Inverse attach_group.transform)

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


	private

	/** Get group to attach
	 */
	function _getGroupToAttach =
	(
		format "\n"; print "GroupAttacher_v.getGroupToAttach()"

		if (closed_parent_group = this._getClosedFirstGroup()) != undefined then
			closed_parent_group

		else if (selected_group = this._getGroups()).count > 0 then
			selected_group[1]

		else if (group_by_object = this._getGroupOfFirstObject()) != undefined then
			group_by_object
	),

	/** Get closed parent group
	 */
	function _getClosedFirstGroup =
	(
		--format "\n"; print "GroupAttacher_v.closedParentGroup()"
		if this._isGroup(_selection[1]) and this._isGroupClosed(_selection[1])  then _selection[1] --return
	),

	/** Get any group
	 */
	function _getGroups =
	(
		--format "\n"; print "GroupAttacher_v.closedParentGroup()"
		for o in ( _selection ) where isGroupHead o collect o --return
	),

	/** Get group of first object in selection
	 */
	function _getGroupOfFirstObject =
	(
		--format "\n"; print "GroupAttacher_v.closedParentGroup()"
		if _selection.count > 0 and _selection[1].parent != undefined and isGroupHead _selection[1].parent then _selection[1].parent
	),

	--/** Get objects to attach
	-- */
	--function _getObjectsToAttach =
	--(
	--	--format "\n"; print "GroupAttacher_v.getObjectsToAttach()"
	--),

	/** Get group members of closed group
	 */
	function _getGroupMembers groups =
	(
		if classOf groups != Array  then
			groups = #(groups)

		mapped function getAllChildren node &group_members = (if isValidNode node and isKindOf group_members Array do join group_members node.children)

		group_members = #()

		getAllChildren groups &group_members

		group_members --return
	),

	/** Get diferrence between 2 arrays
	  */
	function _diferrence array_a array_b =
	(
		array_diff = #()

		for element in array_a do
			if finditem array_b element == 0 then
				append array_diff element

		return array_diff
	),

	/** Is group
	 */
	function _isGroup obj =
	(
		--format "\n"; print "GroupAttacher_v._isGroup()"
		isGroupHead obj --return
	),

	/** Is group
	 */
	function _isGroupClosed obj =
	(
		--format "\n"; print "GroupAttacher_v._isGroup()"
		isOpenGroupHead obj == false --return
	),

	/** Get instances of group
	 */
	function _getInstancesOfGroup _group =
	(
		--format "\n"; print "GroupAttacher_v._getInstancesOfGroup()"


	),

	/**
	 */
	on create do
	(
	)
)