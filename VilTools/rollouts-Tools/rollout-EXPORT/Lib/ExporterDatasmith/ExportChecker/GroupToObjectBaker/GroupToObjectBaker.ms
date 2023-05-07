/**
  * 1) Merge objects in group to single mesh
  * 2) Replace group with mesh
  *
 */
struct GroupToObjectBaker_v
(
	--__construct = #( #groups ),

	/* construct */
	groups = #(),

	/* dependency */
	/* reference */
	/* inhered */
	/* properties */

	private

	/** _attach objects
	 */
	function _attachGroup _group =
	(
		format "\n"; print ("GroupToObjectBaker_v._attachGroup() group:" + _group.name)
		--format "_group	= % \n" _group
		group_parent = _group.parent
		format "group_parent	= % \n" group_parent

		group_members    = this._getGroupMembers(_group)
		--format "group_members	= % \n" group_members
		members_children = this._getChildrenOfGroupMembers(_group)
		--format "members_children	= % \n" members_children
		group_replace_object   = this._replaceGroupWithObject (_group)
		--format "group_replace_object	= % \n" group_replace_object
		this._attachObjects (group_replace_object) (group_members)

		this._relinkMembersChildren (group_replace_object) (members_children)

		--if not isDeleted  _group then
		if isValidNode _group then
			delete _group

	),

	/** _get group members
	 */
	function _getGroupMembers _group =
	(
		--for child in _group.children where isGroupMember (child) collect child
		for child in _group.children collect child
	),

	/** _get group members
	 */
	function _getChildrenOfGroupMembers _group =
	(
		members_children = #()

		for child in _group.children where child.children.count > 0 do
			join members_children (this._getAllChildren(child))

		members_children --return
	),

	/** _replace group with object
	 */
	function _replaceGroupWithObject _group =
	(
		--format "\n"; print "GroupToObjectBaker_v._replaceGroupWithObject()"

		group_replace_object = this._createEmptyObject (_group)

		if isValidNode _group  then
			ungroup _group

		group_replace_object --return
	),

	/** _create empty object
	 */
	function _createEmptyObject _group =
	(
		--format "\n"; print "GroupToObjectBaker_v._createEmptyObject()"
		group_replace_object = convertTo (Editable_mesh name:_group.name) Editable_Poly --convert to Editable_Poly

		group_replace_object.pivot	= _group.pivot
		group_replace_object.transform	= _group.transform

		this._relinkParent	(_group) (group_replace_object)
		this._relinkChildren	(_group) (group_replace_object)

		group_replace_object --return
	),

	/** Relink hierarchy of obejcts
	 */
	function _relinkChildren _group group_replace_object =
	(
		--format "\n"; print "GroupToObjectBaker_v._relinkChildren()"
		for child in _group.children do
			child.parent = group_replace_object


	),

	/** Relink hierarchy of obejcts
	 */
	function _relinkParent _group group_replace_object =
	(
		--format "\n"; print "GroupToObjectBaker_v._relinkParent()"
		--format "_group.parent	= % \n" _group.parent.name

		if this._groupIsNested(_group) then
			attachNodesToGroup #(group_replace_object) _group.parent -- link to parent group
		else
			group_replace_object.parent	= _group.parent -- link to parent object

		--format "group_replace_object.parent	= % \n" group_replace_object.parent
	),


	/** _attach objects
	 */
	function _attachObjects group_replace_object group_members =
	(
		for group_member in group_members do
			polyop.attach group_replace_object group_member
	),

	/** _relink members children
	 */
	function _relinkMembersChildren group_replace_object members_children =
	(
		for child in members_children do child.parent = group_replace_object
	),

	/** _group is nested
	 */
	function _groupIsNested _group =
	(
		--format "\n"; print "GroupToObjectBaker_v._groupIsNested()"
		--format "_group: % is neseted: % \n\n" _group.name (isGroupMember (_group))
		isGroupMember (_group) --return
	),

	/**  Get all nested children of object
	  */
	function _getAllChildren obj &arr:#() =
	(
		for child in obj.children do
		(
			append arr child
			this._getAllChildren child arr:arr
		)
		arr
	),

	/**
	 */
	on create do
	(
		print("GroupToObjectBaker_v.onCreate()")
		--ConstructPropeties test:this

		for _group in groups do
			this._attachGroup(_group)

	)

)
