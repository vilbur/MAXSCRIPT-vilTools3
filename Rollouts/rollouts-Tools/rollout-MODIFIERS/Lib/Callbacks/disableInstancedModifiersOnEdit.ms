




/** Callbacks on selection change
  
  * Disable modifiers above current pinned modifier
 */
function disableInstancedModifiersOnEdit =
(
	
		Modifiers 	= Modifiers_v()

	
	
	_obj =  if( selection.count > 0 ) then 
		selection[1]
	else
		GLOBAL_SELECTION_LAST[1]
	
	
	modifier_state = selection.count == 0
	
	instanced = Modifiers.getInstancedModifiers _obj
	
	format "instanced = % \n" instanced
	
	for _modifier in _obj.modifiers where findItem instanced _modifier > 0 do
		_modifier.enabled = modifier_state
	


	
	
)