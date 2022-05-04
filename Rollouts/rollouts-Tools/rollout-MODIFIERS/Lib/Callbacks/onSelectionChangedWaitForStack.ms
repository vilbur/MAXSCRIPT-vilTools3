/*------------------------------------------------------------------------------
	
	1) On selection changed
	
	
--------------------------------------------------------------------------------*/



/*------------------------------------------------------------------------------
	SELECTION CHANGED
--------------------------------------------------------------------------------*/

/** On mod panel changed
 */
function onModPanelChanged callbackFn =
(
	--format "\n"; print ".onModPanelChanged()"
	--messageBox "callbackFn" title:"Title"  beep:false
	execute(callbackFn+"()")
)


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
	MODIFY PANEL
--------------------------------------------------------------------------------*/

/** Wait when modifier stack will be ready after selection has been changed
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
	CALLBACKS
--------------------------------------------------------------------------------*/

/** addScript #modPanelObjPostChange callback when selection is really changed
  *
  * This method avoid re selection of same object
  *
  *
 */
function onSelectionChangedWaitForStack =
(
	--print "Callback: onSelectionChangedWaitForStack()"
				
	if( selection.count == 1 ) then
	(
		print "Callback: onSelectionChangedWaitForStack()"
		
		if( DynamicModifyPanel.selectionChanged (obj = selection[1]) ) then -- if new selection has been created
		(
			print "Selection changed"
			waitModifiyStackReadyCallback()
			
			--enableModifiersAfterEdit()

		) else
			print "Object reselected"
		--selection_changed =  DynamicModifyPanel.selectionChanged obj
	)
	else if( selection.count == 0 ) then
	(
		print "DESELECTED ALL"
		
		waitModifierChangeKill()
		waitModifiyStackReadyKill()

		--DynamicModifyPanel._node = undefined
		
		--enableModifiersAfterEdit()

	)
)



/** Wait then modify stack is loaded
 */
function onModifyStackReady =
(
	print "Callback: onModifyStackReady WAIT"
	
	--max modify mode

	if( (_modifier = modPanel.getCurrentObject()) != undefined ) then -- current object is undefined than Modify panel is fully loaded
	(
		print "Callback: onModifyStackReady READY" 

		--if( ROLLOUT_modifiers.CHECKBOX_keep_last.state ) then
		--	activateLastModifier()
		--
		--else if( ROLLOUT_modifiers.CHECKBOX_Active_Edit_Poly.state ) then 
		--	activateFirstEditPoly()

	)
)