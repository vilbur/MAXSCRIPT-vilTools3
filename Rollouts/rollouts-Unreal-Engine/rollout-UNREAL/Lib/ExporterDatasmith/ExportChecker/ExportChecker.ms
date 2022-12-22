filein( getFilenamePath(getSourceFileName()) + "/GroupToObjectBaker/GroupToObjectBaker.ms" )

/** Analyze objects for export
  *
  * Group will be attached if:
  * 	1) Contains only GeometryClass objects will be merged
  *
  *
  * Group will NOT be attached if:
  * 	1) If group name is UPPERCASE
  *
  *
 */
struct ExportChecker_v
(
	--__construct = #( #export_nodes ),

	/* construct */
	export_nodes = #(),

	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	groups_to_attach = #(),

	DEBUG = true,
	--DEBUG = false,

	/** Test Export objects
	 */
	function test =
	(
		--format "\n"; print "ExporterDatasmith_v.test()"
		GLOBAL_SELECTION_LAST_ENABLED = false

		this.validateNodes()

		this.analyzeGroups()

		objects_to_check = #()
		ingnore_attach_objects = #()

		format "groups_to_attach	= % \n" groups_to_attach

		for _group in groups_to_attach do join ingnore_attach_objects (this._getAllChildren(_group))

		--for _node in ingnore_attach_objects do
			--format "_node	= % \n" _node.name

		for _node in export_nodes do
			for obj in this._getAllChildren(_node) where findItem ingnore_attach_objects obj == 0 do
			(
				default_object_names = "Group\d+|Object\d+|Box\d+|Sphere\d+|Cylinder\d+|Line\d+|Circle\d+|Text\d+"
				--format "obj.name	= % \n" obj.name
				match_default_name = (( dotNetClass "System.Text.RegularExpressions.RegEx" ).match obj.name default_object_names ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase ).success

				if match_default_name then
					append objects_to_check obj
			)

		select objects_to_check

		--for obj in objects_to_check do
			--format "obj	= % \n" obj.name

		format "% OBJECTS WITH DEFAULT NAMES SELECTED\n" objects_to_check.count
		--holdMaxFile()
		----format "ExportChecker.export_nodes	= % \n" ExportChecker.export_nodes
		--if( ExportChecker.groups_to_attach.count > 0 ) then
		--	GroupAttacher_v groups:ExportChecker.groups_to_attach
		--
		--node_name = ExportChecker.export_nodes[1].name
		--
		--try
		--(
		--	/* EXPORT */
		--	for export_node in ExportChecker.export_nodes do
		--		this._exportNode (export_node) (getUserProp export_node "export-dir")
		--)
		--catch(
		--	messageBox "Export Failed" title:"Export Failed"  beep:true
		--
		--	getCurrentException()
		--)
		--
		----if( ExportChecker.groups_to_attach.count > 0 ) then
		--	fetchMaxFile quiet:true
		--
		--print ("EXPORT OF " +node_name+ " SUCCESSFUL " + (getLocalTime())[5] as string + ":"+ (getLocalTime())[6] as string )
		--
		GLOBAL_SELECTION_LAST_ENABLED = true
	),

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
		--format "\n"; print "ExportChecker_v._getGroupsForAttach()"
		node_children = this._getAllChildren (export_node)

		for _group in this._getGroups(node_children) where not this._containGroup(_group) and not this._isUpperCaseName(_group.name) collect _group
	),

	/** Test if group contain only geometry
	  *
	  * @return	type
	 */
	function _containGroup _group =
	(
		--format "\n"; print ("ExportChecker_v._containGroup() _group: " + _group.name)
		(for child in _group.children where isGroupHead child collect child).count > 0 --return
	),

	/** _group name has lower case characters
	 */
	function _isUpperCaseName group_name =
	(

		--(( dotNetClass "System.Text.RegularExpressions.RegEx" ).match group_name "[a-z]").success == false

		is_uppercase = (( dotNetClass "System.Text.RegularExpressions.RegEx" ).match group_name "[a-z]").success == false

		if DEBUG then
		(
			format "\n"; print "ExportChecker_v._isUpperCaseName()"

			format "group:	'%' is uppercase: % \n\n" group_name is_uppercase
		)

		is_uppercase --return
	),


	--/** _get group members
	-- */
	--function _getGroupMembers _group =
	--(
	--	for child in _group.children where isGroupMember (child) collect child
	--),

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

	/** _get group objects
	 */
	function _getGroups _objects =
	(
		for obj in _objects where isGroupHead obj collect obj
	),

	/**
	 */
	on create do
	(
		--print("ExportChecker_v.onCreate()")
		--ConstructPropeties test:this
	)

)
