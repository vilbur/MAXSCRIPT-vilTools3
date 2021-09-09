

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/DynamicModifyPanel/DynamicModifyPanel.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/DynamicModifyPanel/onSelectionChangedWaitForStack.ms" )



filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/ActivateFirstEditPoly.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/activateLastModifier.ms" )


filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/disableInstancedModifiersOnEdit.ms" )


filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/saveModifierChange.ms" )


/*
*	
*/	
macroscript	modifiers_activate_edit_poly
category:	"_Modifiers"  
buttonText:	"First Edit Poly"
tooltip:	"Keep Active the most top Edit Poly modifier"
icon:	"type:checkbox|columns:8"
(
	--format "EventFired = % \n" EventFired
	if( EventFired.value ) then
	(
		waitSelectionChangedKill()
	
		ROLLOUT_modifiers.CHECKBOX_keep_last.state = false
		
		waitSelectionChangedCallback()
	)
)

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
		waitSelectionChangedKill()

		ROLLOUT_modifiers.CHECKBOX_first_edit_poly.state = false
		
		waitSelectionChangedCallback()
	)
)

/**  
 *	
 */
macroscript	modifiers_disable_on_edit
category:	"_Modifiers"
buttontext:	"Disable modifiers"
toolTip:	"Disable modifiers on edit"
icon:	"type:checkbox|columns:8"
(
	
		format "ROLLOUT_modifiers.CHECKBOX_disable_modifiers.state = % \n" ROLLOUT_modifiers.CHECKBOX_disable_modifiers.state

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
