/** Disable modifiers on edit
 */
function enableModifiersAfterEdit =
(
	print "enableModifiersAfterEdit()"
	
	if( ROLLOUT_modifiers.CHECKBOX_disable_modifiers.state ) then 
		for _modifier in GLOBAL_SELECTION_LAST[1].modifiers do
			_modifier.enabled = true
	
)