filein( getFilenamePath(getSourceFileName()) + "/../PrinterVolume/PrinterVolume.ms" )	-- "./../PrinterVolume/PrinterVolume.ms"


/** Print exporter
  *
  * Template files for new projects: -- "./../../Final-Files-Templates/"
  *
  * @param 2DMatrix open_in_programs #( #("C:\Path\to\program.exe", "project_file_extension") )
  *
  * How to export objects on exact position and rotation:
  * 		1) Create animation of nodes with desired position and rotation
  * 		2) Last animation key of node is set to export
  * 		3) If position key is set, then dummy boxes are exported in corners of printer plate (this will keep objects on right position)
 */
struct PrintExporter_v
(
	/* construct */
	export_nodes,


	/* properties */
	params	= Dictionary #( #EXPORT_SCALE, 1 ) #( #SUBDIR_BY_NODE, false ) #( #FIX_POSITION, false ) #( #OPEN_IN, 0 ) #( #PROJECT_FILE_OPEN, false ) ,

	open_in_programs = #( #("C:/Program Files/CHITUBOX  V1.9.4/Chitubox.exe", "chitubox"), #("C:/Program Files/LycheeSlicer/LycheeSlicer.exe", "lys")),

	exported_paths = #(),

	anim_keys	= Dictionary #( #position, 0 ) #( #rotation, 0 ),

	fetch_state	= Dictionary #( #layer_manager_open, true ),

	export_position_dummy,

	/* dependency */
	Exporter,

	/* reference */
	/* inhered */

	/** Export eachodes
	  * Manage scene on export
	 */
	function export =
	(
		--format "\n"; print "PrintExporter_v.export()"
		--format "params	= % \n" params

		this._setExporter()

		this._holdMaxState()

		this._setExportKeyFrame()

		this._fixExportPosition()

		for selected_node in this.export_nodes do
			this._exportNode (selected_node)

		this._openExportedFiles()

		this._fetchMaxState()

	),


	/** Get export file path
	 */
	function getExportFilePath export_node =
	(
		--format "\n"; print "ExporterSetup_v.getExportFilePath()"
		subdir = if this.params[#SUBDIR_BY_NODE] then "/"+export_node.name + "/" else "/"

		export_path =  (this._getExportDir(export_node.export_dir)) + subdir + export_node.name + ".obj"

		( dotNetObject "System.Text.RegularExpressions.Regex" @"[\\/]+" ).Replace export_path "\\\\" -- return
	),


	/** Open in chitubox
	  *
	  * @param array paths_to_open
	  *
	  * FORMAT OF COMMAND TO OPEN FILES IN CHITUBOX:
	  * 		ShellLaunch "C:/Chitubox.exe" "\"c:\\File_1.obj\" \"c:\\File_1.obj\""
	  *
	 */
	function openInProgram paths_to_open =
	(
		--format "\n"; print "PrintExporter_v.openInProgram()"
		params_string = ""

		for path_to_open in paths_to_open where doesFileExist path_to_open do params_string += " \""+path_to_open+"\""
		--format "this.open_in_programs	= % \n" this.open_in_programs
		ShellLaunch ("\""+ this.open_in_programs[this.params[#OPEN_IN]][1]+"\"") ( params_string )
	),

	private

	/** Hold max state
	 */
	function _holdMaxState =
	(
		--format "\n"; print "PrintExporter_v._holdMaxState()"
		holdMaxFile()

		this.fetch_state[#layer_manager_open] = LayerManager.isDialogOpen()

	),

	/** Fetch max state
	 */
	function _fetchMaxState =
	(
		--format "\n"; print "PrintExporter_v._fetchMaxState()"
		fetchMaxFile quiet:true

		if this.fetch_state[#layer_manager_open] then
			macros.run "Layers" "LayerManager"

		sliderTime = this._getLastAnimKey()
	),

	/*------------------------------------------------------------------------------
		EXPORT NODE
	--------------------------------------------------------------------------------*/
	function _exportNode export_node =
	(
		--format "\n"; print "PrintExporter_v._exportNode()"
		export_path	= this.getExportFilePath(export_node)

		export_objects = export_node.getAllChildren() + this.export_position_dummy

		collapseStack export_objects

		export_result = Exporter.export ( export_objects ) (export_path)

		if export_result != false then
			append this.exported_paths export_path
	),

	/** Open exported files
	 */
	function _openExportedFiles =
	(
		--format "\n"; print "PrintExporter_v._openExportedFiles()"
		if this.exported_paths.count > 0 then
		(
			this._addProjectFileToOpenPaths()

			this.openInProgram(this.exported_paths)
		)
	),


	/** Get path to final file where exported files will be merged
	  *
	  *  Name of merge is parent group of nodes
	  *  Path of merge is export path of first selected node
	  *
	  */
	function _addProjectFileToOpenPaths =
	(

		if this.params[#PROJECT_FILE_OPEN] then
		(
			node_groups = makeUniqueArray( for _node in this.export_nodes where _node.parent != undefined and isGroupHead _node.parent collect _node.parent)

			if node_groups.count > 0 then
			(
				extension = this.open_in_programs[this.params[#OPEN_IN]][2]

				final_file = (this._getExportDir(this.export_nodes[1].export_dir)) + "\\" + node_groups[1].name + "." + extension

				if not doesFileExist final_file then
					copyFile  ( getFilenamePath(getSourceFileName()) + "..\\..\\Final-Files-Templates\\template." + extension ) final_file -- COPY EMPTY FILE "./../../Final-Files-Templates/template.chitubox"

				this.exported_paths = #( final_file ) + this.exported_paths
			)
		)
	),

	/** Set exporter
	 */
	function _setExporter =
	(
		--format "\n"; print "PrintExporter_v._setExporter()"
		Exporter = ObjExporter_v(#Print)

		Exporter.setIni("ObjScale")(this.params[#EXPORT_SCALE])
	),


	/** Move time slider to last key, if export nodes has animated position or rotastion
	  *
	  *
	 */
	function _setExportKeyFrame =
	(
		--format "\n"; print "PrintExporter_v._setExportKeyFrame()"
		this.anim_keys[#position]	= this._getLastKeyOfAnimation(#position)
		this.anim_keys[#rotation]	= this._getLastKeyOfAnimation(#rotation)

		this._setTimeSlider(this._getLastAnimKey())
	),

	/** Get last anim key
	 */
	function _getLastAnimKey =
	(
		--format "\n"; print "PrintExporter_v._getLastAnimKey()"

		anim_key_values = for data_pair in anim_keys where data_pair.value != 0 collect data_pair.value

		if anim_key_values.count > 0 then
			amax anim_key_values --return
		else
			0 --return
	),

	/** create boxes in corners of print plane to keep exported position
	 */
	function _fixExportPosition =
	(
		--format "\n"; print "PrintExporter_v._fixExportPosition()"
		this.export_position_dummy = if this.params[#FIX_POSITION] or this.anim_keys[#position] > 0 then
			(PrinterVolume_v()).volumeDimensionObject(this.params[#EXPORT_SCALE])
		else
			#()
	),


	/** Check if selected nodes has animation keys
	  *
	  * @param name controller_type #position|#rotation|#scale
	  *
	  * @return integer of last key of animation
	 */
	function _getLastKeyOfAnimation controller_type =
	(
		--format "\n"; print "ExporterSetup_v._getLastKeyOfRotateAnimation()"
		last_keyframe 	= 0

		for export_node in this.export_nodes where (node_anim_keys = export_node.getAnimationKeys(controller_type) ).count > 0 do
			if node_anim_keys[node_anim_keys.count] > last_keyframe then  -- get last key if higher
				last_keyframe = node_anim_keys[node_anim_keys.count]

		last_keyframe --return
	),


	/** Export dir consist of CURRENT SCENE PATH + RELATIVE PATH of Export_Node.export_dir
	*
	*/
	function _getExportDir node_export_dir =
	(
		maxFilePath + (trimLeft node_export_dir ".\\")
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

	/**
	 */
	on create do
	(
		format "\n"; print "PrintExporter.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
