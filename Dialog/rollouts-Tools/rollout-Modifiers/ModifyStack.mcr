/*
*	
*/	
macroscript	modifiers_disable_on_edit_pinned
category:	"_Modifiers"  
buttonText:	"Disable on edit"
tooltip:	"Disable modifiers above current pinned modifier if suobject != 0"
icon:	"type:checkbox"
(
	if( EventFired.value ) then 
		CallbacksHolder.start #SelectionSetChanged "selectionSetChangedCallback"
	else
		CallbacksHolder.kill  #SelectionSetChanged "selectionSetChangedCallback"
)