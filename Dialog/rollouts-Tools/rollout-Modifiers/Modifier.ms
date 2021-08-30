filein( getFilenamePath(getSourceFileName()) + "/Modifiers/Modifiers.ms" )

/** Modifier
https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_DB496ACA_1506_4FB1_B8F8_EECC7D9794DD_htm  
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
		
		modifier = modPanel.getCurrentObject() --return
		
		type = classOf modifier
	),
	
	/** Save preset
	 */
	function savePreset =
	(
		_props_names	= getPropNames modifier
		
		--getProperty <obj> <property_name>
		--setProperty <obj> <property_name> <value>
		this.setIniPath()
		
		format "classOf modifier = % \n" (classOf modifier)
		
		
		for prop in _props_names do
		(
			value	= getProperty modifier prop
			format "% = % \n" prop value
			
			setINISetting ini modifier.name ( prop as string ) ( value as string )

		)
		
	),
	
	/** Load preset
	 */
	function loadPreset =
	(
		
		
		_props_names	= getPropNames modifier
		
		--getProperty <obj> <property_name>
		--setProperty <obj> <property_name> <value>
		this.setIniPath()

		
		if( this._iniFileExists() ) then 
			for prop in _props_names do
			(
				
				value	= getINISetting ini modifier.name ( prop as string )
	
				format "Modifier_v.loadPreset() % = % \n" prop value
				
				value_formatted = this._formatDatatypeValue value
				
				if( value_formatted != "undefined" ) then
				try
				(
					
					setProperty modifier prop ( this._formatDatatypeValue value )
				)
				catch
				(
					format "\n************ EXCEPTION ************\n%\n***********************************\n" (getCurrentException())
					format "\n**************** EXCEPTION File: % ****************\n\n%\n\n**************************************************************************************************************************************\n" filein_path (getCurrentException())
				)
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
	function setIniPath =
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
	
	--/** _get name
	-- */
	--function _setName =
	--(
	--	modifier.name = name
	--),

	on create do
	(
	
	)
)



