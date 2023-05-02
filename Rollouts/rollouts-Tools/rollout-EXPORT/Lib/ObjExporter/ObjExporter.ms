/**
  *
  */
struct ObjExporter_v
(
	/* construct */
	preset, --#obj|#print|#zbrush
	--export_dir,


	/* properties */
	Exporter = exporterPlugin.classes[findItem exporterPlugin.classes ObjExp],


	/* dependency */
	/* reference */
	/* inhered */

	/**  Export
	 */
	function export _objects export_path =
	(
		format "\n"; print "ObjExporter_v.export()"
		format "_objects	= % \n" _objects
		format "export_path	= % \n" export_path

		select _objects

		exportFile ( export_path ) #noPrompt selectedOnly:true using:this.Exporter
	),


	private


	/** Setup exporter
	 */
	function _setupExporter =
	(
		format "\n"; print "ObjExporter_v._setupExporter()"
		this._copyPresetFile()

	),

	/** Copy preset file
	 */
	function _copyPresetFile =
	(
		format "\n"; print "ObjExporter_v._copyPresetFile()"

		ini_file_path	= Exporter.getIniName()

		ini_preset_path = getDir (#userscripts) + @"\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-EXPORT\Lib\ObjExporter\Presets\\" +preset as string + ".ini"

		--format "Exporter.getIniName()	= % \n" (Exporter.getIniName())
		--format "ini_preset_path	= % \n" ini_preset_path
		--format "doesFileExist ini_preset_path	= % \n" (doesFileExist ini_preset_path)

		if doesFileExist ini_preset_path then
		(
			deleteFile ini_file_path

			copyFile ini_preset_path ini_file_path
		)
		else
			messageBox ("Missing preset file\n\n`"+ini_preset_path+"\n\nFile is used in ObjExporter_v._copyPresetFile()") title:"Missing preset file"  beep:false

	),

	/**
	 */
	on create do
	(
		format "\n"; print "ObjExporter.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

		this._setupExporter()
	)

)
