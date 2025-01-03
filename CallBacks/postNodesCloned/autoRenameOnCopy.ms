global CLONED_NODES_TIMER
global CLONED_NODES	-- 2d Matrix of nodes E.G.: #( #(source objects) #(copies 1) #(copies 2) #(copies 3) )

/** Timer callback
 */
function renameNodesTimerCallback =
(
	--format "\n"; print "renameNodesTimerCallback()"
	
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
	
	/** Trim suffix
	 */
	function getBaseName _string = trimRight _string "-0123456789"
	
	function sortByName obj_1 obj_2 = stricmp obj_1.name obj_2.name
	
	/** Get suffix
	 */
	function getSuffix suffix digits =
	(
		--format "\n"; print ".getSuffix()"
		for i = 1 to 3 while suffix.count < digits do 
			suffix = "0" + suffix
		
		suffix --return
	)
	
	delimeter = "-"
	
	/* FLATTERN CLONED_NODES MATRIX */ 
	cloned_nodes_all_used = #()
	
	for i = 2 to CLONED_NODES.count do join cloned_nodes_all_used CLONED_NODES[i]
	
	/* RENAME EACH SOURCE OBJECT */ 
	for x = 1 to CLONED_NODES[1].count do
	(
		nodes_all = for y = 1 to CLONED_NODES.count collect CLONED_NODES[y][x]
		
		source_obj = nodes_all[1]
		
		basename_old = getBaseName source_obj.name
		basename_new = getBaseName nodes_all[2].name
	
		suffix_src = getSuffixNumber source_obj.name
		suffix_new = getSuffixNumber nodes_all[2].name
		--suffix_new = trimLeft suffix_new "0"
		
		same_name_old = (execute ("$'"+basename_old + "'*") as Array )
		same_name_new = (execute ("$'"+basename_new + "'*") as Array )
				
		digits = if same_name_new.count > 99 then 3 else 2
		

		/* DO NOT RENAME SOURCE OBJECT IF COPY HAS NEW NAME */ 
		if basename_old != basename_new then
			deleteItem nodes_all 1
		
		for c = 1 to nodes_all.count do
		(
			suffix_new = getSuffix ( c as string ) digits
			
			new_name = basename_new + delimeter + suffix_new
			
			nodes_all[c].name = new_name
		)
	)
	
	select cloned_nodes_all_used
	
	CLONED_NODES_TIMER.stop()
		
	CLONED_NODES = undefined
	
	CLONED_NODES_TIMER = undefined
)


/** 
 */
function autoRenameOnCopy =
(
	--format "\n\n";	print "autoRenameOnCopy()"
	
	if CLONED_NODES_TIMER == undefined then
	(
		CLONED_NODES_TIMER	= dotNetObject "System.Windows.Forms.Timer"
		
		dotNet.addEventHandler CLONED_NODES_TIMER "tick" renameNodesTimerCallback
		
		CLONED_NODES_TIMER.interval = 500
	)
	else
		CLONED_NODES_TIMER.stop()

	
	if CLONED_NODES == undefined then
		CLONED_NODES = #( (callbacks.notificationParam())[1] ) -- append source nodes as first array

	append CLONED_NODES (callbacks.notificationParam())[2]	
	
	CLONED_NODES_TIMER.start()
)