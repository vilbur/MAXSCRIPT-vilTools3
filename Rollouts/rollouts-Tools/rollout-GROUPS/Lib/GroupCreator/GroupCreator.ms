/** Group creator
  *
  * Features:
  *		1) Name of group is uppercase name of first object 
  *		2) Add new group to same layer as first object
  *		3) Rename objects in group
  *		4) Align pivot of group by first object in selection
  *
 */
struct GroupCreator_v
(	
	/* properties */
	_group,
	first_object,
	first_object_parent,
	
	first_object_rotation,
	_members,
	members_position = #(),
	members_rotation = #(),
	members_children = #(), -- children of grouped objects
	
	
	params      = #(),
	params_keys = #(#group_name, #rename_members, #add_to_layer, #align_transform, #relink_hierarchy ),

	/** Create group
	 */
	function _createGroup  =
	(
		clearListener()
		format "\n"; print "GroupCreator_v._createGroup()"
		--format "params = % \n" params
		undo "Create Group" on
		(
			this._setMembers()
			
			this._setFirstObj()			
			--format "first_object	= % \n" first_object
			--format "_members	= % \n" _members
			
			this._saveObjectsHierarchy()
			
			this._setFirstObjectToGroup()
			
			if params[2] then
				this._renameMembers()
				
			if params[3] then
				this._addGroupToLayer()
			
			if params[4] then
				this._alignTransformation()
			
			
			if _members.count > 1 then
				attachNodesToGroup (deleteItem ( deepcopy _members ) 1) _group
				
			if params[5] then
				this._relinkHierarchy()
		)
	),
	
	
	private
	
	
	/** Set first_object
	  
	 */
	function _setFirstObj = 
	(
		first_object = _members[1]
	),
	
	/** Set selection
	 */
	function _setMembers =
	(
		_members = for o in selection collect o
		
		clearSelection()
	),


	/** Create group
	 */
	function _setFirstObjectToGroup =
	(
		--format "\n"; print "GroupCreator_v.createGroup()"
		group first_object name:( if params[1] != undefined then params[1] else toUpper _members[1].name ) select:true --wirecolor:params[2]
		
		_group = selection[1]
	),

	/** Save objects members_children and parent of first object
	 */
	function _saveObjectsHierarchy =
	(
		--format "\n"; print "GroupCreator_v._saveObjectsHierarchy()"
		first_object_parent = first_object.parent
		
		for obj in _members where obj.children.count > 0 do members_children += obj.children 
	),
	
	/** Rename group members
	 */
	function _renameMembers =
	(
		--format "\n"; print "GroupCreator_v._renameMembers()"
		for i = 1 to _members.count do _members[i].name = _group.name + "-" + ( if i < 10 and _members.count < 100 then "0" else "00" ) + i as string
	),
	
	/** Align group transformation
	  *
	  * Group is not node, but only linked objects together.
	  *
	  * 
	 */
	function _alignTransformation =
	(
		setGroupOpen _group true
		
		_group.pivot = first_object.pivot

		first_object_rotation = first_object.rotation
		
		Rotate _group (  first_object_rotation)
		Rotate first_object ( Inverse first_object_rotation)

		setGroupOpen _group false
	),

	/** Add group to layer where object is
	*/
	function _addGroupToLayer =
	(
		last_sel_layer = first_object.layer
		last_sel_layer.addnode _group
	),

	/** Relink hierarchy
	 */
	function _relinkHierarchy =
	(
		--format "\n"; print "GroupCreator_v._relinkHierarchy()"
		if first_object_parent != undefined then 
			_group.parent = first_object_parent
		
		for child in members_children where isGroupMember child == false do
			child.parent = _group		
	),

	/**  
	 */
	on create do
	(
		--print "GroupCreator_v.onCreate()"
		--if( classOf _group != Dummy ) then 
			--return false
		this._createGroup()

	)
)