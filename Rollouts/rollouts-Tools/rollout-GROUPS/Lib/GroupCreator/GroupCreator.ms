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
	_members,
	_group,
	first_object,
	
	first_object_parent,
	
	members_children = #(), -- children of grouped objects
	members_position = #(),
	members_rotation = #(),
	
	
	params      = #(),
	params_keys = #(#group_name, #rename_members, #add_to_layer, #align_transform, #relink_hierarchy ),

	/** Set selection
	 */
	function _setSelection =
	(
		--_members = for o in selection where isGroupHead o == false collect o
		_members = for o in selection collect o
		
		clearSelection()
	),
	
	/** Set first_object
	  
	 */
	function _setFirstObj = 
	(
		first_object = _members[1]
	),

	/** Create group
	 */
	function _createGroup  =
	(
		format "\n"; print "GroupCreator_v._createGroup()"
		format "params = % \n" params
	
		undo "Create Group" on
		(
			this._saveObjectsHierarchy()
	
			group _members name:( if params[1] != undefined then params[1] else toUpper _members[1].name ) select:true --wirecolor:params[2]
			
			_group = selection[1]

			if params[2] then
				this._renameMembers()
				
			if params[3] then
				this._addGroupToLayer()
			
			if params[4] then
				this._alignTransformation()
				
			if params[5] then
				this._relinkHierarchy()
		)
	),
	
	
	private
	

	
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
		--format "\n"; print "GroupCreator_v._alignTransformation()"
		this._saveObjectsPositionAndRotation()
		
		this._alignPositionAndRotation()
		
		this._loadObjectsPositions()
		
		this._alignPivot()
	),
	
	/** 
	 */
	function _saveObjectsPositionAndRotation =
	(
		--format "\n"; print "GroupCreator_v._saveObjectsPositionAndRotation()"
		for index=1 to _group.children.count where isGroupMember _group.children[index] do
		(
			members_position[index] = _group.children[index].pos
			members_rotation[index] = _group.children[index].rotation
		)
	),
	
	/** _load objects positions
	 */
	function _loadObjectsPositions =
	(
		for i=1 to 2 do
			for index = 1 to  _group.children.count do
				this._loadObjectPosition index
	),

	/** Load objects positions
	 */
	function _loadObjectPosition index =
	(
		--format "\n"; print "GroupCreator_v._loadObjectPosition()"
		_members[index].pos      = members_position[index]
		_members[index].rotation = members_rotation[index]
	),
	
	/** Set group pivot by object
	 */
	function _alignPositionAndRotation =
	(
		_group.pos      = first_object.pos
		_group.rotation = first_object.rotation
	),
	
	/** _align pivot
	 */
	function _alignPivot =
	(
		_group.pivot = first_object.pivot
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
		
		for child in members_children do
			child.parent = _group		
	),

	/**  
	 */
	on create do
	(
		print "GroupCreator_v.onCreate()"

		if selection.count < 2 do
			return false
		
		this._setSelection()
		
		this._setFirstObj()
		
		this._createGroup()
		
		--if( classOf _group != Dummy ) then 
			--return false
	)
)