/** Keep last temp
 */
function activateLastModifier =
(
	print "Activate Last Modifier"
	obj        = selection[1];
	node_exist =  DynamicModifyPanel.nodeExists obj
	--format "node_exist = % \n" node_exist
	DynamicModifyPanel.setNode obj

	if( node_exist ) then -- Node exists in DynamicModifyPanel
	(
		waitModifiyStackReadyKill()
		
		DynamicModifyPanel.activate() -- Wait if user elect modifier in stack or will select another object

		waitModifierChangeCallback() -- wait for another change of modifier
	)
	else
		waitModifierChangeCallback() --  "Node is selected first time"
	

)