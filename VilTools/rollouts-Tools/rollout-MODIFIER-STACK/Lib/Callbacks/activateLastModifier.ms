
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
			
			index_of_modifier = LAST_MODIFIER_SAVER.modifiers[index_of_node]
			
			if index_of_modifier > 0 then 
				modPanel.setCurrentObject obj.modifiers[index_of_modifier] node:obj
				
			else
				modPanel.setCurrentObject $.baseObject
			
			saveLastModifierStart()
		)
	)
)