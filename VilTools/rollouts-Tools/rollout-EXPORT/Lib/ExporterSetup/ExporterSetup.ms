filein( getFilenamePath(getSourceFileName()) + "/../ObjExporter/ObjExporter.ms" )	-- "./../ObjExporter/ObjExporter.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../rollouts-ExportTo/rollout-3D-PRINT/Lib/PrinterVolume.ms" )	-- "./../../rollouts-ExportTo/rollout-3D-PRINT/Lib/PrinterVolume.ms"

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
		selectExportNodeInListCallbackRemove()

		NodeList.nodelist_control = ROLLOUT_export.ML_nodes

		this.selected_nodes =  NodeList.getSelectedNodesInList()

		if( this.selected_nodes.count > 0 ) then
		(

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

		selectExportNodeInListCallbactAdd()
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
		exported_paths = #()

		/** Open in
		 */
		function openIn exported_paths =
		(
			--format "\n"; print "ExporterSetup_v.openIn()"
			open_paths = ""
			for exported_path in exported_paths where doesFileExist exported_path do open_paths += " \""+exported_path+"\""

			if (open_in_program = ROLLOUT_3d_print.RB_open_in_program.state) > 0 then
				if open_in_program == 1 then -- OPEN IN Chitubox.exe
					ShellLaunch 	("\""+post_export_open_paths[open_in_program]+"\"") ( open_paths ) -- format of command to open files in chitubox: "Chitubox.exe" "file 1.obj" "file .obj"
		)


		/** Check if selected nodes has animation keys
		  *
		  * @param name controller_type #position|#rotation|#scale
		  *
		  * @return integer of last key of animation
		 */
		function _getLastKeyOfAnimation export_nodes controller_type =
		(
			--format "\n"; print "ExporterSetup_v._getLastKeyOfRotateAnimation()"
			last_keyframe 	= 0

			for export_node in export_nodes where (anim_keys = export_node.getAnimationKeys(controller_type) ).count > 0 do
				if anim_keys[anim_keys.count] > last_keyframe then  -- get last key if higher
					last_keyframe = anim_keys[anim_keys.count]

			last_keyframe --return
		)

		/*------------------------------------------------------------------------------
			EXPORT PROCESS
		--------------------------------------------------------------------------------*/

		/* SET EXPORT KEYFRAME */
		if ( rotation_key = _getLastKeyOfAnimation(this.selected_nodes)(#rotation) ) > 0 then
			this._setTimeSlider (rotation_key)

		/* CREATE BOXES TO CORNERS OF PRINT PLANE  TO KEEP EXPORTED POSITION */
		printer_dimension_objects = if ( rotation_key = _getLastKeyOfAnimation(this.selected_nodes)(#position) ) > 0 then
			(PrinterVolume_v()).volumeDimensionObject(ROLLOUT_export.SPIN_export_size.value) else #()


		try(
			for selected_node in this.selected_nodes do
			(
				export_path	= this._getExportFilePath(selected_node)
				export_dir	= getFilenamePath(export_path)
				export_result	= false

				export_objects = selected_node.getAllChildren() + printer_dimension_objects
				--format "export_objects	= % \n" export_objects
				if this._direcotryExists ( this._getExportDir(selected_node.export_dir)) then
				(
					/*------ EXPORT ------*/
					export_result = Exporter.export ( export_objects ) (export_path)

					if export_result != false then
						append exported_paths export_path
				)
			)

			delete printer_dimension_objects

		)
		catch
		(
			delete printer_dimension_objects
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

	/*------------------------------------------------------------------------------

		HELPERS

	--------------------------------------------------------------------------------*/
	/**
	*
	*/
	function _getExportDir export_dir =
	(
		--format "\n"; print "ExporterSetup_v._getExportDir()"

		export_dir	= trimLeft export_dir "."

		maxFilePath + export_dir
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

	/** Set time slider
	 */
	function _setTimeSlider keyframe =
	(
		--format "\n"; print "ExporterSetup_v.setTimeSlider()"

		current_keyframe	= (( sliderTime ) as string ) as integer

		/* MOVE TIME SLIDER */
		if current_keyframe != keyframe then
			if queryBox ("Exported nodes has animation of rotation.\n\nWould you like to export key "+keyframe as string +" ?" ) title:"Export animation key"  beep:false then
				sliderTime = keyframe
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
