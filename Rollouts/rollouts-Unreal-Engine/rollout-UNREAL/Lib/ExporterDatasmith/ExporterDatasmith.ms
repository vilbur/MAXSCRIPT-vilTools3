filein( getFilenamePath(getSourceFileName()) + "/ExportChecker/ExportChecker.ms" )


/** Exporter datasmith
  *
  *
  *
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
	
	
	private
	

	/** Export
	  *
	  *
	 */
	function _export =
	(
		ExportChecker = ExportChecker_v export_nodes: export_nodes
		
		ExportChecker.validateNodes()

		ExportChecker.analyzeGroups()
			
		holdMaxFile()
		--format "ExportChecker.export_nodes	= % \n" ExportChecker.export_nodes
		if( ExportChecker.groups_to_attach.count > 0 ) then
			GroupAttacher_v groups:ExportChecker.groups_to_attach

		node_name = ExportChecker.export_nodes[1].name

		try
		(
			/* EXPORT */ 
			for export_node in ExportChecker.export_nodes do 
				this._exportNode (export_node) (getUserProp export_node "export-dir")
		)
		catch(
			messageBox "Export Failed" title:"Export Failed"  beep:true

			getCurrentException() 
		)
		
		--if( ExportChecker.groups_to_attach.count > 0 ) then
			fetchMaxFile quiet:true
			
		print ("EXPORT OF " +node_name+ " SUCCESSFUL " + (getLocalTime())[5] as string + ":"+ (getLocalTime())[6] as string )
	),

	/** Export
	 */
	function _exportNode export_node export_dir =
	(
		print("ExporterDatasmith_v._exportNode() " + export_node.name )

		select (this._getAllChildren(export_node))
		
		selection.isHidden = false
		
		DatasmithExport.IncludeTarget	= #SelectedObjects               
		DatasmithExport.AnimatedTransforms	= #CurrentFrame
		
		DatasmithExport.Export (export_dir+"\\"+export_node.name+".udatasmith") true    -- set your own path and filename
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
		
		this._export()
	)	
)