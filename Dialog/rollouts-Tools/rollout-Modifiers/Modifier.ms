filein( getFilenamePath(getSourceFileName()) + "/Modifiers/Modifiers.ms" )
/** Modifier
 */
struct Modifier_v
(
	name,
	type,
	
	Modifiers	= Modifiers_v(),
	
	modifier,
	
	/** Get
	 */
	function add =
	(
		type = type as string
		
		this._setModifier()
		
		this._getName()
		
		modPanel.addModToSelection modifier ui:on
		
		modifier --return
	),
	
	/** Set current modifier
	 */
	function setCurrent =
	(
		max modify mode
		
		modifier = modPanel.getCurrentObject() --return
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
	--/** _get name
	-- */
	--function _getName =
	--(
	--	modifier.name = name
	--),

	on create do
	(
	
	)
)



