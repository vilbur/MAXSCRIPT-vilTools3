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
		--format "export_type	= % \n" export_type

		selected_nodes =  ((NodeList_v(ROLLOUT_export.ML_nodes)).getSelectedNodesInList())

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

		for selected_node in this.selected_nodes where this._direcotryExists (selected_node.export_dir) do
			ObjExporter.export (this._getAllChildren(selected_node)) (this._getExportFilePath(selected_node))
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

	/** Get export file path
	 */
	function _getExportFilePath export_node =
	(
		format "\n"; print "ExporterSetup_v._getExportFilePath()"
		export_node.export_dir + "/" + export_node.name + ".obj" -- return
	),

	/** Select child nodes
	 */
	function _getAllChildren export_nodes =
	(
		format "\n"; print "NodeList_v.selectChildNodes()"

		all_children	= #()

		for export_node in export_nodes do
			all_children += this._getAllChildren(export_node)

		all_children --return
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
		arr --return

	),

	/** Direcotry exists
	 */
	function _direcotryExists export_dir =
	(
		format "\n"; print "ExporterSetup_v._direcotryExists()"

		--format "EXPORT_NODE.EXPORT_DIR	= % \n" export_node.export_dir
		--format "EXPORT_NODE.PROPERTIES	= % \n" ( showProperties export_node)

		if not doesFileExist export_dir then
		(
			if queryBox ("Export dir does not exists:\n\n " + export_dir + "\n\nWOULD YOU LIKE TO CREATE IT ?" ) title:"Title"  beep:false then
				makeDir export_dir all:true --return

			else
				false --return
		)
		else
			true --return
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
