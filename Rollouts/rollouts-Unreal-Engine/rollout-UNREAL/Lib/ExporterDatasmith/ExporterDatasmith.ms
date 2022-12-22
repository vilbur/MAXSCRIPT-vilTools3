filein( getFilenamePath(getSourceFileName()) + "/ExportChecker/ExportChecker.ms" )


/** Exporter datasmith
  *
  *
  * UNREAL ENGINE IMPORT HELP: https://docs.unrealengine.com/4.27/en-US/Basics/AssetsAndPackages/AutoReImport/
  */
struct ExporterDatasmith_v
(
	__construct = #( #export_nodes ),

	/* construct */
	export_nodes = #(),

	/* construct */
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */

	/** Export
	  *
	  * @param	boolean	pre_export	if true then export
	 */
	function export pre_export:false =
	(
		GLOBAL_SELECTION_LAST_ENABLED = false

		ExportChecker = ExportChecker_v export_nodes: export_nodes

		ExportChecker.validateNodes()

		ExportChecker.analyzeGroups()

		holdMaxFile()

		if( ExportChecker.groups_to_attach.count > 0 ) then
			GroupToObjectBaker_v groups:ExportChecker.groups_to_attach

		node_name = ExportChecker.export_nodes[1].name

		try
		(
			/* EXPORT */
			for export_node in ExportChecker.export_nodes do
			(
				if pre_export == false then
					this._exportNode (export_node) (getUserProp export_node "export-dir")
				else
					this._preExportNode (export_node) (getUserProp export_node "export-dir")
			)
		)
		catch(
			messageBox "Export Failed" title:"Export Failed"  beep:true

			getCurrentException()
		)

		fetchMaxFile quiet:true

		print ("EXPORT OF " +node_name+ " SUCCESSFUL " + (getLocalTime())[5] as string + ":"+ (getLocalTime())[6] as string )

		GLOBAL_SELECTION_LAST_ENABLED = true
	),

	/** Select child nodes
	 */
	function selectChildNodes =
	(
		format "\n"; print "ExporterDatasmith_v.selectChildNodes()"

		all_children	= #()

		for export_node in export_nodes do
			all_children += this._getAllChildren(export_node)

		all_children --return
	),


	private


	/** Export
	 */
	function _exportNode export_node export_dir =
	(
		print("ExporterDatasmith_v._exportNode() " + export_node.name )

		all_children = (this._getAllChildren(export_node))

		for o in all_children where o.ishidden do
			o.ishidden = false

		select all_children

		DatasmithExport.IncludeTarget	= #SelectedObjects
		DatasmithExport.AnimatedTransforms	= #CurrentFrame

		DatasmithExport.Export (export_dir+"\\"+export_node.name+".udatasmith") true    -- set your own path and filename
	),

	/** Save Eported nodes as separated max files in export folder
	  *
	  *
	  *
	 */
	function _preExportNode export_node export_dir =
	(
		print("ExporterDatasmith_v._exportNode() " + export_node.name )

		select (this._getAllChildren(export_node))

		selection.isHidden = false

		--DatasmithExport.IncludeTarget	= #SelectedObjects
		--DatasmithExport.AnimatedTransforms	= #CurrentFrame
 		saveNodes selection (export_dir+"\\"+export_node.name+".max") quiet:true

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
		--print("ExporterDatasmith_v.onCreate()")
		ConstructPropeties test:this
	)
)