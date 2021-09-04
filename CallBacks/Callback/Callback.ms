/**  
 *	
 *	
 */
struct Callback_v
(
	--__construct = #( #callback ),
	
	callback,
	
	--id,
	
	/** Callbacks viltools kill
	 */
	function kill =
	(
		for callback_type_name in callback_type_names_v do
			try( callbacks.removeScripts type_name id:(this._getId callback_type_name) )catch()
	),
	
	/**  
	 *	
	 */
	fn start = 
	(
		
		try( callbacks.addScript callback_type_name (this._getCallbackFunction callback_type_name ) id:(this._getId callback_type_name) )catch()
	),
	

	/** Get id
	  *
	  * @return	#callback_id
	 */
	function _setId =
	(
		--( "callback_type_names_v_" + callback )  as name  --return
	),
	
	/** Get callback function name
	  *
	  * @return	string function name eg: "selectionSetChangedCallback"	
	 */
	function _getCallbackFunction callback_type_name =
	(
		fn_name = (callback_type_name as string + "Callback()")
		format " = % \n" fn_name
		
		(callback_type_name as string + "Callback()") --return
	),
	
	--/** Check if required properties are defined when an instance of the struct is created.
	-- *	
	-- * @example __construct = #( #property_name ) 
	-- */
	--function _checkConstctructProperties =
	--(
	--	for prop in __construct where getProperty this prop == undefined do
	--		messageBox ("Undefined construct property !\n\n"+ ((filterString( classof this as string )"(:")[2]) +"."+ prop )
	--),
	--
	/**  
	 */
	on create do
	(
		print("Callback_v.onCreate()")

		--this._checkConstctructProperties()
		
		
	)
)