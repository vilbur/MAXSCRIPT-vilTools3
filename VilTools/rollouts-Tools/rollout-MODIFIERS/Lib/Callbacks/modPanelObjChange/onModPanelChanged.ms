global ON_MOD_PANEL_CHANGED = #()


/*------------------------------------------------------------------------------
	
	Sequence of calling functions

	1) onModPanelChanged()	Set	CALLBACK
	2) onSelectionChangedWaitForStack()	Call	CALLBACK
	
--------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
	ON SELECTION CHANGED
--------------------------------------------------------------------------------*/

/** Wait for selection change callback
 */
function waitSelectionChangedCallback =
(
	print "Start: waitSelectionChangedCallback()"
	callbacks.addScript #selectionSetChanged "onSelectionChangedWaitForStack()" id:#onSelectionChangedWaitForStack
)

/** Kill callback
 */
function waitSelectionChangedKill =
(
	print "Kill: waitSelectionChangedKill()"
	try(callbacks.removeScripts #selectionSetChanged   id:#onSelectionChangedWaitForStack)catch()	
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



/** On mod panel changed
  *
  * @property	string	callbackFn	function called on modify panel changed
 */
function onModPanelChanged callbackFn =
(
	appendIfUnique ON_MOD_PANEL_CHANGED callbackFn
	
	waitSelectionChangedCallback()
	--waitModifiyStackReadyCallback()
)

/** Kill callback onModPanelChanged()
 */
function onModPanelChangedKill callbackFn =
(
	--format "\n"; print ".onModPanelChanged()"
	if (index = findItem ON_MOD_PANEL_CHANGED callbackFn) > 0 then
		deleteItem ON_MOD_PANEL_CHANGED index
	
	--waitModifiyStackReadyKill()
	waitSelectionChangedKill()

)




/*--------------------------------------------------------------------------------
	CALL CALLBACKS
--------------------------------------------------------------------------------*/

/** addScript #modPanelObjPostChange callback when selection is really changed
  *
  * This method avoid re selection of same object
  *
  *
 */
function onSelectionChangedWaitForStack =
(
	print "Callback: onSelectionChangedWaitForStack()"
				
	if( selection.count == 1 ) then
	(
		print "Callback: onSelectionChangedWaitForStack()"
		
		if( DynamicModifyPanel.selectionChanged (obj = selection[1]) ) then -- if new selection has been created
		(
			print "Selection changed"
			waitModifiyStackReadyCallback()
			
		) else
			print "Object reselected"
		--selection_changed =  DynamicModifyPanel.selectionChanged obj
	)
	else if( selection.count == 0 ) then
	(
		print "DESELECTED ALL"
		
		--waitModifierChangeKill()
		waitModifiyStackReadyKill()

		--DynamicModifyPanel._node = undefined
		
		--enableModifiersAfterEdit()

	)
)



/** Call callback when mod panel is fully loaded
 */
function onModifyStackReady =
(
	print "Callback: onModifyStackReady WAIT"
	
	max modify mode

	if( (_modifier = modPanel.getCurrentObject()) != undefined ) then -- current object is undefined than Modify panel is fully loaded
	(
		print "Callback: onModifyStackReady READY"
		
		waitModifiyStackReadyKill()
		
		for callback in ON_MOD_PANEL_CHANGED do 
			execute(callback+"()")
			
		--waitModifiyStackReadyCallback()
		
	)
)


/* KILL ON STARTUP */ 
waitModifiyStackReadyKill()
