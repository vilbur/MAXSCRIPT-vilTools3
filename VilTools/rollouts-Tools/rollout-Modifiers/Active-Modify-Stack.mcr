filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/activateLastModifier.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/disableInstancedModifiersOnEdit.ms" )
/*
*	
*/	
macroscript	modifiers_
category:	"_Modifiers"  
buttonText:	"Keep last"
tooltip:	"Keep Active last active modifier"
icon:	"type:checkbox|columns:8"
(
	callbackKillAll()

	if( EventFired.value ) then
		waitForSelectionChangedCallback()
)

/*
*	
*/	
macroscript	modifiers_
category:	"_Modifiers"  
buttonText:	"Keep Edit Poly"
tooltip:	"Keep Active the most top Edit Poly modifier"
icon:	"type:checkbox|columns:8"
(
	callbackKillAll()

	if( EventFired.value ) then
		waitForSelectionChangedCallback()
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
