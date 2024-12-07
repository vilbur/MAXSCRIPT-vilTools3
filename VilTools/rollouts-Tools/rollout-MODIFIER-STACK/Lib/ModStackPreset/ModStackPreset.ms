filein( getFilenamePath(getSourceFileName()) + "/../managePresetMenu/managePresetMenu.ms" ) -- "./../managePresetMenu/managePresetMenu.ms"

filein( getFilenamePath(getSourceFileName()) + "/../ModifierPresetMenuCreator/ModifierPresetMenuCreator.ms" )	-- "./../ModifierPresetMenuCreator/ModifierPresetMenuCreator.ms"

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

	/* dependency */
	ModifierPresetMenuCreator = ModifierPresetMenuCreator_v(),

	/** Test if modObject has default values
	  *
	  * Comnpare props values with default mod
	 */
	function modIsAddedNew obj =
	(
		 format "\n"; print "ModStackPreset_v.modIsAddedNew()"
		-- format "superClassOf modObject:	% \n" ( superClassOf modObject )
		added_new = true

		if obj != undefined and superClassOf modObject == modifier then
		(
			/* MODIFIER MOVED ON OBJECT */
			if (for _mod in obj.modifiers where getHandleByAnim _mod == getHandleByAnim modObject collect _mod)[1] != undefined  then
				added_new = false

			/* MODIFIER INSTANCED */
			else if ( refs.dependentNodes modObject ).count != 0 then
				added_new = false

			/* MODIFIER COPIED */
			else
			(
				modifier_values =  this._getModValues(modObject)

				for modifier_in_scene in ( getClassInstances ( classOf modObject )) where modifier_in_scene.name == modObject.name do
					if (with printAllElements on modifier_values ) as string == (with printAllElements on ( this._getModValues(modifier_in_scene))) as string  then
						added_new = false
			)
		)

		format "added_new:	% \n" added_new
		added_new --return
	),

	/** Save preset
	  *
	  * @param	array	properties	names of mod to save
	 */
	function savePreset properties: =
	(
		--format "\n"; print "ModStackPreset_v.savePreset()"
		--format "properties	= % \n" properties
		this._setIniPath()

		this.deletePreset()

		if properties == unsupplied then
			properties = getPropNames modObject

		for prop in getPropNames modObject where findItem properties prop > 0 do
		(
			if ( val = getProperty modObject prop ) != undefined then
			(
				classof_val = superClassOf val
				--format "val:	% \n" val
				--format "classof_val:	% \n" classof_val
				if classof_val == Number or classof_val == value then
					setINISetting ini preset_name ( prop as string ) ( val as string )
			)
		)

		ModifierPresetMenuCreator.createMenu(ini)

		format "\nMODIFIER PRESET	% HAS BEEN SAVED\n" preset_name
	),

	/** Load preset
	 */
	function loadPreset preset:undefined rename:true =
	(
		format "\n"; print "ModStackPreset_v.loadPreset()"
		--format "preset_name	= % \n" preset_name

		preset_name_load = if preset != undefined then preset else this.preset_name
		format "preset_name_load: %\n" preset_name_load
		for data_pair in  this._getPresetValues(preset_name_load) do
		(
			format "%\:%\n" data_pair.key data_pair.value
			setProperty modObject data_pair.key data_pair.value
		)

		format "\nMODIFIER PRESET	\"%\" HAS BEEN LOADED\n" preset_name_load
		--(this.getPresetName()) = preset_name
		if rename then
			this.modObject.name = preset_name_load
	),


	/** Delete preset
	 */
	function deletePreset =
	(
		--format "\n"; print "ModStackPreset_v.deletePreset()";
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

		SaveButton.Event #pressed ("(ModStackPreset_v("+ modObject as string  +")).savePreset props:(for ctrl in "+dialog_id+".controls collect try(if ctrl.state then (trimLeft ctrl.name \"cbx_\") as name )catch()); DestroyDialog "+dialog_id+"")

		/* DIALOG CREATE */
		Dialog.create width:256 height:#auto pos:#mouse
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
	function hasPreset =
	(
		format "\n"; print "ModStackPreset_v.hasPreset()"
		format "PRESET: \"%\"\n" this.preset_name
		format "INI FILE: %\n" (this._iniFileExists())
		format "HAS PRESET: %\n" (hasINISetting ini this.preset_name)
		
		( this._iniFileExists() ) and hasINISetting ini this.preset_name  --return
	),
	
	/** Save default preset
	 */
	function saveDefaultPreset =
	(
		--format "\n"; print "ModStackPreset_v.saveDefaultPreset()"
		
		default_mod = execute ((classOf this.modObject) as string + "()")
		
		ModStackPresetDefault = ModStackPreset_v( default_mod )

		ModStackPresetDefault.savePreset()
	),
	
	
	private

	
	/** Test if modObject has default values
	  *
	  * Comnpare props values with default mod
	 */
	function _getModValues _mod =
	(
		--format "\n"; print "ModStackPreset_v._getModValues()"
		for prop in getPropNames _mod collect (getProperty _mod prop)
	),

	/** Get mod name
	  *
	  *  @return string modier name or class of object E.G.: Edit_Poly|Sphere
	 */
	function _getPresetName =
	(
		--format "\n"; print "ModStackPreset_v.getModName()"
		( if superClassOf modObject == modifier then modObject.name else classOf modObject ) as string
	),
	
	/** Get preset values
	  *
	  */
	function _getPresetValues preset_name_load =
	(
		format "\n"; print "ModStackPreset_v._getPresetValues()"

		preset_values	= Dictionary()
		format "ini: %\n" ini
		format "preset_name_load: %\n" preset_name_load
		format "keys: %\n" (getINISetting ini preset_name_load)
		
		for key in getINISetting ini preset_name_load do
			preset_values[key as name ] = this._formatDatatypeValue ( getINISetting ini preset_name_load key )
		
		--for prop in getPropNames modObject do
		--(
		--	val	= getINISetting ini preset_name_load ( prop as string )
		--	--format "\n"
		--	--format "val:	% \n" val
		--	--format "classof val:	% \n" (classof (execute val))
		--
		--	if val != "" then
		--		preset_values[prop] = execute val
		--)

		--format "\n-----------\nDICTIONARY:preset_values:%\n" preset_values; for data_pair in preset_values do format "%:	%\n" data_pair.key data_pair.value
		format "preset_values: %\n" preset_values
		preset_values --return
	),


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
	
	/** Set mod object
	 */
	function _setModObject =
	(
		format "\n"; print "ModStackPreset_v._setModObject()"
		format "classOf modObject	= % \n" ( superClassOf modObject)
		format "test: %\n" (classOf modObject != modifier)
	
		if superClassOf modObject != modifier then
			if classOf ( currMod = ( modPanel.getCurrentObject() ) ) == modObject then
				modObject = currMod
				--modObject =  modPanel.getCurrentObject()
	),

	on create do
	(
		format "\n"; print "ModStackPreset_v.create()"

		this._setModObject()
		--format "modObject	= % \n" modObject
		--format "classOf modObject	= % \n" ( classOf modObject)
		--format "superClassOf modObject	= % \n" ( superClassOf modObject)
		--if classOf modObject == string then
		--	modObject = execute modObject

		preset_name = this._getPresetName()

		this._setIniPath()
	)
)