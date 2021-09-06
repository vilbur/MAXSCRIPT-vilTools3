filein( getFilenamePath(getSourceFileName()) + "/Callback/Callback.ms" )
filein( getFilenamePath(getSourceFileName()) + "/CallbackType/CallbackType.ms" )



global callback_type_names_v	= #( #SelectionSetChanged, #ModPanelSubObjectLevelChanged )


/** 
 * 
 *	https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_C1F6495F_5831_4FC8_A00C_667C5F2EAE36_htm
 * 
 */
struct Callbacks_v
(	
	/* properties */
	CallbackTypesList = List_v(),
	
	/** Add callback
	  *
	  * @return	object Callback_v	
	 */
	function add callback_type_name callback =
	(
		--print("\nCallbacks_v.add "+callback_type_name +" "+callback)
		_CallbackType = this._getCallbackType callback_type_name 
		--format "_CallbackType = % \n" _CallbackType	
		_CallbackType.add callback_type_name callback --return
		--format "Callback = % \n" Callback
		--Callback --return
	),
	
	/** Start callback
	  *
	  * @return	object Callback_v	
	 */
	function start callback_type_name callback =
	(
		--print("Callbacks_v.start "+callback_type_name +" "+callback)
		_Callback = this.add (callback_type_name as name) callback
		--format "Callback = % \n" _Callback
		_Callback.start()
	),
	
	/** Kill
	  *
	  * @return	object Callback_v	
	 */
	function kill callback_type_name callback =
	(
		--print("Callbacks_v.kill "+callback_type_name +" "+callback)
		_Callback = this.get callback_type_name callback
		--format "Callback = % \n" _Callback
		_Callback.kill()
	),
	
	/** Get callback from CallbackTypesList
	  *
	  * @return	Callback_v|undefined 	
	 */
	function get callback_type_name callback =
	(
		if ( (CallbackType = this._getType callback_type_name) != undefined ) then
			if ( (_Callback = CallbackType.get callback) != undefined ) then
					_Callback --return
	),

	private
	
	/** Add callback types
	 */
	function _getCallbackType callback_type_name =
	(
		if ( (CallbackType = this._getType callback_type_name) == undefined ) then
			CallbackType = CallbackTypesList.setVal callback_type_name (CallbackType_v())

		CallbackType --return
	),
	
	/** Type exists
	 */
	function _getType callback_type_name =
	(
		CallbackTypesList.getVal (callback_type_name as name) --return	
	),

	/**  
	 */
	on create do
	(
		--print("Callbacks_v.onCreate()")
	)
)


/** Startup callbacks 
 *	
 */
global CallbacksHolder = Callbacks_v()


/** FileIn Callback functions 
 *	
 */
for file in ( sort ( getFiles ( getFilenamePath(getSourceFileName()) + "/CallbackFunctions/*.ms"))  ) do
	filein file
