filein( getFilenamePath(getSourceFileName()) + "/../ObjExporter/ObjExporter.ms" )	-- "./../ObjExporter/ObjExporter.ms"

/** Exporter Setup
 */
struct ExporterSetup_v
(
	/* construct */


	/* properties */
	export_type,
	selected_nodes,

	Exporter,

	post_export_open_paths = #("C:/Program Files/CHITUBOX  V1.9.4/CHITUBOX.exe", "C:/Program Files/LycheeSlicer/LycheeSlicer.exe"), -- index same as radiobuttons ROLLOUT_3d_print.RB_open_in_program

	/* dependency */
	NodeList = NodeList_v(),
	/* reference */
	/* inhered */

	/** Export
	  *
	  * @parameter name export_type #Unreal|#Print|#Obj
	 */
	function export =
	(
		format "\n"; print "PrintExporter_v.export()"
		--this.selected_nodes =  ((NodeList_v(ROLLOUT_export.ML_nodes)).getSelectedNodesInList())
		NodeList.nodelist_control = ROLLOUT_export.ML_nodes

		this.selected_nodes =  NodeList.getSelectedNodesInList()

		if( this.selected_nodes.count > 0 ) then
		(
			this._checkAnimation(selected_nodes)

			if export_type != #Unreal then
			(
				Exporter = ObjExporter_v(export_type)

				Exporter.setIni("ObjScale")(ROLLOUT_export.SPIN_export_size.value)
			)

			case export_type of
			(
				#Obj:	this._exportObj()
				#Print:	this._exportPrint()
				#Zbrush:	this._exportZbrush()
				#Unreal:	this._exportUnreal()
			)
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
		--ObjExporter 	= ObjExporter_v(#obj)
	),

	/** Export print
	 */
	function _exportPrint =
	(
		--format "\n"; print "Exporter_v._exportPrint()"
		--for selected_node in this.selected_nodes where this._direcotryExists (getFilenamePath(this._getExportFilePath(selected_node))) do
		exported_paths = #()

		/** Open in
		 */
		function openIn exported_paths =
		(
			--format "\n"; print "ExporterSetup_v.openIn()"
			--format "exported_paths	= % \n" exported_paths
			open_paths = ""
			for exported_path in exported_paths where doesFileExist exported_path do open_paths += " \""+exported_path+"\""
			--format "open_paths	= % \n" open_paths

			if (open_in_program = ROLLOUT_3d_print.RB_open_in_program.state) > 0 then
				if open_in_program == 1 then -- OPEN IN Chitubox.exe
					ShellLaunch 	("\""+post_export_open_paths[open_in_program]+"\"") ( open_paths ) -- format of command to open files in chitubox: "Chitubox.exe" "file 1.obj" "file .obj"

		)

		for selected_node in this.selected_nodes do
		(
			export_path	= this._getExportFilePath(selected_node)
			export_dir	= getFilenamePath(export_path)
			export_result	= false

			if this._direcotryExists ( this._getExportDir(selected_node.export_dir)) then
			(
				export_result = Exporter.export ( selected_node.getAllChildren() ) (export_path)
				--format "export_result	= % \n" export_result
				if export_result != false then
					append exported_paths export_path
			)
		)

		openIn(exported_paths)
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

	/** Get export file path
	 */
	function _getExportFilePath export_node =
	(
		--format "\n"; print "ExporterSetup_v._getExportFilePath()"
		subdir = if ROLLOUT_export.CBX_sub_directory_by_node_name.checked then "/"+export_node.name + "/" else "/"

		export_path =  (this._getExportDir(export_node.export_dir)) + subdir + export_node.name + ".obj"

		( dotNetObject "System.Text.RegularExpressions.Regex" @"[\\/]+" ).Replace export_path "\\\\" -- return
	),

	function _getExportDir export_dir =
	(
		--format "\n"; print "ExporterSetup_v._getExportDir()"

		export_dir	= trimLeft export_dir "."

		maxFilePath + export_dir
	),

	/** 1) Check if selected nodes has any animation keys
	  * 2) Move time slider to last animation key if confirmed by user
	  *
	  * WORKS ONLY WITH ROTATION
	 */
	function _checkAnimation export_nodes =
	(
		--format "\n"; print "ExporterSetup_v._checkAnimation()"
		export_keyframe 	= 0
		current_keyframe	= (( sliderTime ) as string ) as integer

		/* GET LAST ANIMATION KEY OPF SELECTED NODES */
		for export_node in export_nodes where (anim_keys = export_node.getAnimationKeys() ).count > 0 do
			if anim_keys[anim_keys.count] > export_keyframe then
				export_keyframe = anim_keys[anim_keys.count]

		/* MOVE TIME SLIDER */
		if current_keyframe != export_keyframe then
			if queryBox ("Exported nodes has animation of rotation.\n\nWould you like to export key "+export_keyframe as string +" ?" ) title:"Export animation key"  beep:false then
				sliderTime = export_keyframe

	),

	/** Direcotry exists
	 */
	function _direcotryExists export_dir =
	(
		--format "\n"; print "ExporterSetup_v._direcotryExists()"

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
