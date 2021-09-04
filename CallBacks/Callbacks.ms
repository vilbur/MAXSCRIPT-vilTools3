filein( getFilenamePath(getSourceFileName()) + "/../../Library/UI/Lib/Ini/Ini.ms" )

filein( getFilenamePath(getSourceFileName()) + "/CallbackType/CallbackType.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Callback/Callback.ms" )

filein( getFilenamePath(getSourceFileName()) + "/CallbackFunctions/selectionSetChanged.ms" )
filein( getFilenamePath(getSourceFileName()) + "/CallbackFunctions/ModPanelSubObjectLevelChanged.ms" )

global callback_type_names_v	= #( #SelectionSetChanged, #ModPanelSubObjectLevelChanged )


/** Callbacks on selection change
 * 
 *	https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_C1F6495F_5831_4FC8_A00C_667C5F2EAE36_htm
 * 
 */
struct Callbacks_v
(
	__construct = #(  ),
	
	/* required */
	/* dependency */
	/* reference */
	/* properties */
	CallbackTypesList = List_v(),
	
	/** Add callback
	 */
	function add callback_type_name callback =
	(
		--print("Callbacks_v.add()"+callback_type_name +" "+callback)
		--format "classof callback_type_name = % \n" (classof callback_type_name)
		if not ( this._typeExists callback_type_name ) then
			CallbackTypesList.setVal callback_type_name (CallbackType_v())
		
		CallbackType = this._getType callback_type_name
		
		CallbackType.add callback_type_name callback
		format "CallbackType = % \n" CallbackType.Callbacks.keys.count
	),
	
	
	/** Callbacks viltools kill
	 */
	function killAll =
	(
		--for callback_type_name in callback_type_names_v do
			--try( callbacks.removeScripts callback_type_name id:(this._getId callback_type_name) )catch()
	),
	
	/**  
	 *	
	 */
	fn start = 
	(
		this.killAll()
		
		--for callback_type_name in callback_type_names_v do
			--try( callbacks.addScript callback_type_name (this._getCallbackFunction callback_type_name ) id:(this._getId callback_type_name) )catch()
	),
	

	private
	
	/** Get all callbacks
	 */
	function _setAllCallbacks =
	(
		
	),
	
	/** Type exists
	 */
	function _getType callback_type_name =
	(
		CallbackTypesList.getVal callback_type_name --return	
	),
		
	/** Type exists
	 */
	function _typeExists callback_type_name =
	(
		CallbackTypesList.getVal callback_type_name != undefined --return	
	),
	
	/** Get\set value of property 
	 * @param	string|name key	Name  of property E.G.: "foo_key" OR #foo_key 
	 * @param	string|#get value	Value of property
	 *
	 * @return	string|self Value or self
	 *
	 * @example this._getSetProp "foo" "bar" -- SET "bar" to property "foo"
	 * @example this._getSetProp #foo  #get  -- GET value of property "foo"
	 */
	function _getSetProp key value =
	(
		if( value != #get ) then
		(
			if( value != undefined ) then
				setProperty  this ( key as string ) value
			this --return
		) else
			getProperty this ( key as string ) --return
	),
	
	/** Check if required properties are defined when an instance of the struct is created.
	 *	
	 * @example __construct = #( #property_name ) 
	 */
	function _checkConstctructProperties =
	(
		for prop in __construct where getProperty this prop == undefined do
			messageBox ("Undefined construct property !\n\n"+ ((filterString( classof this as string )"(:")[2]) +"."+ prop )
	),
	/**  
	 */
	on create do
	(
		this._checkConstctructProperties()
		this._setAllCallbacks()
	)
)