clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Callbacks.ms" )

global CallbacksHolder = Callbacks_v()


/** Selection set changed callback
 */
function selectionSetChangedCallback =
(
	messageBox "selectionSetChangedCallback" beep:false
)

/** Selection set changed callback
 */
function selectionSetChangedCallback_Secondary =
(
	messageBox "selectionSetChangedCallback_Secondary" beep:false
)

CallbacksHolder.add #SelectionSetChanged "selectionSetChangedCallback"


CallbacksHolder.start #SelectionSetChanged "selectionSetChangedCallback_Secondary"