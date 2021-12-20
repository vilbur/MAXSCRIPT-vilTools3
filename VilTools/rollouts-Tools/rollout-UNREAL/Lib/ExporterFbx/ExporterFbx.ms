/** Fbx Exporter to Unreal engine
 */
struct ExporterFbx_v
(
	export_node,	-- used node for export
	
	export_dir,
	
	preset_file = getFilenamePath(getSourceFileName()) + "\Presets\Unreal-default.fbxexportpreset",

	/** Setup fbx exporter
	 */
	function loadPreset =
	(
		print "ExporterFbx_v.loadPreset()"
		FBXExporterSetParam "LoadExportPresetFile" preset_file
	),
	
	/** Epxort
	 */
	function epxort nodes =
	(
		print "ExporterFbx_v.epxort()"
		
		if ( doesFileExist export_dir ) then 
			for _node in nodes do 
				this.selectObjectsAndExport (_node)
		else
			messageBox "Directory does not exist." title:"EXPORT FAILED !" beep:true
	),

	/** Select node children
	 */
	function selectObjectsAndExport _node =
	(
		print "ExporterFbx_v.selectObjectsForExport()"
		
		select _node.children
		
		if( _node.children.count > 0 ) then
			exportFile (export_dir+"\\"+_node.name+".fbx") #noPrompt selectedOnly:true using:FBXEXP
	),
	
	private
	
	/** _check export directory
	 */
	function _createExportDirectory =
	(
		print "ExporterFbx_v._createExportDirectory()"
		
		if not( doesFileExist export_dir ) then 
			if queryBox (export_dir+"\n\n Would you like to create directory ?") title:"PATH DOES NOT EXIST !"  beep:true then
				makeDir export_dir
	),
	
	on create do
	(
		this._createExportDirectory()	
	)
)