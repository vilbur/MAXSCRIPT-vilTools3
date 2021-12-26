filein( getFilenamePath(getSourceFileName()) + "/GroupAttacher/GroupAttacher.ms" )

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
	
	/** Find if exported objects contains any attachable groups
	 */
	function analyzeGroups =
	(
		--format "\n"; print "ExportChecker_v._testGroups()"
		for export_node in export_nodes where export_node != undefined  do
			join groups_to_attach  (this._getGroupsForAttach(export_node))
	),
	
	/** _validate nodes
	 */
	function validateNodes =
	(
		export_nodes = for export_node in export_nodes where export_node != undefined and ( export_dir = getUserProp export_node "export-dir") != undefined collect export_node
	),
	
	
	private

	
	/** Get groups where members will be attached together 
	  * Only groups which contain ONLY meshes will be merged
	  *
	  * @return	Array	of group nodes
	 */
	function _getGroupsForAttach export_node =
	(
		format "\n"; print "ExportChecker_v._getGroupsForAttach()"		
		node_children = this._getAllChildren (export_node)
		
		groups = this._getGroups (node_children)
		
		for _group in groups where this._membersAreGeometry(_group) collect _group
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
		--format "\n"; print ("ExportChecker_v._membersAreGeometry() " + _group.name)
		--non_geometry_objects	= #()
		non_geometry_objects = for child in this._getGroupMembers(_group) where superClassOf child != GeometryClass collect child
		--format "result	= % \n" (non_geometry_objects.count == 0)
		non_geometry_objects.count == 0 --return
	),
	
	/** _get group members
	 */
	function _getGroupMembers _group =
	(
		for child in _group.children where isGroupMember (child) collect child
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
