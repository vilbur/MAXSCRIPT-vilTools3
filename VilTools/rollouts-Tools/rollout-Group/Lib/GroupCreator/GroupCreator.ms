
/** Group creator
 */
struct GroupCreator_v
(	
	/* properties */
	obj,
	_selection,
	_group,
	
	member_pos = #(),
	member_rot = #(),
				

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
		obj  = _selection[1]	
	),
	
	/** Create group
	 */
	function _createGroup  =
	(
		_group = group _selection name:( toUpper _selection[1].name ) select:true
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

	
	/**  
	 */
	on create do
	(
		if selection.count < 2 do
			return false
		
		this._setSelection()
		
		this._setObj()
		
		this._createGroup()

		this._saveObjectsPositions()

		this._alignPositionAndRotation()

		this._loadObjectsPositions()
	
		this._alignPivot()
		
	)
)