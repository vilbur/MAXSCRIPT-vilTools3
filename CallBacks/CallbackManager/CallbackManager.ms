

/**
  *
  */
struct Callback_v
(
	callback,	-- function called on event
	type,	-- event type
	id,	-- callback id, can be sahre acrros mutliple callbacks

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
	List = Dictionary(), -- KEY: callback_fn_callback_type VALUE:Callback_v

	/* dependency */
	/* reference */
	/* inhered */

	/** Add Callback
	  *
	  */
	function add callback type id:undefined  =
	(
		--format "\n"; print "CallbackManager_v.add()"
		callback_key = this._getCallbackKey (callback)(type)(id)

		this.List[callback_key] = Callback_v callback:(this._getCallbackFn (callback)) type:type id:( if id == undefined then unsupplied else id )

		this.start (this.List[callback_key])
	),

	/** Add Callback
	  *
	  * @retrun #(Callback_v) removed callbacks
	  */
	function remove callback:undefined type:undefined id:undefined  =
	(
		--format "\n"; print "CallbackManager_v.remove()"
		_Callbacks = this.getCallbacks(callback) (type) (id)

		--format "_Callbacks	= % \n" _Callbacks
		--format "\n\n------------------------------------\n\n"

		if _Callbacks != undefined then
			for _Callback in _Callbacks do
				this.kill (_Callback)

		_Callbacks --return
	),

	/** Get callbacks
	 *
	 * @return #(Callback_v)
	 */
	function getCallbacks callback type id  =
	(
		--format "\n"; print "Callback_v.getCallback()"
		--format "\n\n------------------------------------\n\n"

		/** Get callback by type
		 */
		function getCallbackByProperty key val option_key:undefined option_val:undefined =
		(
			for dataPair in this.List
				where getProperty dataPair.value key == val and ( if option_val != undefined then getProperty dataPair.value option_key == option_val else true )
				--where getProperty dataPair.value key == val
					collect dataPair.value
			--for dataPair in this.List where dataPair.value.type == type and ( if id != undefined then  dataPair.value.id == id else true ) collect dataPair.value
		)


		callback_exist	= callback	!= undefined
		type_exist	= type	!= undefined
		id_exist	= id	!= undefined

		callback = (this._getCallbackFn(callback))

		if not ( callback_exist and type_exist and id_exist ) then
			case of
			(
				/*------ GET BY MULTIPLE PARAMS ------*/
				(callback_exist and type_exist ):	getCallbackByProperty(#type)	(type)	option_key:#type	option_val:type
				(callback_exist and id_exist ):	getCallbackByProperty(#callback)	(callback)	option_key:#id	option_val:id
				(type_exist     and id_exist ):	getCallbackByProperty(#type)	(type)	option_key:#id	option_val:id

				--/*------ GET BY SINGLE PARAM ------*/
				(callback_exist ):	getCallbackByProperty(#callback)	(callback)
				(type_exist ):	getCallbackByProperty(#type)	(type)
				(id_exist ):	getCallbackByProperty(#id)	(id)
			)
		else
			/*------ GET BY ALL PARAMS ------*/
			#( this.List[this._getCallbackKey (callback)(type)(id)] )
	),


	/** Start
	 *
	 */
	function start Callback =
	(
		--format "\n"; print "CallbackManager_v.start()"
		callbacks.addScript Callback.type Callback.callback id:Callback.id
	),

	/** Kill
	 *
	 */
	function kill Callback =
	(
		--format "\n"; print "CallbackManager_v.kill()"
		--format "Callback.type = % \n" Callback.type
		--format "Callback.id   = % \n" Callback.id
		try( callbacks.removeScripts Callback.type id:Callback.id )catch()
	),

	private

	/** Turn #name to string and add suffix "()"
	 *
	 *
	 * @return #name E.G.: "fooFn()"
	 */
	function _getCallbackFn callback =
	(
		--format "\n"; print "Callback._getCallbackName()"
		--if not matchPattern (callback) pattern:@"pattern"ignoreCase:false then

		( trimRight ( callback as string ) "()" ) + "()" --return
	),

	/** Get callback key for this.List
	 *
	 * @return #name E.G.: #callbackFn_nodeCreated
	 */
	function _getCallbackKey callback type id =
	(
		--format "\n"; print "Callback._getCallbackName()"

		id_string = if id != undefined then "_" + id as string else ""

		(( trimRight (callback as string ) "()" ) +"_"+ (type as string ) + id_string ) as name --return
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
