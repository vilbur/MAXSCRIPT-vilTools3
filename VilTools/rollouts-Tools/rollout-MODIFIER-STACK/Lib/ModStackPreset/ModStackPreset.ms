filein( getFilenamePath(getSourceFileName()) + "/../managePresetMenu/managePresetMenu.ms" ) -- "./../managePresetMenu/managePresetMenu.ms"

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
	modObject, -- modifier or baseobject

	/* Properties */
	preset_name, -- modifier name or primitive class is used if undefined E.G.: "Poly_Select|Sphere"


	/* ini */
	ini_dir = getDir (#temp) + "\\ini_files\\modifer-stack-presets",

	ini,  --path to ini file, filename is  {classOf modifier|primitiveType}.ini E.G.:  SliceModifier.ini | Sphere.ini

	--blaclist_props = #( Point2 , Point3 ),
	blaclist_props = #( Point2 , Point3 ),

	/** Load preset to mod
	 *
	 */
	function loadDefaults =
	(
		--format "\n"; print "ModStackPreset_v.loadDefaults()"
		--format "modObject	= % \n" modObject
		--format "classOf modObject	= % \n" ( classOf modObject)
		--format "superClassOf modObject	= % \n" ( superClassOf modObject)

		/** Test if modifier has default values
		 *
		 */
		function modifierHasDefaultValues modObject =
		(
			--format "\n"; print "ModStackPreset_v.modifierHasDefaultValues()"
			modObject_default = execute( (classOf modObject) as string + "()" )

			values_current =  for prop in getPropNames modObject collect (getProperty modObject prop)

			values_default = for prop in getPropNames modObject_default collect (getProperty modObject_default prop)

			(with printAllElements on values_current ) as string == (with printAllElements on values_default) as string  --return
		)

		if this.hasPreset( preset_name ) and ( isCreatingObject() or modifierHasDefaultValues ( modObject )) then
			this.loadPreset( preset_name )
	),


	--/** Set current modObject
	-- */
	--function getCurrent =
	--(
	--	max modify mode
	--
	--	modObject = modPanel.getCurrentObject()
	--),

	/** Save preset
	  *
	  * @param	array	props	mask of property names will be saved
	 */
	function savePreset props: =
	(
		--format "\n"; print "ModStackPreset_v.savePreset()"
		--format "props	= % \n" props
		this._setIniPath()

		this.deletePreset()

		if props == unsupplied then
			props = getPropNames modObject

		for prop in getPropNames modObject where findItem props prop > 0 do
			setINISetting ini preset_name ( prop as string ) ( (getProperty modObject prop) as string )

		format "\nMODIFIER PRESET	% HAS BEEN SAVED\n" preset_name
	),

	/** Load preset
	 */
	function loadPreset preset_name =
	(
		--format "\n"; print "ModStackPreset_v.loadPreset()"
		--format "preset_name	= % \n" preset_name

		if not ( this._iniFileExists() )  then
			return false

		--format "\n"; print "ModStackPreset_v.loadPreset()"
		--for prop in getPropNames modObject where findItem this.blaclist_props (classOf value_formatted) == 0 do
		for prop in getPropNames modObject do
		(
			val	= getINISetting ini preset_name ( prop as string )

			--format "prop:	% \nval:	% \n\n" prop val

			if val != "" then
				try
				(
					--setProperty modObject prop ( this._formatDatatypeValue val )
					setProperty modObject prop ( execute val)
				)
				catch(format "!!!!! ERROR IN TRY %\n\n" (getCurrentException()))
		)

		format "\nMODIFIER PRESET	% HAS BEEN LOADED\n" preset_name
		--(this.getPresetName()) = preset_name

	),

	/** Delete preset
	 */
	function deletePreset =
	(
		--format "\n"; print "ModStackPreset_v.deletePreset()";
		--this._setIniPath()

		delINISetting ini preset_name
	),

	/** Save preset dialog
	 */
	function savePresetDialog =
	(
		--format "\n"; print "ModStackPreset_v._savePresetDialog()"

		dialog_id	= "dialog_" + modObject as string + "_preset"
		title 	= "Save "+ modObject as string  +" Preset"

		Dialog 	    = Dialog_v title:(title) id:dialog_id ini:(getDir #temp + "/ini_files/Modifier-preset-dialog/"+title+".ini")

		_Controls_props	= Dialog.Controls group:"Properties saved in preset"
		_Controls_save	= Dialog.Controls()

		/* CHECKBOX FOR EACH PROPERTY */
		for prop in getPropNames modObject do
			_Controls_props.control #checkbox ( prop as string ) id:(("cbx_"+prop as string )as name ) across:1

		SaveButton =  _Controls_save.control #button "Save Preset" width:128 height:64 across:1

		SaveButton.Events.add #pressed ("(ModStackPreset_v("+ modObject as string  +")).savePreset props:(for ctrl in "+dialog_id+".controls collect try(if ctrl.state then (trimLeft ctrl.name \"cbx_\") as name )catch()); DestroyDialog "+dialog_id+"")

		/* DIALOG CREATE */
		Dialog.create width:256 height:#auto pos:#mouse

		----)
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

	--/** Open ini
	-- */
	--function openIni =
	--(
	--	format "\n"; print "ModStackPreset_v.openIni()"
	--	format "ini	= % \n" ini
	--	--this._setIniPath()
	--
	--	if this._iniFileExists() then
	--		DOSCommand ("start \"\" \""+ini+"\"")
	--),

	/** Get mod name
	  *
	  *  @return string modier name or class of object E.G.: Edit_Poly|Sphere
	 */
	function _getPresetName =
	(
		--format "\n"; print "ModStackPreset_v.getModName()"
		( if superClassOf modObject == modifier then modObject.name else classOf modObject ) as string
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
		if not ( doesFileExist ini_dir ) then
			makeDir ini_dir all:true

		ini = ini_dir + "\\"+ (classOf modObject) as string +".ini"
	),

	/** Does ini file exists
	 */
	function _iniFileExists =
	(
		(getFiles ini).count != 0
	),

	on create do
	(
		format "\n"; print "ModStackPreset_v.create()"

		format "modObject	= % \n" modObject
		format "classOf modObject	= % \n" ( classOf modObject)
		format "superClassOf modObject	= % \n" ( superClassOf modObject)
		--if classOf modObject == string then
		--	modObject = execute modObject


		preset_name = this._getPresetName()

		this._setIniPath()
	)
)