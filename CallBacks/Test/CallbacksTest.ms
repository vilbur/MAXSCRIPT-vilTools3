clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Library/List/List.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../Callbacks.ms" )



/** Prepare Test object
 */
function prepareTestObject =
(
	delete objects
	box()
)


/** TEST 
 *	
 */
global CallbacksHolder = Callbacks_v()

/** Selection set changed callback
 */
function selectionSetChangedCallback =
(
	messageBox "TEST SUCCESS\nselectionSetChangedCallback" beep:false
	
	_Callback = CallbacksHolder.get #SelectionSetChanged "selectionSetChangedCallback"
	
	format "_Callback = % \n" _Callback
	
	_Callback.kill()
)

/** Set callbacks test
 */
function setCallbacksTest =
(
	CallbackNew = CallbacksHolder.add #SelectionSetChanged "selectionSetChangedCallback"
	format "CallbackNew = % \n" CallbackNew
	
	CallbackGet = CallbacksHolder.start #SelectionSetChanged "selectionSetChangedCallback"
	format "CallbackGet = % \n" CallbackGet
	
	CallbacksHolder.start #SelectionSetChanged "selectionSetChangedCallback"
)


/** 1) create test box 
 *	2) START selection callback test
 *	3) select box
 *	4) KILL callback
 */

prepareTestObject()
setCallbacksTest()
select objects