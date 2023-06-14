/** Export objects to *.obj file
  *
  * @property name preset #obj|#print|#zbrush|#unreal
  */
struct ExporterOBJ_v
(
	/* construct */
	preset,

	/* properties */
	Exporter = exporterPlugin.classes[findItem exporterPlugin.classes ObjExp],

	ini_file_path,

	/* dependency */
	/* reference */
	/* inhered */

	/**  Export
	  *
	  * @param array export_objects
	  * @param string export_filepath
	  *
	  * @return boolean
	 */
	function export export_objects export_filepath =
	(
		format "\n"; print "ExporterOBJ_v.export()"
		--format "export_objects	= % \n" export_objects
		--format "export_filepath	= % \n" export_filepath

		makeDir (getFilenamePath( export_filepath)) all:true

		select export_objects

		try(

			export_result = exportFile ( export_filepath ) #noPrompt selectedOnly:true using:this.Exporter -- return
			format "export_result	= % \n" export_result

		)catch(

			format "*** % ***\n" (getCurrentException())

			return false
		)

	),

	/** Set export scale
	 */
	function setExportScale val =
	(
		--format "\n"; print "ExporterOBJ_v.setExportScale()"
		this.setIni("ObjScale")(val)
	),

	/** Set ini
	 */
	function setIni key val =
	(
		--format "\n"; print "ExporterOBJ_v._setIni()"
		--format "key	= % \n" key
		for section in getINISetting this.ini_file_path do
			for _key in getINISetting this.ini_file_path section where key == _key do
				 setINISetting this.ini_file_path section key (val as string )
	),


	private

	/** Copy preset file
	 */
	function _copyPresetFile =
	(
		--format "\n"; print "ExporterOBJ_v._copyPresetFile()"

		ini_file_path	= Exporter.getIniName()

		ini_preset_path = getDir (#userscripts) + @"\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-EXPORT\Lib\ExporterOBJ\Presets\\" +preset as string + ".ini"
		--format "ini_file_path	= % \n" ini_file_path
		--format "Exporter.getIniName()	= % \n" (Exporter.getIniName())
		--format "ini_preset_path	= % \n" ini_preset_path
		--format "doesFileExist ini_preset_path	= % \n" (doesFileExist ini_preset_path)

		if doesFileExist ini_preset_path then
		(
			deleteFile ini_file_path

			copyFile ini_preset_path ini_file_path
		)
		else
			messageBox ("Missing preset file\n\n`"+ini_preset_path+"\n\nFile is used in ExporterOBJ_v._copyPresetFile()") title:"Missing preset file"  beep:false

	),

	/**
	 */
	on create do
	(
		format "\n"; print "ExporterOBJ.onCreate()"

		this._copyPresetFile()
	)

)
