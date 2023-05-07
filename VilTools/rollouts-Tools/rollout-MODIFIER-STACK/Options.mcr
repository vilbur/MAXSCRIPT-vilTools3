filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/autoEndResult.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/disableModifiersOnEdit.ms" )

--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/onSelectionMaxModifyMode.ms" )



/**  
 */
macroscript	modifiers_auto_end_result
category:	"_Modifiers"
buttontext:	"End result"
toolTip:	"Show end result if subobject == 0"
--toolTip:	"Turn off \"Show end result\" on subobject edit"
icon:	"control:checkbox"
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
buttontext:	"Disable above on edit"
toolTip:	"Disable modifiers above active modifier when subobject is entered"
icon:	"control:checkbox|enabled:false"
(
	--format "modifier_stack.disable_modifiers.state = % \n" modifier_stack.disable_modifiers.state
	
	--messageBox "mAKE THIS WORKING" title:"Title"  beep:false

	if( EventFired.val ) then
		callbacks.addScript #ModPanelSubObjectLevelChanged "disableModifiersOnEdit()" id:#disableModifiersOnEdit
	
	else
	
		try(callbacks.removeScripts #ModPanelSubObjectLevelChanged id:#disableModifiersOnEdit)catch()
	
)