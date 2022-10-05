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
	obj,
	_selection,
	_group,
	
	member_pos = #(),
	member_rot = #(),
	
	
	params      = #(),
	params_keys = #(#group_name, #Color_picker,  #Colorize_members, #Rename_members),

	/** Set selection
	 */
	function _setSelection =
	(
		_selection = for o in selection where isGroupHead o == false collect o
	),
	
	/** Set obj
	  
	 */
	function _setObj = 
	(
		obj = _selection[1]
	),

	/** Create group
	 */
	function _createGroup  =
	(
		_group = group _selection name:( toUpper _selection[1].name ) select:true
		format "classOf _group = % \n" (classOf _group)
		format "superclassOf _group = % \n" (superclassOf _group)

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
		_group.pos      = obj.pos
		_group.rotation = obj.rotation
	),
	
	/** _align pivot
	 */
	function _alignPivot =
	(
		_group.pivot = obj.pivot
	),

	/** Add group to layer where object is
	*/
	function _addGroupToLayer =
	(
		last_sel_layer = obj.layer
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
		
		this._setObj()
		
		 this._createGroup()
		
		if( classOf _group != Dummy ) then 
			return false

		--this._saveObjectsPositions()
		--
		--this._alignPositionAndRotation()
		--
		--this._loadObjectsPositions()
		--
		--this._alignPivot()
		--
		--this._addGroupToLayer()
	)
)