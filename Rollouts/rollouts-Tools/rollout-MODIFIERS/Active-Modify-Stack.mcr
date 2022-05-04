--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/onModPanelChanged.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/modPanelObjChange/onModPanelChanged.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/modPanelObjChange/activateFirstEditPoly.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/modPanelObjChange/autoEndResult.ms" )

--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/ActivateFirstEditPoly.ms" )

--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/activateLastModifier.ms" )

--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/disableInstancedModifiersOnEdit.ms" )

--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/saveModifierChange.ms" )

--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/disableModifiersOnEdit.ms" )

--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/onSelectionMaxModifyMode.ms" )

/*
*	
*/	
macroscript	modifiers_activate_edit_poly
category:	"_Modifiers"  
buttonText:	"Active EditPoly"
tooltip:	"Keep active first Edit Poly modifier"
icon:	"type:checkbox"
(
	if( EventFired.val ) then
	(
		--activateFirstEditPoly()
		
		onModPanelChanged ("activateFirstEditPoly")
	)
	else
		onModPanelChangedKill ("activateFirstEditPoly")
)

/**  
 *	
 */
macroscript	modifiers_auto_end_result
category:	"_Modifiers"
buttontext:	"Auto end result"
toolTip:	"Turn off \"Show end result\" on subobject edit"
icon:	"type:checkbox"
(
	if( EventFired.val ) then
		callbacks.addScript #ModPanelSubObjectLevelChanged "autoEndResult()" id:#autoEndResult
	
	else
	
		try(callbacks.removeScripts #ModPanelSubObjectLevelChanged id:#autoEndResult)catch()

)


/*
*	
--*/	
--macroscript	modifiers_keep_last
--category:	"_Modifiers"  
--buttonText:	"Keep last"
--tooltip:	"Keep Active last active modifier"
--icon:	"type:checkbox"
--(
--	format "EventFired = % \n" EventFired
--	if( EventFired.val ) then
--	(
--		
--		
--		--waitSelectionChangedKill()
--		--
--		--ROLLOUT_modifiers.CHECKBOX_active_Edit_Poly.state = false
--		--
--		--waitSelectionChangedCallback()
--	)
--)
--
--/**  
-- *	
-- */
--macroscript	modifiers_disable_on_edit
--category:	"_Modifiers"
--buttontext:	"Disable modifiers"
--toolTip:	"Disable modifiers on edit"
--icon:	"type:checkbox"
--(
--	format "ROLLOUT_modifiers.CHECKBOX_disable_modifiers.state = % \n" ROLLOUT_modifiers.CHECKBOX_disable_modifiers.state
--)
--
--/**  
-- *	
-- */
--macroscript	modifiers_active_modify_mode
--category:	"_Modifiers"
--buttontext:	"Auto modify panel"
--toolTip:	"Open modify panel on object selection"
--icon:	"type:checkbox"
--(
--	--if( EventFired.val ) then
--	--	onSelectionMaxModifyModeCallback()
--	--	
--	--else
--	--	onSelectionMaxModifyModeKill()
--
--)

--/*
--*	
--*/	
--macroscript	modifiers_disable_instanced_on_edit
--category:	"_Modifiers"  
--buttonText:	"Disable instances"
--tooltip:	"Disable instanced modifiers,if object is in subobject"
--icon:	"type:checkbox"
--(
--	if( EventFired.val ) then 
--		CallbacksHolder.start #SelectionSetChanged "disableInstancedModifiersOnEdit"
--	else
--		CallbacksHolder.kill  #SelectionSetChanged "disableInstancedModifiersOnEdit"
--)
--
