filein( getFilenamePath(getSourceFileName()) + "/../ObjExporter/ObjExporter.ms" )	-- "./../ObjExporter/ObjExporter.ms"

/** Exporter Setup
 */
struct ExporterSetup_v
(
	/* construct */


	/* properties */
	export_type,
	selected_nodes,

	/* dependency */
	/* reference */
	/* inhered */


	/** Export
	  *
	  * @parameter name export_type #Unreal|#Print|#Obj
	 */
	function export =
	(
		format "\n"; print "PrintExporter_v.export()"
		format "export_type	= % \n" export_type

		--selected_nodes =  ((NodeList_v(ROLLOUT_export.ML_nodes)).getSelectedNodes())

		if( selected_nodes.count > 0 ) then
			with redraw off
				case export_type of
				(
					#Obj:	this._exportObj()
					#Print:	this._exportPrint()
					#Zbrush:	this._exportZbrush()
					#Unreal:	this._exportUnreal()
				)
		else
			messageBox "Please select node in list" title:"Export node is not selected"

	),

	private

	/** Export obj
	 */
	function _exportObj =
	(
		format "\n"; print "Exporter_v._exportObj()"
		ObjExporter 	= ObjExporter_v(#obj)
	),

	/** Export print
	 */
	function _exportPrint =
	(
		format "\n"; print "Exporter_v._exportPrint()"

		ObjExporter 	= ObjExporter_v(#Print)

		--(PrintExporter_v export_nodes:selected_nodes).export()
	),

	/** Export unreal
	 */
	function _exportUnreal =
	(
		format "\n"; print "Exporter_v._exportUnreal()"
	),

	/** Export obj
	 */
	function _exportZbrush =
	(
		format "\n"; print "Exporter_v._exportObj()"
		ObjExporter 	= ObjExporter_v(#zbrush)

	),



	/**
	 */
	on create do
	(
		--format "\n"; print "PrintExporter.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
