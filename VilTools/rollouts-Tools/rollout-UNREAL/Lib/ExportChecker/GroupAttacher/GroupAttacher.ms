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
	function _attachObjects _group =
	(
		format "\n"; print ("GroupAttacher_v._attachObjects() " + _group.name)
		group_members = this._getGroupMembers(_group)

		new_object = this._createEmptyObject (_group)
		
		for group_member in group_members do
			polyop.attach new_object group_member
		
		if isValidNode _group  then 
			delete _group
	),
	
	/** _get group members
	 */
	function _getGroupMembers _group =
	(
		for child in _group.children where isGroupMember (child) collect child
	),
	
	/** _create empty object
	 */
	function _createEmptyObject _group =
	(
		--format "\n"; print "GroupAttacher_v._createEmptyObject()"
		
		new_object = convertTo (Editable_mesh name:_group.name) Editable_Poly --convert to Editable_Poly
		
		new_object.pivot	= _group.pivot
		new_object.transform	= _group.transform

		this._relinkHierarchy (_group) (new_object)
		
		new_object --return
	),
	
	/** _relink hierarchy
	 */
	function _relinkHierarchy _group new_object =
	(
		for child in _group.children do 
			child.parent = new_object
		
		if isGroupMember (_group) then 
			attachNodesToGroup #(new_object) _group.parent
		else
			new_object.parent	= _group.parent
	),	
	
	/**  
	 */
	on create do
	(
		print("GroupAttacher_v.onCreate()")
		ConstructPropeties test:this
		
		for _group in groups do
			this._attachObjects(_group)
		
	)
	
)
