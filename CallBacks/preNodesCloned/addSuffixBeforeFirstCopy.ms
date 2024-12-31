/** 
 */
function addSuffixBeforeFirstCopy =
(
	print "addSuffixBeforeFirstCopy()"
	
	/** Get suffix number
	 */
	function getSuffixNumber _string =
	(
		--format "\n"; print ".getSuffixNumber()"
		matches = ( dotNetClass "System.Text.RegularExpressions.RegEx" ).matches _string "[\d]+$"
		--format "matches: %\n" matches
		result	= (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return
		
		if result.count > 0 then
			result[1][1] --return
	)
	
	
	
	--fn sortByName obj_1 obj_2 = stricmp obj_1.name obj_2.name

	delimeter = "-"
	
	nodes	= (callbacks.notificationParam())[1]
	--nodes	= (callbacks.notificationParam())[2]
	--type_id	= (callbacks.notificationParam())[3]

	--type = #( #COPY, #INSTANCE, #REFERENCE )[type_id +1]

	if classOf nodes != Array then
		nodes = #(nodes)
	
	--qsort nodes_old sortByName
	--qsort nodes sortByName
	--
	--format "nodes_old: %\n" nodes_old
	format "nodes: %\n" nodes
	--format "type: %\n" type
	--
	--if type == #COPY and queryBox ("Instance modifiers to new nodes ?") then
	--(
	--	current_panel = getCommandPanelTaskMode()
	--	
	--	max create mode
	--	
		for i = 1 to nodes.count do
		(
			--format "\n"
			--format "source_node: %\n" (getSuffixNumber nodes_old[i].name)
			--format "dest_node: %\n" (getSuffixNumber nodes[i].name)
			--
			--suffix_source = getSuffixNumber nodes_old[i].name
			--suffix   = 
			
			/* IF FIRST COPY */ 
			if getSuffixNumber nodes[i].name == undefined then
				nodes[i].name += delimeter + "01"
			
			
	--		for m = nodes[i].modifiers.count to 1 by -1 do
	--			instanceModifier nodes_old[i] nodes[i] nodes_old[i].modifiers[m] m
	--			
		)
	--
	--	setCommandPanelTaskMode mode:current_panel
	--)
)
