/** Transform locker
 */
struct TransformLocker_v
(
	/* construct */
	_objects,

	/* properties */

	lock_keys = #( #MOVE_X, #MOVE_Y, #MOVE_Z, #ROTATE_X, #ROTATE_Y, #ROTATE_Z, #SCALE_X, #SCALE_Y, #SCALE_Z ),

	/* dependency */
	/* reference */
	/* inhered */

	/** Lock
	  *
	 *   @param boolean state of lock
	  *  @param #ROTATE|#MOVE|#SCALE|#MOVE_X|#MOVE_Y|#MOVE_Z|#ROTATE_X|#ROTATE_Y|#ROTATE_Z|#SCALE_X|#SCALE_Y|#SCALE_Z type If unsupplied then all transforms are used
	  */
	function toggle state type:#ALL =
	(
		--format "\n"; print "TransformLocker_v.toggle()"
		for obj in _objects do
			this._toggle (obj)(type)(state)
	),

	/** Get state
	  *
	  * @return Dictionary #( #MOVE_X, true|false ) #( #MOVE_Y, true|false )...
	  */
	function getState obj =
	(
		--format "\n"; print "TransformLocker_v.getState()"
		lock_states = getTransformLockFlags obj

		current_state	= Dictionary()

		for i = 1 to lock_keys.count do
			current_state[lock_keys[i]] = lock_states[i]

		current_state --return
	),


	private

	/** Lock
	  *
	  */
	function _toggle obj type state  =
	(
		--format "\n"; print "TransformLocker_v._lock()"

		lock_states = getTransformLockFlags obj

		if type != #ALL then
			for lock_key in lock_keys where matchPattern (lock_key as string ) pattern:( type as string +"*" ) do
				lock_states[findItem lock_keys lock_key] = state
		else
			lock_states = if state then #{1..9} else #{}

		setTransformLockFlags obj lock_states
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "TransformLocker.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

		if classOf _objects == ObjectSet then
			_objects = _objects as Array

		else if classOf _objects != Array then
			_objects = #(_objects)

	)
)
