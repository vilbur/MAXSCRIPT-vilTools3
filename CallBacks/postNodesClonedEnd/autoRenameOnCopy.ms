--global CLONED_NODES	-- 2d Matrix of nodes E.G.: #( #(source objects) #(copies 1) #(copies 2) #(copies 3) )

/** Timer callback
  *
  * @param 2Dmatrix cloned_nodes of nodes E.G.: #( #(source objects) #(copies 1) #(copies 2) #(copies 3) )
  *
  * @param #COPY|#INSTANCE|#REFERENCE clone_type
  *
  *
  
	cloned_nodes = #( "Source-Object", "Copy 1", "Copy 2" )
  
	NAMES OF SOURCE AND COPIES	>>> RENAMED SOURCE AND COPIES
		
	#( "Box", "Box", "Box"	) >>> #( "Box",	"Box", "Box"		)
	#( "Box", " "	) >>> #( "Box",	"Box"		)
	#( "Box", " ", " "	) >>> #( "Box",	"Box-01",	"Box-01"	)
	#( "Box", "Box001"	) >>> #( "Box-01",	"Box-02"		)
	#( "Box", "New-Name"	) >>> #( "Box",	"New-Name" 		)
	#( "Box", "New-Name", "New-Name"	) >>> #( "Box",	"New-Name-01",	"New-Name-02"	)
  
  
 */
function autoRenameOnCopy cloned_nodes clone_type =
(
	format "\n\n";	print "autoRenameOnCopy()"
	--format "cloned_nodes: %\n" cloned_nodes
	
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
		--format "BASENAME_NEW: %\n" basename_new
		
		
		suffix_src = getSuffixNumber source_obj.name
		suffix_new = getSuffixNumber nodes_all[2].name
		--suffix_new = trimLeft suffix_new "0"
		
		--format "suffix_new: %\n" suffix_new
		
		copy_renamed = basename_old != basename_new
		--format "copy_renamed: %\n" copy_renamed
		
		new_name_is_empty = (trimLeft basename_new " ").count == 0
		--format "new_name_is_empty: %\n" new_name_is_empty
		/* DO NOT RENAME SOURCE OBJECT IF COPY HAS NEW NAME */ 
		if copy_renamed then
			deleteItem nodes_all 1
	
		
		if new_name_is_empty then
			basename_new = if CLONED_NODES.count >1 then basename_old else ♥source_obj.name
		

		same_name_old = (execute ("$'"+basename_old + "'*") as Array )
		same_name_new = (execute ("$'"+basename_new + "'*") as Array )
				
		digits = if same_name_new.count > 99 then 3 else 2
		
		
		if nodes_all.count > 1 and suffix_new == undefined and copy_renamed then
			suffix_new = "1"
		
		
		
		if nodes_all.count > 1 then
			for c = 1 to nodes_all.count do
			(
				suffix = if suffix_new != undefined then delimeter + ( getSuffix ( c as string ) digits ) else ""
				
				nodes_all[c].name = basename_new + suffix
			)
		else
			nodes_all[1].name = basename_new
			
		
	)
)


