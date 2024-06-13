/** Attach objects to selected group
  *
  * Works with instanced groups
  *
 */
struct GroupAttacher_v
(
	_selection,

	target_group,
	attaching_nodes	= #(),
	destination_groups	= #(),

	/** Attach
	 */
	function attachSelectionToGroups =
	(
		 _selection = selection as Array

		if selection.count < 2 or (target_group = this._getTargetGroup()) == undefined then
			return false

		--format "target_group = % \n" target_group

		deleteItem _selection (findItem _selection target_group)

		/*
			IF GROUP IS CLOSED THEN FILTER MEMBERS OF NESTED GROUPS
		*/
		if isOpenGroupHead target_group == false then
		(
			/* FOR CLOSED GROUP */
			group_members = this._getGroupMembers ( target_group )

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

		this._getInstancesOfGroup()

		/** ATTACH TO SELECTED GROUP
		  */
		this._attachNodesToGroup (target_group) (attaching_nodes)

		/** ATTACH TO INSTANCES OF GROUP
		  */
		this._attachToInstancesOfGroup()
	),


	private


	/** Find group

		NEW METHOD QUICK ADD, FOR USE LATER

	 */
	function _findGroup obj =
	(
		--format "\n"; print "SupportGenerator_v.findGroup()"

		if isGroupMember obj then
		(
			while not isGroupHead obj.parent do
			(
				format "\n\n"
				format "obj.parent: %\n" obj.parent

				obj = obj.parent
			)


			obj.parent --return

		)
	),


	/** Get instances of group
	 */
	function _getInstancesOfGroup =
	(
		--format "\n"; print "GroupAttacher_v.getInstancesOfGroup()"
		InstanceMgr.GetInstances target_group &destination_groups

		deleteItem destination_groups (findItem destination_groups target_group)
	),

	/** Create instaces of objects to instances of groups
	 */
	function _attachToInstancesOfGroup =
	(
		--format "\n"; print "GroupAttacher_v._instanceToGroups()"
		--format "target_group	= % \n" target_group

		for destination_group in destination_groups do
		(
			maxOps.cloneNodes attaching_nodes cloneType:#instance newNodes:&new_instances

			for new_instance in new_instances do
				this._moveNewInstanceToDestinationGroup(destination_group)(new_instance)
		)
	),

	/** Move instance to group position
	 */
	function _moveNewInstanceToDestinationGroup destination_group new_instance =
	(
		--format "\n"; print "GroupAttacher_v._moveNewInstanceToDestinationGroup()"
		transform_matrix = new_instance.transform * ( Inverse target_group.transform)

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

	/** Get group target group
	 */
	function _getTargetGroup =
	(
		if this._isFirstObjectOpenedGroup() then -- IF OPEN GROUP IS SELECTED AS FIRST OBJECT
			_selection[1]

		else if this._isParentOfFirstObjectOpenedGroup() then -- IF FIRST OBJECT IS MEMBER OF OPENED GROUP, just member of group is enough to select
			_selection[1].parent

		else if (closed_parent_groups = this._getClosedGroups()).count > 0 then -- GET CLOSED GROUP
			closed_parent_groups[1]

		else if (selected_groups = this._getGroups()).count > 0 then -- GET ANY GROUP OF SELECTION as fallback
			selected_groups[1]
	),

	/** Get closed group on top of the hierarchy
	 */
	function _getClosedGroups =
	(
		--format "\n"; print "GroupAttacher_v.closedParentGroup()"
		--if this._isGroup(_selection[1]) and this._isGroupClosed(_selection[1])  then _selection[1] --return
		for o in ( _selection ) where isGroupHead o and isOpenGroupHead o == false and findItem _selection o.parent == 0 collect o

	),
	/** Get group of first object in selection
	 */
	function _isFirstObjectOpenedGroup =
	(
		--format "\n"; print "GroupAttacher_v.closedParentGroup()"
		this._isGroup(_selection[1]) and not this._isGroupClosed(_selection[1])
	),

	/** Get group of first object in selection
	 */
	function _isParentOfFirstObjectOpenedGroup =
	(
		--format "\n"; print "GroupAttacher_v.closedParentGroup()"
		object_parent = _selection[1].parent

		object_parent != undefined and this._isGroup(object_parent) and not this._isGroupClosed(object_parent)
	),

	/** Get any group
	 */
	function _getGroups =
	(
		--format "\n"; print "GroupAttacher_v.closedParentGroup()"
		for o in ( _selection ) where isGroupHead o collect o --return
	),


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

	/**
	 */
	on create do
	(
	)
)