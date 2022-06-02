/**
  * 1) Merge meshes in group
  * 2) Replace group with mesh
  * 
 */
struct GroupAttacher_v
(
	__construct = #( #groups ),
	
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
		format "\n"; print ("GroupAttacher_v._attachObjects() " + _group.name)
		group_members    = this._getGroupMembers(_group)
		members_children = this._getChildrenOfGroupMembers(_group)
		group_replacer   = this._replaceGroupWithObject (_group)
		
		this._attachObjects (group_replacer) (group_members)
			
		this._relinkMembersChildren (group_replacer) (members_children)
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
		--format "\n"; print "GroupAttacher_v._replaceGroupWithObject()"
		group_replacer = this._createEmptyObject (_group)

		if isValidNode _group  then
			ungroup _group
		
		group_replacer --return
	),
	
	/** _create empty object
	 */
	function _createEmptyObject _group =
	(
		--format "\n"; print "GroupAttacher_v._createEmptyObject()"
		group_replacer = convertTo (Editable_mesh name:_group.name) Editable_Poly --convert to Editable_Poly
		
		group_replacer.pivot	= _group.pivot
		group_replacer.transform	= _group.transform

		this._relinkHierarchy (_group) (group_replacer)
		
		group_replacer --return
	),
	
	/** Relink hierarchy of obejcts
	 */
	function _relinkHierarchy _group group_replacer =
	(
		for child in _group.children do 
			child.parent = group_replacer
		
		if this._groupIsNested(_group) then 
			attachNodesToGroup #(group_replacer) _group.parent -- link to parent group
		else
			group_replacer.parent	= _group.parent -- link to parent object
	),
	
	/** _attach objects
	 */
	function _attachObjects group_replacer group_members =
	(
		for group_member in group_members do
			polyop.attach group_replacer group_member
	),
	
	/** _relink members children
	 */
	function _relinkMembersChildren group_replacer members_children =
	(
		for child in members_children do child.parent = group_replacer
	),

	/** _group is nested
	 */
	function _groupIsNested _group =
	(
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
		print("GroupAttacher_v.onCreate()")
		ConstructPropeties test:this
		
		for _group in groups do
			this._attachGroup(_group)
		
	)
	
)
