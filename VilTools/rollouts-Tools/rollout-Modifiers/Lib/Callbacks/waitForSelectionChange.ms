


/** addScript #modPanelObjPostChange callback when selection is really changed
  *
  * This method avoid re selection of same object
  *
  *
 */
function onSelectionChangedWaitForStack =
(
	--print "Callback: onSelectionChangedWaitForStack()"
				
	if( selection.count > 0 ) then
	(
		print "Callback: onSelectionChangedWaitForStack()"
		
		if( DynamicModifyPanel.selectionChanged (obj = selection[1]) ) then -- if new selection has been created
		(
			format "selection_changed = % \n" selection_changed		
			node_exist =  DynamicModifyPanel.nodeExists obj
			format "node_exist = % \n" node_exist
			DynamicModifyPanel.setNode obj
	
			if( node_exist ) then -- Node exists in DynamicModifyPanel
				waitForModifierActivationCallback() -- Wait if user elect modifier in stack or will select another object
			
			else
				waitForModifierChangeCallback() --  "Node is selected first time"
			
		) else
			print "Object reselected"
		--selection_changed =  DynamicModifyPanel.selectionChanged obj
	)
	else
	(
		print "DESELECT - reset all callbacks"
		
		waitForSelectionChangedKill()
		waitForModifierChangeKill()
		waitForModifierActivationKill()

		DynamicModifyPanel._node = undefined
		
		waitForSelectionChangedCallback()
	)
)
