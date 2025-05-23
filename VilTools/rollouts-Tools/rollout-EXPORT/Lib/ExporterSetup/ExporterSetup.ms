filein( getFilenamePath(getSourceFileName()) + "/../ExporterOBJ/ExporterOBJ.ms" )	-- "./../ExporterOBJ/ExporterOBJ.ms"
filein( getFilenamePath(getSourceFileName()) + "/../ExporterSTL/ExporterSTL.ms" )	-- "./../ExporterSTL/ExporterSTL.ms"


filein( getFilenamePath(getSourceFileName()) + "/../../rollouts-ExportTo/rollout-3D-PRINT/Lib/PrintExporter/PrintExporter.ms" )	--"./../../rollouts-ExportTo/rollout-3D-PRINT/Lib/PrintExporter/PrintExporter.ms"

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
		format "\n"; print "ExporterSetup_v.export()"

		whenExportNodeSelectedStart()

		if( (this._getSelectedNodes()).count > 0 ) then
		(
			format "EXPORT_NODES: %\n" export_nodes

			case export_type of
			(
				#Obj:	this._exportObj()
				#Print:	this._exportPrint()
				#Unreal:	this._exportUnreal()
			)
		)


		else
			messageBox "Please select node in list" title:"Export node is not selected"

		whenExportNodeSelectedStop()
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
		format "\n"; print "ExporterSetup_v._exportObj()"
		--ObjExporter 	= ObjExporter_v(#obj)
	),

	/** Export print
	 */
	function _exportPrint =
	(
		--format "\n"; print "ExporterSetup_v._exportPrint()"
		--format "ROLLOUT_export.SPIN_export_size.value:	% \n" ROLLOUT_export.SPIN_export_size.value

		format "\nEXPORTING 3D PRINT\n"

		Exporter =	(PrintExporter_v(this.export_nodes))

		print_rollout = ROLLOUT_export.ExportTo.ROLLOUT_3d_print

		Exporter.params[#EXPORT_FORMAT]	= #("obj", "stl")[print_rollout.RB_export_format.state]
		Exporter.params[#EXPORT_SCALE]	= ROLLOUT_export.SPIN_export_size.value
		Exporter.params[#SUBDIR_BY_NODE]	= ROLLOUT_export.CBX_sub_directory_by_node_name.checked

		Exporter.params[#FIX_POSITION]	= ROLLOUT_3d_print.CBX_fix_position.state
		Exporter.params[#MESHSMOOTH]	= ROLLOUT_3d_print.CBX_meshsmooth.state

		Exporter.params[#PROJECT_FILE_OPEN]	= print_rollout.CBX_project_file_open.state
		Exporter.params[#CLOSE_INSTANCES]	= print_rollout.CBX_single_instance.state
		Exporter.params[#OPEN_IN]	= print_rollout.RB_open_in_program.state
		Exporter.params[#EXCLUDE]	= print_rollout.ET_exclude.text

		Exporter.export()

		return true
	),

	/** Export unreal
	 */
	function _exportUnreal =
	(
		format "\n"; print "ExporterSetup_v._exportUnreal()"
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
		format "\n"; print "ExporterSetup_v.onCreate()"
		this.ROLLOUT_export = execute "ROLLOUT_export"
	)

)
