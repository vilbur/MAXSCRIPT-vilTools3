


struct Callback_v
(
	call,
	id,
	type,

	on create do
	(
	)
)


/*

  	[callback types]https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_C1F6495F_5831_4FC8_A00C_667C5F2EAE36_htm
 */
struct CallbackManager_v
(
	/* construct */

	/* properties */
	List = Dictionary(),

	/* dependency */
	/* reference */
	/* inhered */

	/** Add Callback
	  *
	  */
	function add callback_fn callback_type id:undefined  =
	(
		format "\n"; print "CallbackManager_v.add()"

		callback_fn_name = this._getCallbackName (callback_fn)

		Callback = Callback_v call:(callback_fn_name as string +"()") type:callback_type id:id

		this.List[callback_fn_name] = Callback

		this.start (Callback)
	),

	/** Add Callback
	  *
	  */
	function remove callback_fn type: id:  =
	(
		--format "\n"; print "CallbackManager_v.add()"
		callback_fn_name = this._getCallbackName (callback_fn)

		Callback = this.List[callback_fn_name]

		RemoveDictValue this.List callback_fn_name

		this.kill (Callback)
	),


	/** Start
	 *
	 */
	function start Callback =
	(
		format "\n"; print "CallbackManager_v.start()"


		callbacks.addScript Callback.type Callback.call id:Callback.id

	),

	/** Kill
	 *
	 */
	function kill Callback =
	(
		format "\n"; print "CallbackManager_v.kill()"
		try( callbacks.removeScripts Callback.type id:Callback.id )catch()
	),

	private

	/** Get callback name
	 *
	 *  @param string callback_fn E.G.: "fooFn()"
	 *
	 * @return #name E.G.: #fooFn
	 */
	function _getCallbackName callback_fn =
	(
		--format "\n"; print "Callback._getCallbackName()"

		( trimRight callback_fn "()" ) as name --return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "CallbackManager.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
