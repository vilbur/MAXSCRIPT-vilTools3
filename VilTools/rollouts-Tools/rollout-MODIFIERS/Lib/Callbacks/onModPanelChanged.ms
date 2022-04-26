ON_MOD_PANEL_CHANGED = #()

waitSelectionChangedKill()
waitModifiyStackReadyKill()

/*------------------------------------------------------------------------------
	
	Sequence of calling functions

	1) onModPanelChanged()	Set	CALLBACK
	2) onSelectionChangedWaitForStack()	Call	CALLBACK
	
--------------------------------------------------------------------------------*/

/** On mod panel changed
  *
  * @property	string	callbackFn	function called on modify panel changed
 */
function onModPanelChanged callbackFn =
(
	appendIfUnique ON_MOD_PANEL_CHANGED callbackFn
	
	waitModifiyStackReadyCallback()
)

/** Kill callback onModPanelChanged()
 */
function onModPanelChangedKill callbackFn =
(
	--format "\n"; print ".onModPanelChanged()"
	if (index = findItem ON_MOD_PANEL_CHANGED callbackFn) > 0 then
		deleteItem ON_MOD_PANEL_CHANGED index
	
	waitModifiyStackReadyKill()
)


/*------------------------------------------------------------------------------
	ON MOD PANEL CHANGED
--------------------------------------------------------------------------------*/

/** Wait when modifier stack will be ready
 */
function waitModifiyStackReadyCallback =
(
	print "Start: waitModifiyStackReadyCallback()"
	callbacks.addScript #modPanelObjPostChange "onModifyStackReady()" id:#onModifyStackReady
)

/** 
 */
function waitModifiyStackReadyKill =
(
	print "Kill: waitModifiyStackReadyKill()"
	try(callbacks.removeScripts #modPanelObjPostChange id:#onModifyStackReady)catch()
)


/*--------------------------------------------------------------------------------
	CALL CALLBACKS
--------------------------------------------------------------------------------*/


/** Call callback when mod panel is fully loaded
 */
function onModifyStackReady =
(
	print "Callback: onModifyStackReady WAIT"
	
	--max modify mode

	if( (_modifier = modPanel.getCurrentObject()) != undefined ) then -- current object is undefined than Modify panel is fully loaded
	(
		print "Callback: onModifyStackReady READY"
		
		for callback in ON_MOD_PANEL_CHANGED do 
			execute(callback+"()")
	)
)