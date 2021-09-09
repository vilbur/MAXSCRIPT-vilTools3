
/** waitForSelectionChangeCallback
 */
function waitForSelectionChangedCallback =
(
	print "Start: onSelectionChanged()"
	callbacks.addScript #selectionSetChanged "onSelectionChanged()" id:#onSelectionChanged
)


/** Wait for modifier change callback
 */
function waitForSelectionChangedKill =
(
	print "Kill: waitForSelectionChangedKill()"
	try(callbacks.removeScripts #selectionSetChanged   id:#onSelectionChanged)catch()	
)



/** addScript #modPanelObjPostChange callback when selection is really changed
  *
  * This method avoid re selection of same object
  *
  *
 */
function onSelectionChanged =
(
	--print "Callback: onSelectionChanged()"
				
	if( selection.count == 1 ) then
	(
		print "Callback: onSelectionChanged()"

		obj = selection[1]
		
		node_exist =  LastActiveModifier.nodeExists obj
		
		LastActiveModifier.setNode obj
		--ROLLOUT_modifiers.CHECKBOX_keep_edit_poly.state
		if( node_exist ) then -- Node exists in LastActiveModifier
			waitForModifierActivationCallback() -- Wait if user elect modifier in stack or will select another object
	
		else
			waitForModifierChangeCallback() --  "Node is selected first time"
	)
	else
	(
		print "DESELECT - reset all callbacks"
		
		waitForSelectionChangedKill()
		waitForModifierChangeKill()
		waitForModifierActivationKill()

		LastActiveModifier._node = undefined
		
		waitForSelectionChangedCallback()
	)
)
