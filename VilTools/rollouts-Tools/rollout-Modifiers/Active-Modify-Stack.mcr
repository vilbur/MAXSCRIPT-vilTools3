

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/DynamicModifyPanel/DynamicModifyPanel.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/killCallbacks.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/waitForModifierChange.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/waitForSelectionChange.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/waitForModifierActivation.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/disableInstancedModifiersOnEdit.ms" )


filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/keepEditPoly.ms" )
/*
*	
*/	
macroscript	modifiers_keep_last
category:	"_Modifiers"  
buttonText:	"Keep last"
tooltip:	"Keep Active last active modifier"
icon:	"type:checkbox|columns:8"
(
	format "EventFired = % \n" EventFired
	if( EventFired.value ) then
	(
		waitForSelectionChangedKill()

		ROLLOUT_modifiers.CHECKBOX_keep_edit_poly.state = false
		
		waitForSelectionChangedCallback()
	)
)

/*
*	
*/	
macroscript	modifiers_keep_edit_poly
category:	"_Modifiers"  
buttonText:	"Keep Edit Poly"
tooltip:	"Keep Active the most top Edit Poly modifier"
icon:	"type:checkbox|columns:8"
(
	--format "EventFired = % \n" EventFired
	if( EventFired.value ) then
	(
		waitForSelectionChangedKill()
	
		ROLLOUT_modifiers.CHECKBOX_keep_last.state = false
		
		waitForSelectionChangedCallback()
	)
)

--/*
--*	
--*/	
--macroscript	modifiers_disable_instanced_on_edit
--category:	"_Modifiers"  
--buttonText:	"Disable instances"
--tooltip:	"Disable instanced modifiers,if object is in subobject"
--icon:	"type:checkbox|columns:8"
--(
--	if( EventFired.value ) then 
--		CallbacksHolder.start #SelectionSetChanged "disableInstancedModifiersOnEdit"
--	else
--		CallbacksHolder.kill  #SelectionSetChanged "disableInstancedModifiersOnEdit"
--)
--
