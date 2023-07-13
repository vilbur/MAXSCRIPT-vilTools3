filein( getFilenamePath(getSourceFileName()) + "/../../../../../CallBacks/nodeCreated/managePresetMenu.ms" )	-- "./../../../../../CallBacks/nodeCreated/managePresetMenu.ms"

/** Manage Modifier presets
  *
  * Ini file location: "C:\Users\{username}\AppData\Local\Autodesk\3dsMax\{max version} - 64bit\ENU\temp\ni_files"
  *
  * @construct: ModStackPreset_v(modifier_class) E.G.: ModStackPreset_v(MeshSmooth)
  *
  * @method .getPresets() get all prrsets of modifier class from ini
  *
  * @property	modObject|name	modObject	modObject or class of modObject E.g.: #chamfer
  *
  * https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_DB496ACA_1506_4FB1_B8F8_EECC7D9794DD_htm
 */
struct ModStackPreset_v
(
	/* CONTRUCT */
	modObject,

	ini,

	/** Set current modObject
	 */
	function getCurrent =
	(
		max modify mode

		modObject = modPanel.getCurrentObject()
	),

	/** Save preset
	  *
	  * @param	array	props	mask of property names will be saved
	 */
	function savePreset props: =
	(
		format "\n"; print "ModStackPreset_v.savePreset()"
		--format "props	= % \n" props

		this._setIniPath()

		this.deletePreset()

		if props == unsupplied then
			props = getPropNames modObject

		for prop in getPropNames modObject where findItem props prop > 0 do
			setINISetting ini (this.getPresetName()) ( prop as string ) ( (getProperty modObject prop) as string )
	),

	/** Load preset
	 */
	function loadPreset preset_name =
	(
		--format "\n"; print "ModStackPreset_v.loadPreset()"
		--format "preset_name	= % \n" preset_name

		if not ( this._iniFileExists() )  then
			return false

		for prop in getPropNames modObject do
		(
			val	= getINISetting ini preset_name ( prop as string )

			format "ModStackPreset_v.loadPreset() % = % \n" prop val

			if val != "" then
			(
				value_formatted = this._formatDatatypeValue val

				--if( value_formatted != "undefined" ) then
				try
				(
					setProperty modObject prop ( this._formatDatatypeValue val )
				)
				catch(format "!!!!! ERROR IN TRY %\n\n" (getCurrentException()))
			)

			format "MODIFIER PRESET	% HAS BEEN LOADED" preset_name
		)

		--(this.getPresetName()) = preset_name

	),

	/** Delete preset
	 */
	function deletePreset =
	(
		--format "\n"; print "ModStackPreset_v.deletePreset()";
		--this._setIniPath()

		delINISetting ini (this.getPresetName())
	),

	/** Save preset dialog
	 */
	function savePresetDialog =
	(
		--format "\n"; print "ModStackPreset_v._savePresetDialog()"
		--modObject = modPanel.getCurrentObject()

		if superClassOf modObject == modifier then
		(
			/* DIALOG */
			dialog_id = "dialog_" + (classOf modObject) as string + "_preset"

			Dialog 	    = Dialog_v title:("Save "+ (classOf modObject) as string  +" preset") id:dialog_id ini:(getSourceFileName() + "/../save-modifier-property.ini")
			--Dialog 	    = Dialog_v title:("Save "+ (classOf modObject) as string  +" preset") id:dialog_id

			_Controls	= Dialog.Controls()
			_Controls_props	= Dialog.Controls group:"Properties saved in preset"
			_Controls_save	= Dialog.Controls()

			CheckAllCheckbox = _Controls.control #checkbox "Check\Uncheck all" across:1

			CheckAllCheckbox.Events.add #changed ("for control in "+dialog_id+".controls do try( control.state = val )catch()")

			for prop in getPropNames modObject do
				_Controls_props.control #checkbox ( prop as string ) id:(("cbx_"+prop as string )as name ) across:1

			SaveButton =  _Controls_save.control #button "Save Preset" width:128 height:64 across:1

			SaveButton.Events.add #pressed ("(ModStackPreset_v("+ (classOf modObject) as string  +")).savePreset props:(for ctrl in "+dialog_id+".controls collect try(if ctrl.state then (trimLeft ctrl.name \"cbx_\") as name )catch()); DestroyDialog "+dialog_id+"")

			/* DIALOG CREATE */
			Dialog.create width:256 pos:#mouse
		)
	),

	/** Get objects with instance of given modObject
	  *
	  * @property	array	_objects	where to serch for instance of modObject
	  * @property	modObject	modObject	for search
	  *
	  * @return	array
	 */
	function getObjectsWithInstance _objects =
	(
		objects_with_instance	= #()

		if( refhierarchy.isRefTargetInstanced modObject ) then
			objects_with_instance = for obj in _objects where ( (Modifiers.search obj modObject).count > 0 ) collect obj

		objects_with_instance --return
	),

	/** Get prests in ini file
	 */
	function getPresets =
	(
		--this._setIniPath()
		--format "ini	= % \n" ini
		getINISetting ini --return
	),

	/** Test if modifier has preset
	 */
	function hasPreset preset_name =
	(
		--format "\n"; print "ModStackPreset_v.hasPreset()"
		( this._iniFileExists() ) and hasINISetting ini preset_name  --return
	),

	/** Open ini
	 */
	function openIni =
	(
		--format "\n"; print "ModStackPreset_v.openIni()"
		--this._setIniPath()

		if this._iniFileExists() then
			DOSCommand ("start \"\" \""+ini+"\"")
	),

	/** Get mod name
	  *
	  *  @return string modier name or class of object E.G.: Edit_Poly|Sphere
	 */
	function getPresetName =
	(
		--format "\n"; print "ModStackPreset_v.getModName()"
		--format "modObject == modifier	= % \n" (modObject == modifier)
		--format "classOf modObject	= % \n" (classOf modObject)

		( if classOf modObject == modifier then modObject.name else classOf modObject ) as string
	),


	private

	/** Format datatype of value
	  *
	  * return mixin true|false|number|string
	 */
	function _formatDatatypeValue value =
	(
		if( matchPattern value pattern:"true" or matchPattern value pattern:"false"  ) then
			if( matchPattern value pattern:"true" ) then true else false  --return true|false

		else if( value as number != undefined ) then
			 value as number --return number

		else
			value --return string
	),

	/** Set ini path
	 */
	function _setIniPath =
	(
		--format "\n"; print "ModStackPreset_v._setIniPath()"
		--format "modObject	= % \n" modObject
		--format "classOf modObject	= % \n" (classOf modObject)
		ini_dir = getDir (#temp) + "\\ini_files\\modifiers"
		--format "ini_dir	= % \n" ini_dir
		if not ( doesFileExist ini_dir ) then
			makeDir ini_dir all:true

		ini = ini_dir + "\\"+ (this.getPresetName()) +".ini"

	),

	/** Does ini file exists
	 */
	function _iniFileExists =
	(
		(getFiles ini).count != 0
	),

	/** Select only Unique objects.
	  *	Deselect mutliple instances
	  *
	  * @return	array selection
	 */
	function _selectUniqueObjects =
	(
		for obj in selection do
		(
			local obj_instances
			InstanceMgr.GetInstances obj &obj_instances

			if( obj_instances.count > 1 ) then
			(
				deleteItem obj_instances (findItem obj_instances obj)
				deselect obj_instances
			)
		)
	),

	--/** _get name
	-- */
	--function _setName =
	--(
	--	(this.getPresetName()) = name
	--),

	on create do
	(
		format "\n"; print "ModStackPreset_v.create()"
		--if modObject != undefined and superClassOf modObject != modifier then
			--modObject = modPanel.getCurrentObject()

		this._setIniPath()
		format "ini	= % \n" ini
	)
)