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
	params	= Dictionary #( #export_scale, 1 ) #( #open_in, 0 ) #( #subdir_by_node, false ),

	open_in_programs = #("C:/Program Files/CHITUBOX  V1.9.4/CHITUBOX.exe", "C:/Program Files/LycheeSlicer/LycheeSlicer.exe"), -- index same as radiobuttons ROLLOUT_3d_print.RB_open_in_program

	exported_paths = #(),

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

		this._setExportKeyFrame()

		for selected_node in this.export_nodes do
			this._exportNode (selected_node)

		this._openExportedFiles()
	),


	private


	/*------------------------------------------------------------------------------
		EXPORT NODE
	--------------------------------------------------------------------------------*/
	function _exportNode export_node =
	(
		--format "\n"; print "PrintExporter_v._exportNode()"
		export_path	= this._getExportFilePath(export_node)

		export_result = Exporter.export (export_node.getAllChildren()) (export_path)

		if export_result != false then
			append exported_paths export_path
	),

	/** Open exported files
	 */
	function _openExportedFiles =
	(
		--format "\n"; print "PrintExporter_v._openExportedFiles()"
		if exported_paths.count > 0 then
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
		format "\n"; print "PrintExporter_v._openInChitubox()"

		files_paths = this._getMergInFile ()

		for exported_path in this.exported_paths where doesFileExist exported_path do files_paths += " \""+exported_path+"\""

		ShellLaunch 	("\""+ this.open_in_programs[1]+"\"") ( files_paths )
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


	/** Set export key frame
	 */
	function _setExportKeyFrame =
	(
		--format "\n"; print "PrintExporter_v._setExportKeyFrame()"

		--/* SET EXPORT KEYFRAME */
		--if ( rotation_key = _getLastKeyOfAnimation(this.export_nodes)(#rotation) ) > 0 then
		--	this._setTimeSlider (rotation_key)
		--
		--/* CREATE BOXES TO CORNERS OF PRINT PLANE  TO KEEP EXPORTED POSITION */
		--export_position_dummy = if ( rotation_key = _getLastKeyOfAnimation(this.export_nodes)(#position) ) > 0 then
		--	(PrinterVolume_v()).volumeDimensionObject(ROLLOUT_export.SPIN_export_size.value) else #()



	),

	/** Get path to final file where exported files will be merged
	  *
	  *  Name of merge is parent group of nodes
	  *  Path of merge is export path of first selected node
	  *
	  */
	function _getMergInFile =
	(
		node_groups = makeUniqueArray( for _node in this.export_nodes where _node.parent != undefined and isGroupHead _node.parent collect _node.parent)

		if node_groups.count > 0 then
			"\"" + this.export_nodes[1].export_dir + "\\" + node_groups[1].name + ".chitubox" + "\" "  --return
		else
			""  --return
	),

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


	/**
	 */
	on create do
	(
		format "\n"; print "PrintExporter.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
