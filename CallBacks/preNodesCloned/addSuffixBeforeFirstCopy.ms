/** 
 */
function addSuffixBeforeFirstCopy =
(
	--print "addSuffixBeforeFirstCopy()"
	
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
	
	delimeter = "-"
	
	nodes	= callbacks.notificationParam()

	for i = 1 to nodes.count do
	(
		if getSuffixNumber nodes[i].name == undefined then
			nodes[i].name += delimeter + "01"
	)
)