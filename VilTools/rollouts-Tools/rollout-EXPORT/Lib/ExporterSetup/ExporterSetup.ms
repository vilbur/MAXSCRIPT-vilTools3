filein( getFilenamePath(getSourceFileName()) + "/../ObjExporter/ObjExporter.ms" )	-- "./../ObjExporter/ObjExporter.ms"


filein( getFilenamePath(getSourceFileName()) + "/../../rollouts-ExportTo/rollout-3D-PRINT/Lib/PrintExporter/PrintExporter.ms" )	-- "./../../rollouts-ExportTo/rollout-3D-PRINT/Lib/PrintExporter/PrintExporter.ms"

/** Manage export to different formats
  *
  * @property #name export_type #Obj|#Print|#Zbrush|#Unreal
  *
  *
 */
struct ExporterSetup_v
(
	/* construct */
	export_type,


	/* properties */
	--params	= Dictionary #( #size, 1 ) #( #key2, #value2 ), -- PREPARED IF MORE THAN SIZE PARAMETER WILL BE USED

	export_nodes,

	ROLLOUT_export, -- UI rollout


	/* dependency */
	Exporter,
	--PrintExporter,
	NodeList,

	/* inhered */

	/** Export
	  *
	  * @parameter name export_type #Unreal|#Print|#Obj
	 */
	function export  =
	(
		format "\n"; print "PrintExporter_v.export()"

		selectExportNodeInListCallbackRemove()

		if( (this._getSelectedNodes()).count > 0 ) then

			case export_type of
			(
				#Obj:	this._exportObj()
				#Print:	this._exportPrint()
				#Zbrush:	this._exportZbrush()
				#Unreal:	this._exportUnreal()
			)

		else
			messageBox "Please select node in list" title:"Export node is not selected"

		selectExportNodeInListCallbactAdd()
	),


	private


	/** Get slected nodes in multilistbox
	 */
	function _getSelectedNodes =
	(
		--format "\n"; print "ExporterSetup_v._getSelectedNodes()"
		this.export_nodes = ((NodeList_v(ROLLOUT_export.ML_nodes)).getSelectedNodesInList())
	),

	/** Export obj
	 */
	function _exportObj =
	(
		format "\n"; print "Exporter_v._exportObj()"
		--ObjExporter 	= ObjExporter_v(#obj)
	),

	/** Export print
	 */
	function _exportPrint =
	(
		format "\n"; print "Exporter_v._exportPrint()"
		PrintExporter =	(PrintExporter_v(this.export_nodes))

		PrintExporter.params[#EXPORT_SCALE]	= ROLLOUT_export.SPIN_export_size.value
		PrintExporter.params[#SUBDIR_BY_NODE]	= ROLLOUT_export.CBX_sub_directory_by_node_name.checked
		PrintExporter.params[#FIX_POSITION]	= ROLLOUT_export.ExportTo.ROLLOUT_3d_print.CBX_fix_position.state
		PrintExporter.params[#PROJECT_FILE_OPEN]	= ROLLOUT_export.ExportTo.ROLLOUT_3d_print.CBX_project_file_open.state
		PrintExporter.params[#OPEN_IN]	= ROLLOUT_export.ExportTo.ROLLOUT_3d_print.RB_open_in_program.state

		PrintExporter.export()

		return true
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
	),

	/*------------------------------------------------------------------------------

		HELPERS

	--------------------------------------------------------------------------------*/

	--/** Get export size
	-- */
	--function _getExportSize =
	--(
	--	--format "\n"; print "ExporterSetup_v._getExportSize()"
	--	ROLLOUT_export.SPIN_export_size.value --return
	--),

	--/** Get export file path
	-- */
	--function _getExportFilePath export_node =
	--(
	--	--format "\n"; print "ExporterSetup_v._getExportFilePath()"
	--	subdir = if this.ROLLOUT_export.CBX_sub_directory_by_node_name.checked then "/"+export_node.name + "/" else "/"
	--
	--	export_path =  (this._getExportDir(export_node.export_dir)) + subdir + export_node.name + ".obj"
	--
	--	( dotNetObject "System.Text.RegularExpressions.Regex" @"[\\/]+" ).Replace export_path "\\\\" -- return
	--),
	--
	--/**
	--*
	--*/
	--function _getExportDir export_dir =
	--(
	--	maxFilePath + (trimLeft export_dir ".\\")
	--),




	/**
	 */
	on create do
	(
		--format "\n"; print "ExporterSetup_v.onCreate()"
		this.ROLLOUT_export = execute "ROLLOUT_export"
	)

)
