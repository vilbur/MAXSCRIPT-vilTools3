/** Export checker
  
  
  
  
  
 */
struct ExportChecker_v
(
	__construct = #( #export_node ),
	
	/* construct */
	export_node,
	
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	/** Attach objects in groups
	 */
	function attachObjectsInGroups =
	(
		format "\n"; print "ExportChecker_v.attachObjectsInGroups()"
		format "export_node	= % \n" export_node
				
		node_children = this._getAllChildren (export_node)
		
		groups = this._getGroupObjects (node_children)
		
		for _group in groups do 
			this._attachObjects _group
		
	),
	

	private

	/** _get group objects
	 */
	function _getGroupObjects _objects =
	(
		for obj in _objects where isGroupHead(obj) collect obj
	),
	
	/** _attach objects
	 */
	function _attachObjects _group =
	(
		format "\n"; print "ExportChecker_v._attachObjects()"
		
		group_members = this._getGroupMembers(_group)
		
		new_object = this._createEmptyObject (_group)
		
		for obj in group_members do
			polyop.attach new_object obj

		new_object.parent	= _group.parent
		
		for child in _group.children do 
			child.parent = new_object

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
		format "\n"; print "ExportChecker_v._createEmptyObject()"
		new_object = editable_mesh name:_group.name --create an empty EMesh
		
		new_object.pivot = _group.pivot
		
		convertTo new_object Editable_Poly --convert to Editable_Poly
		format "new_object	= % \n" new_object
		new_object --return
	),
	
		
	/**  Get all nested children
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
		--print("ExportChecker_v.onCreate()")
		ConstructPropeties test:this
	)
	
)
