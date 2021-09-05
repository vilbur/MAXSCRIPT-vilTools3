




/** Callbacks on selection change
  
  * Disable modifiers above current pinned modifier
 */
function disableInstancedModifiersOnEdit =
(
	
		Modifiers 	= Modifiers_v()

	
	
	_object =  if( selection.count > 0 ) then 
		selection[1]
	else
		GLOBAL_SELECTION_LAST[1]
	
	modifier_state = selection.count == 0
	
	
	instanced = Modifiers.getInstancedModifiers _object
	
	format "instanced = % \n" instanced
	
	for modifier in _object.modifiers where findItem instanced modifier > 0 do
		modifier.enabled = modifier_state
	


	
	
)