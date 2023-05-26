filein( getFilenamePath(getSourceFileName()) + "/../PrinterVolume/PrinterVolume.ms" )	-- "./../PrinterVolume/PrinterVolume.ms"

/** Print exporter
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
	params	= Dictionary #( #EXPORT_SCALE, 1 ) #( #SUBDIR_BY_NODE, false ) #( #FIX_POSITION, false ) #( #OPEN_IN, 0 ) #( #OPEN_IN_FINAL_FILE, false ) ,

	open_in_programs = #("C:/Program Files/CHITUBOX  V1.9.4/CHITUBOX.exe", "C:/Program Files/LycheeSlicer/LycheeSlicer.exe"), -- index same as radiobuttons ROLLOUT_3d_print.RB_open_in_program

	exported_paths = #(),

	anim_keys	= Dictionary #( #position, 0 ) #( #rotation, 0 ),

	export_position_dummy,

	/* dependency */
	Exporter,

	/* reference */
	/* inhered */

	/** Export
	 */
	function export =
	(
		format "\n"; print "PrintExporter_v.export()"
		format "params	= % \n" params

		this._setExporter()

		holdMaxFile()

		this._setExportKeyFrame()

		this._fixExportPosition()

		for selected_node in this.export_nodes do
			this._exportNode (selected_node)

		this._openExportedFiles()

		fetchMaxFile quiet:true

		--this._deletePositionDummy()
	),


	private


	/*------------------------------------------------------------------------------
		EXPORT NODE
	--------------------------------------------------------------------------------*/
	function _exportNode export_node =
	(
		--format "\n"; print "PrintExporter_v._exportNode()"
		export_path	= this._getExportFilePath(export_node)

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
		format "\n"; print "PrintExporter_v._openExportedFiles()"
		format "this.exported_paths	= % \n" this.exported_paths
		if this.exported_paths.count > 0 then
			case this.params[#open_in] of
			(
				1: this._openInChitubox()
				2: this._openInLycheeSlicer()
			)
	),

	/** Open in chitubox
	  *
	  * FORMAT OF COMMAND TO OPEN FILES IN CHITUBOX:
	  * 		ShellLaunch "C:/Chitubox.exe" "\"c:\\File_1.obj\" \"c:\\File_1.obj\""
	  *
	 */
	function _openInChitubox =
	(
		--format "\n"; print "PrintExporter_v._openInChitubox()"
		--format "this.params[#OPEN_IN_FINAL_FILE]	= % \n" this.params[#OPEN_IN_FINAL_FILE]
		files_paths = ""

		this._setFinalFile()

		for exported_path in this.exported_paths where doesFileExist exported_path do files_paths += " \""+exported_path+"\""
		--format "this.open_in_programs	= % \n" this.open_in_programs
		ShellLaunch 	("\""+ this.open_in_programs[1]+"\"") ( files_paths )
	),

	/** Get path to final file where exported files will be merged
	  *
	  *  Name of merge is parent group of nodes
	  *  Path of merge is export path of first selected node
	  *
	  */
	function _setFinalFile =
	(

		if this.params[#OPEN_IN_FINAL_FILE] then
		(
			node_groups = makeUniqueArray( for _node in this.export_nodes where _node.parent != undefined and isGroupHead _node.parent collect _node.parent)

			if node_groups.count > 0 then
			(
				final_file = (this._getExportDir(this.export_nodes[1].export_dir)) + "\\" + node_groups[1].name + ".chitubox"

				if not doesFileExist final_file then
				(
					template_file = ( getFilenamePath(getSourceFileName()) + "..\\..\\Final-Files-Templates\\template.chitubox" )
					--format "template_file	= % \n" template_file
					copy_result = copyFile  template_file final_file -- COPY EMPTY FILE "./../../Final-Files-Templates/template.chitubox"
					--format "copy_result	= % \n" copy_result
				)


				this.exported_paths = #( final_file ) + this.exported_paths

			)
		)
	),

	/** Open in LycheeSlicer
	 */
	function _openInLycheeSlicer =
	(
		--format "\n"; print "PrintExporter_v._openInChitubox()"
	),

	/** Set exporter
	 */
	function _setExporter =
	(
		--format "\n"; print "PrintExporter_v._setExporter()"
		Exporter = ObjExporter_v(#Print)

		Exporter.setIni("ObjScale")(this.params[#export_scale])

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

		anim_key_values = for data_pair in anim_keys where data_pair.value != 0 collect data_pair.value

		if anim_key_values.count > 0 then
			this._setTimeSlider(amax anim_key_values)
	),

	/** create boxes in corners of print plane to keep exported position
	 */
	function _fixExportPosition =
	(
		--format "\n"; print "PrintExporter_v._fixExportPosition()"
		this.export_position_dummy = if this.params[#fix_position] or this.anim_keys[#position] > 0 then
			(PrinterVolume_v()).volumeDimensionObject(this.params[#export_scale])
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



	/** Get export file path
	 */
	function _getExportFilePath export_node =
	(
		--format "\n"; print "ExporterSetup_v._getExportFilePath()"
		subdir = if this.params[#subdir_by_node] then "/"+export_node.name + "/" else "/"

		export_path =  (this._getExportDir(export_node.export_dir)) + subdir + export_node.name + ".obj"

		( dotNetObject "System.Text.RegularExpressions.Regex" @"[\\/]+" ).Replace export_path "\\\\" -- return
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

	--/** Delete position dummy
	-- */
	--function _deletePositionDummy =
	--(
	--	--format "\n"; print "PrintExporter_v._deletePositionDummy()"
	--		if isValidNode this.export_position_dummy then
	--			delete this.export_position_dummy
	--),

	/**
	 */
	on create do
	(
		format "\n"; print "PrintExporter.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
