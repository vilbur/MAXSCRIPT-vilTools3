global ON_MOD_PANEL_CHANGED_CALLBACKS = #()


/** On mod panel changed
  *
  * @property	string	callbackFn	function called on modify panel changed
 */
function onModPanelChanged callbackFn =
(
	appendIfUnique ON_MOD_PANEL_CHANGED_CALLBACKS callbackFn
	
	waitSelectionChangedCallback()
)

/** Kill callback onModPanelChanged()
 */
function onModPanelChangedKill callbackFn =
(
	--format "\n"; print ".onModPanelChanged()"
	if (index = findItem ON_MOD_PANEL_CHANGED_CALLBACKS callbackFn) > 0 then
		deleteItem ON_MOD_PANEL_CHANGED_CALLBACKS index
	
	waitSelectionChangedKill()

)

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
	format "\n"
	print "Callback: onSelectionChangedWaitForStack()"
				
	if( selection.count > 0 ) then
	(
		print "Callback: onSelectionChangedWaitForStack()"
		
		if( DYNAMIC_MODIFY_PANEL.selectionChanged (obj = selection[1]) ) then -- if new selection has been created
		(
			print "Selection changed"
			format "obj	= % \n" obj
			waitModifiyStackReadyCallback()
			
		) else
			print "Object reselected"
	)
	--else if( selection.count == 0 ) then
	else
	(
		print "DESELECTED ALL"
		
		waitModifiyStackReadyKill()
	)
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
		
		for callback in ON_MOD_PANEL_CHANGED_CALLBACKS do 
			execute(callback+"()")
	)
)


/* KILL ON STARTUP */ 
waitModifiyStackReadyKill()
