filein( getFilenamePath(getSourceFileName()) + "/../ExportChecker/ExportChecker.ms" )


/** Exporter datasmith
 */
struct ExporterDatasmith_v
(
	--__construct = #( #property_name ),
	
	/* construct */
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	
	
	/** Export
	 */
	function export export_node export_dir =
	(
		
		select (this._getAllChildren(export_node))
		
		--deselect export_node
		
		DatasmithExport.IncludeTarget	= #SelectedObjects               
		DatasmithExport.AnimatedTransforms	= #CurrentFrame

		DatasmithExport.Export (export_dir+"\\"+export_node.name+".udatasmith") true    -- set your own path and filename
	),
	
	

	private
	
	
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
		--ConstructPropeties test:this
	)
	
)
