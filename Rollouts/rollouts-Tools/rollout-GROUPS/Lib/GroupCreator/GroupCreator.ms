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
	members	= #(),
	members_position	= #(),
	members_rotation	= #(),
	members_children	= #(), -- children of grouped objects
	
	
	params      = #(),
	params_keys = #(#members_name, #group_name, #add_to_layer, #align_transform, #relink_hierarchy ),

	/** Create group
	 */
	function _createGroup  =
	(
		format "\n"; print "GroupCreator_v._createGroup()"
		GLOBAL_SELECTION_LAST_ENABLED = false
		--format "params = % \n" params
		undo "Create Group" on
		(
			this._setMembers()
			
			clearSelection()

			this._setFirstObj()			
			format "first_object	= % \n" first_object
			format "members	= % \n" members
			
			--this._saveObjectsHierarchy()
			
			--format "params[1]	= % \n" params[1]
			--format "params[2]	= % \n" params[2]

			this._setFirstObjectToGroup()
			
			if params[1] != "" then
				this._renameMembers()
				
			if params[3] then
				this._addGroupToLayer()
			
			if params[4] then
				this._alignTransformation()
			
			this._setOtherNodesToGroup()
			--	
			--if params[5] then
			--	this._relinkHierarchy()
		)
		GLOBAL_SELECTION_LAST_ENABLED = true
	),
	
	
	private
	
	
	/** Set selection
	 */
	function _setMembers =
	(
		--format "\n"; print "GroupCreator_v._setMembers()"
		--for o in selection collect
		--(
		--	if isGroupHead o or not isGroupMember o then
		--		appendIfUnique members o
		--		
		--	else if isOpenGroupMember o then 
		--		appendIfUnique members o.parent
		--)
		members = for o in selection collect o
		
		--for _member in members do format "_member	= % \n" _member.name
	),
	
	/** Set first_object
	 */
	function _setFirstObj = 
	(
		first_object = members[1]
		--format "first_object	= % \n" first_object
	),

	/** Create group
	  *
	  * Group name rules:
	  *	1) Use group name if defined
	  *	2) Use "{MEMBER NAME}-GROUP" if member name is defined is  defined and group name is not
	  *	3) Use default max group name
	 */
	function _setFirstObjectToGroup =
	(
		format "\n"; print "GroupCreator_v.createGroup()"

		--group first_object name:( if params[2] != "" then params[2] else toUpper members[2].name ) select:true --wirecolor:params[2]
		group first_object name:( if params[2] != "" then params[2] else if params[1]  != "" then toUpper params[1] + "-GROUP" else unsupplied ) select:true --wirecolor:params[2]
		
		_group = selection[1]
		--format "_group	= % \n" _group
	),

	/** 
	 */
	function _setOtherNodesToGroup =
	(
		format "\n"; print "GroupCreator_v._setOtherNodesToGroup()"
		--format "_group	= % \n" _group
		
		nodes_to_attach = for o in ((deleteItem ( deepCopy members ) 1)) collect o
		for node_to_attach in nodes_to_attach do format "node_to_attach	= % \n" node_to_attach.name

		--format "nodes_to_attach.count	= % \n" nodes_to_attach.count
		
		if members.count > 1 then
				attachNodesToGroup nodes_to_attach _group		

			
	),
	
	/** Save objects members_children and parent of first object
	 */
	function _saveObjectsHierarchy =
	(
		format "\n"; print "GroupCreator_v._saveObjectsHierarchy()"
		first_object_parent = first_object.parent
		format "first_object_parent	= % \n" first_object_parent
		for obj in members where obj.children.count > 0 do members_children += obj.children 
	),
	
	/** Rename group members
	 */
	function _renameMembers =
	(
		--format "\n"; print "GroupCreator_v._renameMembers()"
		for i = 1 to members.count do members[i].name = params[1] + "-" + ( if i < 10 and members.count < 100 then "0" else "00" ) + i as string
	),
	
	/** Align group transformation by 1st object
	  *
	  * Set pivot and rotation of group by 1st object,
	  * then rotate members in invers rotation
	  * 
	 */
	function _alignTransformation =
	(
		--format "\n"; print "GroupCreator_v._alignTransformation()"
		--format "first_object	= % \n" first_object
		--format "_group	= % \n" _group
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