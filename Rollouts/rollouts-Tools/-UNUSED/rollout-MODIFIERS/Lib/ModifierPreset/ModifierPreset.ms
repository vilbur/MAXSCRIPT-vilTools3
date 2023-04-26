filein( getFilenamePath(getSourceFileName()) + "/addModifierOrLoadPreset.ms" )
filein( getFilenamePath(getSourceFileName()) + "/managePresetMenu.ms" )

/** Modifier
  * 
  * @property	_modifier|name	_modifier	_modifier or class of _modifier E.g.: #chamfer
  * 
  * https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_DB496ACA_1506_4FB1_B8F8_EECC7D9794DD_htm  
 */
struct ModifierPreset_v
(
	_modifier,


	ini,


	/** Set current _modifier
	 */
	function getCurrent =
	(
		max modify mode

		_modifier = modPanel.getCurrentObject()
	),

	/** Save preset
	  * 
	  * @param	array	props	mask of property names will be saved
	 */
	function savePreset props: =
	(
		--format "\n"; print "ModifierPreset_v.savePreset()"
		--format "_modifier	= % \n" _modifier
		this._setIniPath()

		this.deletePreset()
	
		if props == unsupplied then
			props = getPropNames _modifier
		
		for prop in getPropNames _modifier do
		(
			value	= getProperty _modifier prop
			--format "% = % \n" prop value

			setINISetting ini _modifier.name ( prop as string ) ( value as string )
		)
	),

	/** Load preset
	 */
	function loadPreset preset_name =
	(
		--format "\n"; print "ModifierPreset_v.loadPreset()"

		current_modifier	= modPanel.getCurrentObject()

		if not ( this._iniFileExists() ) or classOf _modifier != classOf current_modifier then
			return false
		
		for prop in getPropNames _modifier do
		(
			--format "prop	= % \n" prop
			--prop = substituteString prop "cbx_" "" -- remove "cbx_" prefix
			
			value	= getINISetting ini preset_name ( prop as string )
			
			--format "value	= % \n" value
			
			--format "ModifierPreset_v.loadPreset() % = % \n" prop value
			if value != "" then
			(
				value_formatted = this._formatDatatypeValue value
		
				--if( value_formatted != "undefined" ) then
				try
				(
					setProperty current_modifier prop ( this._formatDatatypeValue value )
				)catch()

			)
		)
		current_modifier.name = preset_name
		
	),

	/** Delete preset
	 */
	function deletePreset =
	(
		--format "\n"; print "ModifierPreset_v.deletePreset()";
		--this._setIniPath()

		delINISetting ini _modifier.name
	),
	
	/** Save preset dialog
	 */
	function savePresetDialog =
	(
		--format "\n"; print "ModifierPreset_v._savePresetDialog()"
		--_modifier = modPanel.getCurrentObject()
			
		if superClassOf _modifier == modifier then
		(
			/* DIALOG */
			dialog_id = "dialog_" + (classOf _modifier) as string + "_preset"
	
			Dialog 	    = Dialog_v title:("Save "+ (classOf _modifier) as string  +" preset") id:dialog_id ini:(getSourceFileName() + "/../save-modifier-property.ini")
			--Dialog 	    = Dialog_v title:("Save "+ (classOf _modifier) as string  +" preset") id:dialog_id
			
			_Controls	= Dialog.Controls()
			_Controls_props	= Dialog.Controls group:"Properties saved in preset"
			_Controls_save	= Dialog.Controls()
			
			CheckAllCheckbox = _Controls.control #checkbox "Check\Uncheck all" across:1
			
			CheckAllCheckbox.Events.add #changed ("for control in "+dialog_id+".controls do try( control.state = val )catch()")
			
			for prop in getPropNames _modifier do
				_Controls_props.control #checkbox ( prop as string ) id:(("cbx_"+prop as string )as name ) across:1
			
			SaveButton =  _Controls_save.control #button "Save Preset" width:128 height:64 across:1
			
			SaveButton.Events.add #pressed ("(ModifierPreset_v("+ (classOf _modifier) as string  +")).savePreset props:(for ctrl in "+dialog_id+".controls collect try(if ctrl.state then ctrl.name as name )catch()); DestroyDialog "+dialog_id+"")
			
			/* DIALOG CREATE */ 
			Dialog.create width:256 pos:#mouse
		)
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

	/** Get objects with instance of given _modifier
	  *
	  * @property	array	_objects	where to serch for instance of _modifier
	  * @property	_modifier	_modifier	for search
	  *
	  * @return	array	
	 */
	function getObjectsWithInstance _objects =
	(
		objects_with_instance	= #()

		if( refhierarchy.isRefTargetInstanced _modifier ) then 
			objects_with_instance = for obj in _objects where ( (Modifiers.search obj _modifier).count > 0 ) collect obj

		objects_with_instance --return
	),

	/** Get preests
	 */
	function getPresets =
	(
		--this._setIniPath()
		--format "ini	= % \n" ini
		getINISetting ini --return
	),

	/** Open ini
	 */
	function openIni =
	(
		--format "\n"; print "ModifierPreset_v.openIni()"
		--this._setIniPath()

		if this._iniFileExists() then
			DOSCommand ("start \"\" \""+ini+"\"")
	),
	
	private


	/** Set ini path
	 */
	function _setIniPath =
	(
		--format "\n"; print "ModifierPreset_v._setIniPath()"
		--format "_modifier	= % \n" _modifier
		--format "classOf _modifier	= % \n" (classOf _modifier)

		ini = (getFilenamePath(getSourceFileName())) + "\\ini_files\\"+( classOf _modifier ) as string +".ini"
		--format "ini = % \n" ini
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
	--	_modifier.name = name
	--),

	on create do
	(
		--format "\n"; print "ModifierPreset_v.create()"
		--format "classOf _modifier A = % \n" (classOf _modifier)
		--format "_modifier	= % \n" _modifier


		if _modifier != undefined and superClassOf _modifier != modifier then
			_modifier = modPanel.getCurrentObject()

		
		this._setIniPath()

		--format "_modifier	= % \n" _modifier
	)
)