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
	Importer = importerPlugin.classes[findItem importerPlugin.classes ObjImp],

	ini_file_path,

	/* dependency */
	/* reference */
	/* inhered */
	export_type,

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
		format "\n"; print "ExporterOBJ_v._setIni()"
		--format "key	= % \n" key
		this.ini_file_path = Exporter.getPresetIniName()

		for section in getINISetting this.ini_file_path do
			for _key in getINISetting this.ini_file_path section where key == _key do
				 setINISetting this.ini_file_path section key (val as string )
	),

	/** Set preset file
	 */
	function setPresetFile file_name =
	(
		--format "\n"; print "MaxToZbrushSync_v.setPresetFile()"

		my_preset_dir = getFilenamePath(getSourceFileName()) + "Presets"

		for Imp_or_Exp in #( Exporter, Importer) do
			for target_file in #( Imp_or_Exp.getIniName(), Imp_or_Exp.getPresetIniName() ) do
				--if doesFileExist ( ini_preset_path = my_preset_dir + "\\" + filenameFromPath( target_file ) ) then
				if doesFileExist ( ini_preset_path = my_preset_dir + "\\" + file_name + ".ini" ) then
				(
					deleteFile target_file

					copyFile ini_preset_path target_file
				)
				else
					messageBox ("Missing preset file\n\n`"+ini_preset_path+"\n\nFile is used in ExporterOBJ_v._setPresetFile()") title:"Missing preset file"  beep:false
	),

	private

	/**
	 */
	on create do
	(
		format "\n"; print "ExporterOBJ.onCreate()"

		--this._setPresetFile()
	)

)
