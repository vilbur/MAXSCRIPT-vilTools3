clearListener(); print("Cleared in:\n"+getSourceFileName())


TimerObject	= dotNetObject "System.Windows.Forms.Timer"

/*------------------------------------------------------------------------------
	TIMER A
--------------------------------------------------------------------------------*/
_time_A = 1

/** Timer callback
 */
function timerCallbackA =
(
	--format "\n"; print "timerCallbackA()"
	format "timerCallbackA	= % \n" _time_A
	
	_time_A += 1
	
	if _time_A == 10 then 
		TimerObject.stop()
)


dotNet.addEventHandler TimerObject "tick" timerCallbackA

TimerObject.interval = 500

TimerObject.start()


--	/** Get suffix number
--	 */
--	function getSuffixNumber _string =
--	(
--		--format "\n"; print ".getSuffixNumber()"
--		matches_suffix = ( dotNetClass "System.Text.RegularExpressions.RegEx" ).matches _string "([\d]+)$"
--		format "matches: %\n" matches
--		
--		if matches_suffix.count > 0 then
--			suffix = matches_suffix.item[0].groups.item[0].value
--			
--		if suffix != undefined then
--		(
--			format "SUFFIX: %\n" suffix
--			matches = ( dotNetClass "System.Text.RegularExpressions.RegEx" ).matches _string ("(.*)-("+suffix+")$")
--
--			--format "ITEM: %\n" matches_suffix.item[0].groups.item[0].value
--			
--			result	= (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return
--			
--			format "result: %\n" result
--			if result.count > 0 then
--				result --return
--				--result[1][1] --return
--			
--			
--		)
--	)
--	
--
--trimRight "obj_A-0023" "-0123456789"
--
----getSuffixNumber "obj_A-001"
----getSuffixNumber "obj_A002"
----getSuffixNumber "obj_A-3"
----getSuffixNumber "asdfas"