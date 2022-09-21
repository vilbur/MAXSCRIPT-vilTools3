filein( getFilenamePath(getSourceFileName()) + "/Lib/Modifiers/Modifiers.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/../rollout-Selection/Selection.ms" )

/** Modifier
  * 
  * @property	_modifier|name	_modifier	_modifier or class of _modifier E.g.: #chamfer
  * 
  * https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_DB496ACA_1506_4FB1_B8F8_EECC7D9794DD_htm  
 */
struct Modifier_v
(
	--type,
	_modifier,
	--name,

	Modifiers	= Modifiers_v(),

	ini,

	--/** Get
	-- */
	--function add =
	--(
	--	type = type as string
	--
	--	this._selectUniqueObjects()
	--
	--	--this._setModifier()
	--
	--	--this._setName()
	--
	--	modPanel.addModToSelection _modifier ui:on
	--
	--	_modifier --return
	--),

	/** Set current _modifier
	 */
	function getCurrent =
	(
		max modify mode

		_modifier = modPanel.getCurrentObject()

		--type = classOf _modifier		
	),

	/** Save preset
	  * 
	  * @param	array	props	mask of property names will be saved
	 */
	function savePreset props: =
	(
		format "\n"; print "Modifier_v.savePreset()"
		format "_modifier	= % \n" _modifier
		this._setIniPath()

		this.deletePreset(_modifier.name)
	
		if props == unsupplied then
			props = getPropNames _modifier
		
		format "props	= % \n" props
			
		--for prop in getPropNames _modifier where findItem props prop > 0 do
		for prop in getPropNames _modifier do
		(
			value	= getProperty _modifier prop
			format "% = % \n" prop value

			setINISetting ini _modifier.name ( prop as string ) ( value as string )
		)
	),

	/** Load preset
	 */
	function loadPreset preset_name =
	(
		format "\n"; print "Modifier_v.loadPreset()"
		format "preset_name	= % \n" preset_name
		--format "this._iniFileExists()	= % \n" (this._iniFileExists())
		this._setIniPath()
		format "_modifier	= % \n" _modifier 
		
		current_modifier	= modPanel.getCurrentObject()

		if not ( this._iniFileExists() ) or classOf _modifier != classOf current_modifier then
			return false
		
		for prop in getPropNames _modifier do
		(
			format "prop	= % \n" prop
			--prop = substituteString prop "cbx_" "" -- remove "cbx_" prefix
			
			value	= getINISetting ini preset_name ( prop as string )
			
			format "value	= % \n" value
			
			--format "Modifier_v.loadPreset() % = % \n" prop value
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
	function deletePreset preset_name =
	(
		format "\n"; print "Modifier_v.deletePreset()"
		--this._setIniPath()

		delINISetting ini preset_name
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
		format "\n"; print "Modifier_v.openIni()"
		--this._setIniPath()

		if this._iniFileExists() then
			DOSCommand ("start \"\" \""+ini+"\"")
	),
	
	private


	/** Set ini path
	 */
	function _setIniPath =
	(
		format "\n"; print "Modifier_v._setIniPath()"
		--format "_modifier	= % \n" _modifier
		--format "classOf _modifier	= % \n" (classOf _modifier)

		ini = (getFilenamePath(getSourceFileName())) + "\\Lib\\Modifiers\\ModifierTypes\\"+( classOf _modifier ) as string +".ini"
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
		format "\n"; print "Modifier_v.create()"
		--format "classOf _modifier A = % \n" (classOf _modifier)
		format "_modifier	= % \n" _modifier
		

		if _modifier != undefined and superClassOf _modifier != modifier then
			_modifier = modPanel.getCurrentObject()
			--_modifier = execute (_modifier as string + "()")

		
		this._setIniPath()

		--format "_modifier	= % \n" _modifier
	)
)