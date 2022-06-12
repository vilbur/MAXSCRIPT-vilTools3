filein( getFilenamePath(getSourceFileName()) + "/Lib/Events/onSelectionChangedModPanel.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/activateFirstModifierOfType.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/activateFirstEditPoly.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/activateFirstUnwrap.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/LastModifierSaver/LastModifierSaver.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/lastModifierOnSelectionChanged.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/activateLastModifier.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/autoEndResult.ms" )


--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/disableInstancedModifiersOnEdit.ms" )

--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/saveModifierChange.ms" )

--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/disableModifiersOnEdit.ms" )

--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/onSelectionMaxModifyMode.ms" )



/*
*	
*/	
macroscript	modifiers_activate_modifier
category:	"_Modifiers"  
--buttonText:	"[Keep active modifier]"
buttonText:	"Keep active modifier"
tooltip:	"select first modifier when object is selected"
--icon:	"type:RadioButtons|items:#('Edit Poly', 'Unwrap', 'Last Modifier')|align:#left"
icon:	"type:RadioButtons|items:#('Edit Poly', 'Unwrap', 'Last Modifier')|unselect:true|align:#left"
--icon:	"type:RadioButtons|items:#('Edit Poly', 'Unwrap', 'Last Modifier')|default:3|align:#left"
(
	format "EventFired	= % \n" EventFired
	format "EventFired.val	= % \n" EventFired.val
	
	
	onSelectionChangedModPanelKill ("onNewModPanelKill")
	onSelectionChangedModPanelKill ("activateFirstUnwrap")
	--onSelectionChangedModPanelKill ("activateLastModifier")
	saveLastModifierKill()
	
	if( EventFired.val == 1 ) then
	(
		activateFirstEditPoly()
		
		onSelectionChangedModPanel ("activateFirstEditPoly")
		
	)
	else if( EventFired.val == 2 ) then
	(
		activateFirstUnwrap()
		
		onSelectionChangedModPanel ("activateFirstUnwrap")
	)
	
	else if( EventFired.val == 3 ) then
	(
		saveLastModifierStart()
		
		--onSelectionChangedModPanel ("activateLastModifier")
		
	)
)



--/*
--*	
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
--macroscript	modifiers_auto_end_result
--category:	"_Modifiers"
--buttontext:	"End result"
--toolTip:	"Auto end result if subobject is changed to 0"
----toolTip:	"Turn off \"Show end result\" on subobject edit"
--icon:	"type:checkbox"
--(
--	if( EventFired.val ) then
--		callbacks.addScript #ModPanelSubObjectLevelChanged "autoEndResult()" id:#autoEndResult
--	
--	else
--	
--		try(callbacks.removeScripts #ModPanelSubObjectLevelChanged id:#autoEndResult)catch()
--
--)



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
