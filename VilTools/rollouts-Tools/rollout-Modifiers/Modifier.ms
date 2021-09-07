filein( getFilenamePath(getSourceFileName()) + "/Lib/Modifiers/Modifiers.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../rollout-Selection/Selection.ms" )

/** Modifier
  *
  * https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_DB496ACA_1506_4FB1_B8F8_EECC7D9794DD_htm  
 */
struct Modifier_v
(
	name,
	type,
	
	Modifiers	= Modifiers_v(),
	
	modifier,
	
	ini,
	
	/** Get
	 */
	function add =
	(
		type = type as string

		(Selection_v()).filterUniqueObjects()
		
		this._setModifier()
		
		--this._setName()
		
		modPanel.addModToSelection modifier ui:on
		
		modifier --return
	),
	
	/** Set current modifier
	 */
	function setCurrent =
	(
		max modify mode
		
		modifier = modPanel.getCurrentObject()
		
		type = classOf modifier
		
		this --return
	),
	
	
	
	/** Save preset
	 */
	function savePreset =
	(
		this._setupPresetSaveLoad()
		
		for prop in getPropNames modifier do
		(
			value	= getProperty modifier prop
			format "% = % \n" prop value
			
			setINISetting ini modifier.name ( prop as string ) ( value as string )

		)
		
		this --return
	),

	
	/** Load preset
	 */
	function loadPreset =
	(
		this._setupPresetSaveLoad()
		
		if( this._iniFileExists() ) then 
			for prop in getPropNames modifier do
			(
				value	= getINISetting ini modifier.name ( prop as string )
				--format "Modifier_v.loadPreset() % = % \n" prop value
				
				value_formatted = this._formatDatatypeValue value
				
				--if( value_formatted != "undefined" ) then
				try
				(
					setProperty modifier prop ( this._formatDatatypeValue value )
				)
				catch
				()
			)
		this --return
	),
	
	/** _setup preset save load
	 */
	function _setupPresetSaveLoad =
	(
		if( modifier == undefined ) then
			this.setCurrent()

		this._setIniPath()
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
	
	/** Get objects with instance of given modifier
	  *
	  * @property	array	_objects	where to serch for instance of modifier
	  * @property	modifier	modifier	for search
	  *
	  * @return	array	
	 */
	function getObjectsWithInstance _objects =
	(
		objects_with_instance	= #()
		
		if( refhierarchy.isRefTargetInstanced modifier ) then 
			objects_with_instance = for obj in _objects where ( (Modifiers.search obj modifier).count > 0 ) collect obj
		
		objects_with_instance --return
	),
	
	/** _set modifier
	 */
	function _setModifier =
	(
		if( hasProperty Modifiers type ) then
			modifier = getProperty Modifiers type --return 
		else
			modifier = execute (type+"()") --return
	),
	
	/** Set ini path
	 */
	function _setIniPath =
	(
		ini = (getFilenamePath(getSourceFileName())) + "Modifiers\\ModifierTypes\\"+type as string +".ini"
		--format "ini = % \n" ini
	),
	
	/** Does ini file exists
	 */
	function _iniFileExists =
	(
		
		(getFiles ini).count != 0 
	),

	/** Test
	 */
	function test preset =
	(
		messageBox preset beep:false
	),
	
	--/** _get name
	-- */
	--function _setName =
	--(
	--	modifier.name = name
	--),
	/** Get preests
	 */
	function getPresets _rollout =
	(

		this._setupPresetSaveLoad()

		presets	= getINISetting ini
		format "presets = % \n" presets

		/* DEFINE MAIN MENU */
		global Menu_RC = Menu_v name:"Menu_RC_name"
		
		/* DEFINE MENU */
		--menu_1	= Menu_RC.menu "Menu 1"
		
		for preset in presets do
			Menu_RC.item preset ("loadPresetGlobal \""+preset+"\"") id:preset


		/** MENU ITEMS 
		 */
		
		popUpMenu (Menu_RC.create()) rollout:_rollout


		
	),
	on create do
	(
	
	)
)