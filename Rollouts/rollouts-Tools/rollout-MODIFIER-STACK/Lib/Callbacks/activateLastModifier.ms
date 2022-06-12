
/** 
  
  1) Save last active modifier of previous selected object on selection change
  
  2) Load last active modifier on newly selected modifier
  
 */
function activateLastModifier =
(
	if selection.count == 1 then
	(
		obj = selection[1]
		
		if (index_of_node = findItem LAST_MODIFIER_SAVER.nodes obj ) > 0 then
		(
			saveLastModifierKill()
			
			_modifier = obj.modifiers[LAST_MODIFIER_SAVER.modifiers[index_of_node]]

			modPanel.setCurrentObject _modifier node:obj
			
			saveLastModifierStart()
		)
	)
)
