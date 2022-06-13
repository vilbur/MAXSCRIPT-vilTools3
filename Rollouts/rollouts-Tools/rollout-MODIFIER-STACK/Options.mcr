filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/autoEndResult.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/disableInstancedModifiersOnEdit.ms" )

--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/saveModifierChange.ms" )

--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/disableModifiersOnEdit.ms" )

--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/onSelectionMaxModifyMode.ms" )





/**  
 */
macroscript	modifiers_auto_end_result
category:	"_Modifiers"
buttontext:	"End result"
toolTip:	"Auto end result if subobject is changed to 0"
--toolTip:	"Turn off \"Show end result\" on subobject edit"
icon:	"type:checkbox"
(
	if( EventFired.val ) then
		callbacks.addScript #ModPanelSubObjectLevelChanged "autoEndResult()" id:#autoEndResult
	
	else
	
		try(callbacks.removeScripts #ModPanelSubObjectLevelChanged id:#autoEndResult)catch()

)

/**  
 */
macroscript	modifiers_disable_on_edit
category:	"_Modifiers"
buttontext:	"Disable modifiers"
toolTip:	"Disable modifiers on edit"
icon:	"type:checkbox"
(
	format "modifier_stack.disable_modifiers.state = % \n" modifier_stack.disable_modifiers.state
	
	messageBox "mAKE THIS WORKING" title:"Title"  beep:false
)
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
