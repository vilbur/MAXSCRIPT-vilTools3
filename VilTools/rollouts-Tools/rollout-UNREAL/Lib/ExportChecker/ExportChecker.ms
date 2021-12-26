/** Export checker
  
  
  
  
  
 */
struct ExportChecker_v
(
	__construct = #( #export_nodes ),
	
	/* construct */
	export_nodes = #(),
	
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	groups_to_attach = #(),
	
	/** _test groups
	 */
	function analyzeExport =
	(
		format "\n"; print "ExportChecker_v._testGroups()"
		this._validateNodes()
		format "export_nodes	= % \n" export_nodes
		
		for export_node in export_nodes where export_node != undefined  do
			join groups_to_attach  (this._getGroupsForAttach(export_node))
		
		--format "groups_to_attach	= % \n" groups_to_attach
	),
	
	
	--/** Attach objects in groups
	-- */
	--function attachObjectsInGroups =
	--(
	--	format "\n"; print "ExportChecker_v.attachObjectsInGroups()"
	--	format "export_node	= % \n" export_node
	--			
	--	node_children = this._getAllChildren (export_node)
	--	
	--	groups = this._getGroups (node_children)
	--	
	--	for _group in groups do 
	--		this._attachObjects _group
	--
	--	
	--),
	

	private
	
	/** _validate nodes
	 */
	function _validateNodes =
	(
		export_nodes = for export_node in export_nodes where export_node != undefined and ( export_dir = getUserProp export_node "export-dir") != undefined collect export_node
	),
	
	/** Get groups where members will be attached together 
	  * Only groups which contain ONLY meshes will be merged
	  *
	  * @return	Array	of group nodes
	 */
	function _getGroupsForAttach export_node =
	(
		format "\n"; print "ExportChecker_v._getGroupsForAttach()"
		
		--groups_to_attach = #()
		
		node_children = this._getAllChildren (export_node)
		
		groups = this._getGroups (node_children)
		format "groups	= % \n" groups
		
		for _group in groups where this._membersAreGeometry(_group) collect _group
			--append groups_to_attach 
			--format "_GROUP.name	= % \n" _group.name

		--groups_to_attach --return
	),
	
	/** _get group objects
	 */
	function _getGroups _objects =
	(
		for obj in _objects where isGroupHead(obj) collect obj
	),
	
	/** Test if group contain only geometry
	  *
	  * @return	type	
	 */
	function _membersAreGeometry _group =
	(
		format "\n"; print ("ExportChecker_v._membersAreGeometry() " + _group.name)
		--non_geometry_objects	= #()
		non_geometry_objects = for child in this._getGroupMembers(_group) where superClassOf child != GeometryClass collect child
		format "result	= % \n" (non_geometry_objects.count == 0)
		non_geometry_objects.count == 0 --return
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
