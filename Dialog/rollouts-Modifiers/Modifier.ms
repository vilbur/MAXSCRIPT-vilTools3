filein( getFilenamePath(getSourceFileName()) + "/Modifiers/Modifiers.ms" )
/** Modifier
 */
struct Modifier_v
(
	name,
	type,
	
	Modifiers	= Modifiers_v(),
	--type="Edit_Poly",
	
	_modifier,
	
	/** Get
	 */
	function add =
	(
		type = type as string
		
		this._setModifier()
		
		this._getName()
		
		modPanel.addModToSelection _modifier ui:on
		
		_modifier --return
	),
	/** Get current
	 */
	function getCurrent obj =
	(
		max modify mode
		
		
		
	),
	
	
	
	/** Get objects with instance of given modifier
	  *
	  * @property	array	_objects	where to serch for instance of modifier
	  * @property	modifier	_modifier	for search
	  *
	  * @return	array	
	 */
	function getObjectsWithInstance _objects _modifier =
	(
		for obj in _objects where ( (Modifiers.search obj _modifier).count > 0 ) collect obj
	),
	/** _set modifier
	 */
	function _setModifier =
	(
		if( hasProperty Modifiers type ) then
			_modifier = getProperty Modifiers type --return 
		else
			_modifier = execute (type+"()") --return
	
	),
	/** _get name
	 */
	function _getName =
	(
		
		if( name!=undefined ) then
			_modifier.name = name
		
		--print ( "classOf type=" + type as string )
	),

	on create do
	(
		--messagebox "Modifiers.onCreate()"
	)
)



