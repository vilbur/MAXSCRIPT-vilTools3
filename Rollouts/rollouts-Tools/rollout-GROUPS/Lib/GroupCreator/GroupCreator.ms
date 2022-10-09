/** Group creator
  *
  * Features:
  *		• Align pivot of group by first object in selection
  *		• Name of group is uppercase name of first object 
  *		• Add new roup to same layer as first object
  *
 */
struct GroupCreator_v
(	
	/* properties */
	_selection,
	_group,
	first_object,
	
	member_pos = #(),
	member_rot = #(),
	
	
	params      = #(),
	params_keys = #(#group_name, #rename_members, #add_to_layer, #align_transform, #relink_hierarchy ),

	/** Set selection
	 */
	function _setSelection =
	(
		--_selection = for o in selection where isGroupHead o == false collect o
		_selection = for o in selection collect o
	),
	
	/** Set first_object
	  
	 */
	function _setFirstObj = 
	(
		first_object = _selection[1]
	),

	/** Create group
	 */
	function _createGroup  =
	(
		format "\n"; print "GroupCreator_v._createGroup()"

		format "params = % \n" params
	
		undo "Create Group" on
		(
			group_name = if params[1] != undefined then params[1] else toUpper _selection[1].name

			_group = group _selection name:( group_name ) select:true --wirecolor:params[2]
			
			if params[2] then
				this._renameMembers()
				
			if params[3] then
				this._addGroupToLayer()
			
			if params[4] then
				this._alignTransformation()
				
		)
	),
	
	/** Rename group members
	 */
	function _renameMembers =
	(
		format "\n"; print "GroupCreator_v._renameMembers()"
		for i = 1 to _selection.count do _selection[i].name = _group.name + "-" + ( if i < 10 then "0"  ) + i as string
	),
	
	/** Align transformation
	 */
	function _alignTransformation =
	(
		--format "\n"; print "GroupCreator_v._alignTransformation()"
		this._saveObjectsPositions()
		
		this._alignPositionAndRotation()
		
		this._loadObjectsPositions()
		
		this._alignPivot()
	),
	
	/** _save objects positions
	 */
	function _saveObjectsPositions =
	(
		for index=1 to _group.children.count where isGroupMember _group.children[index] do
			this._saveObjectPosition index
	),
	
	/** Save objects positions
	 */
	function _saveObjectPosition index =
	(
		member_pos[index] = _group.children[index].pos
		member_rot[index] = _group.children[index].rotation
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
		_selection[index].pos      = member_pos[index]
		_selection[index].rotation = member_rot[index]
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