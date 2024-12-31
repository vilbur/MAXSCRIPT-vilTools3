/** 
 */
function instanceModifiersOnCopy =
(
	--print "instanceModifiersOnCopy()"
	
	/** Instance modifier
	 */
	function instanceModifier source_node dest_node _modifier index =
	(

		deleteModifier dest_node index
		
		addModifierWithLocalData dest_node _modifier source_node _modifier before:(index - 1) -- instance the modifier
	)
	
	fn sortByName obj_1 obj_2 = stricmp obj_1.name obj_2.name

	nodes_old	= (callbacks.notificationParam())[1]
	nodes_new	= (callbacks.notificationParam())[2]
	type_id	= (callbacks.notificationParam())[3]

	type = #( #COPY, #INSTANCE, #REFERENCE )[type_id +1]

	qsort nodes_old sortByName
	qsort nodes_new sortByName

	--format "nodes_old: %\n" nodes_old
	--format "nodes_new: %\n" nodes_new
	--format "type: %\n" type
	
	if type == #COPY and queryBox ("Instance modifiers to new nodes ?") then
	(
		current_panel = getCommandPanelTaskMode()
		
		max create mode
		
		for i = 1 to nodes_new.count do
		(
			--format "\n"
			--format "source_node: %\n" (nodes_old[i].name)
			--format "dest_node: %\n" (nodes_new[i].name)
			
			for m = nodes_new[i].modifiers.count to 1 by -1 do
				instanceModifier nodes_old[i] nodes_new[i] nodes_old[i].modifiers[m] m
				
		)

		setCommandPanelTaskMode mode:current_panel
	)
)
