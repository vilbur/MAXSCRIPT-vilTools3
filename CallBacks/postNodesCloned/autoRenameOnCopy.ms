/** 
 */
function autoRenameOnCopy =
(
	format "\n\n";	print "autoRenameOnCopy()"
	
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
	
	nodes_old	= (callbacks.notificationParam())[1]
	nodes_new	= (callbacks.notificationParam())[2]
	type_id	= (callbacks.notificationParam())[3]

	--format "nodes_old.count: %\n" nodes_old.count
	--format "nodes_new.count: %\n" nodes_new.count
	
	qsort nodes_old sortByName
	qsort nodes_new sortByName

	--format "nodes_old: %\n" nodes_old
	--format "nodes_new: %\n" nodes_new
	
	for i = 1 to nodes_new.count do
	(

		basename_old = getBaseName nodes_old[i].name
		basename_new = getBaseName nodes_new[i].name

		suffix_src = getSuffixNumber nodes_old[i].name
		suffix_new = getSuffixNumber nodes_new[i].name
		--format "suffix_src: %\n" suffix_src
		--format "suffix_new: %\n" suffix_new
		--basenames_matching = matchPattern nodes_old[i].name pattern:( basename_new + "*")
		--format "basenames_matching: %\n" basenames_matching
		--
		suffix_new = trimLeft suffix_new "0"
		
		same_name_old = (execute ("$'"+basename_old + "'*") as Array )
		same_name_new = (execute ("$'"+basename_new + "'*") as Array )
		
		digits = if same_name_new.count > 99 then 3 else 2

		if same_name_new.count > 1 then
		(
			append same_name_new nodes_new[i]
			
			same_name_new = makeUniqueArray same_name_new
			
			
			for c = 1 to same_name_new.count do
			(
				suffix_new = getSuffix ( c as string ) digits
				
				new_name = basename_new + delimeter + suffix_new
				
				same_name_new[c].name = new_name
				
				--same_name_new[c].name = basename_new + delimeter + "0" + c as string
			)
		)
			
		--/* IF FIRST COPY OF SAME NAME */ 
		--if suffix_src == undefined and suffix_new != undefined and basenames_matching then
		--(
		--
		--	
		--	
		--	--if suffix_src.count > suffix_new.count then
		--	--(
		--	--	suffix_new = getSuffix suffix_new 2
		--	--	
		--	--	nodes_new[i].name = basename_new + delimeter + suffix_new
		--	--)
		--)
		--/* IF COPY HAS DIFERENT NAME THAN SOURCE */ 
		--else if not basenames_matching then
		--(
		--	same_name_old = (execute ("$'"+basename_old + "'*") as Array )
		--	same_name_new = (execute ("$'"+basename_new + "'*") as Array )
		--
		--	if same_name_new.count > 1 then
		--	(
		--		append same_name_new nodes_new[i]
		--		
		--		same_name_new = makeUniqueArray same_name_new
		--		
		--		for c = 1 to same_name_new.count do
		--		(
		--			
		--			suffix_new = getSuffix ( c as string ) 2
		--
		--			
		--			new_name = basename_new + delimeter + suffix_new
		--			
		--			same_name_new[c].name = new_name
		--			
		--			
		--			--same_name_new[c].name = basename_new + delimeter + "0" + c as string
		--		)
		--	)
		--)
	)
)



