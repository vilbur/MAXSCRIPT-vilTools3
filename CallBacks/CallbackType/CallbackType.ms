/** Container holding callbacks by type
 * 
 */
struct CallbackType_v
(
	__construct = #(  ),
	
	/* required */
	/* dependency */
	/* reference */
	/* properties */
	Callbacks = List_v(),
	
	/** Add callback
	 */
	function add callback_type_name callback =
	(
		print("CallbackType_v.add() "+callback_type_name +" "+callback)
		
		--Callback 	= Callback_v callback:callback

		Callbacks.setVal callback (Callback_v callback:callback)

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
		print("CallbackType_v.onCreate()")

		this._checkConstctructProperties()
	)
	
)