/**  
 *	
 *	
 */
struct Callback_v
(
	callback_type_name,
	
	callback,
		
	id,

	/**  
	 *	
	 */
	function start = 
	(
		callbacks.addScript callback_type_name callback id:id
	),
	
	/** Callbacks viltools kill
	 */
	function kill =
	(
		try( callbacks.removeScripts callback_type_name id:id )catch()
	),

	/**  
	 */
	on create do
	(
		sanitized = trimRight callback "()"
		id        = sanitized as name
		callback  = sanitized + "()"
	)
)