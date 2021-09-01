

global callbacks_viltools	= #( #selectionSetChanged )


/** Selection set changed callback
 */
function selectionSetChangedCallback =
(
	--messageBox "Yupiii" beep:false
)



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
	
	
	/** Callbacks viltools kill
	 */
	function killAll =
	(
		for callback_name in callbacks_viltools do
			try( callbacks.removeScripts callback_name id:(this._getId callback_name) )catch()
	),
	
	/**  
	 *	
	 */
	fn start = 
	(
		--try( callbacks.addScript      #selectionSetChanged    "Calllbacks_onSelectionChange()" id: #Calllbacks_onSelectionChange )catch()
		this.killAll()
		
		
		for callback_name in callbacks_viltools do
		(
			--format "callback_name = % \nthis._getCallbackFunction() = % \nthis._getId callback_name = % \n\n" (callback_name as string) (this._getCallbackFunction callback_name) ((this._getId callback_name) as string)
			try( callbacks.addScript callback_name (this._getCallbackFunction callback_name ) id:(this._getId callback_name) )catch()
		)
	),
	
	/** Get id
	  *
	  * @return	#callback_id
	 */
	function _getId callback_name =
	(
		( "callbacks_viltools_" + (callback_name as string ) )  as name  --return
	),
	
	/** Get callback function name
	  *
	  * @return	string function name eg: "selectionSetChangedCallback"	
	 */
	function _getCallbackFunction callback_name =
	(
		(callback_name as string + "Callback()") --return
	),
	
	private
	
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
	)
	
)

