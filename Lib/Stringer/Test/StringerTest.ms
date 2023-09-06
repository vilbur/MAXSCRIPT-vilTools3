clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../Stringer.ms" )	-- "./../Stringer.ms"




--matches = (Stringer_v( "foo-111-999" )).getMatches("(\d+)")
--format "MATCHES:	% \n" matches
--
--matches = (Stringer_v( "foo-001" )).getMatches("(.*)-(\d+)")
--format "MATCHES:	% \n" matches
--
--is_match = (Stringer_v( "foo-001" )).isMatch(".*")
--format "IS_MATCH:	% \n" is_match
--
--replaced = (Stringer_v( "foo-bar" )).replaceInString("bar")("BAZ")
--format "REPLACED:	% \n" replaced


(Stringer_v( "foo-" )).removeSuffix()
(Stringer_v( "foo-bar_01" )).removeSuffix()= "foo-bar-Test"
(Stringer_v( "foo-bar-Test-#01" )).removeSuffix()	== "foo-bar-Test"
(Stringer_v( "foo-bar-Test#01" )).removeSuffix delimiters:"#"	== "foo-bar-Test"

--((Stringer_v( "foo-bar-Test" )).removeSuffix  pattern:"\d+")	== "foo-bar-Test"
--(Stringer_v( "foo-bar-Test-01")).removeSuffix pattern:"\d+"	== "foo-bar-Test"


/*
	EQUIVALENT OF:

	_string	= "foo-bar-Test-#01"
	delimiters	= "-_"
	split	= filterString _string delimiters


	----------- BY REGEX
	if split.count > 1 then
		_string = ( dotNetObject "System.Text.RegularExpressions.Regex"  ( "["+delimiters+ "]"+ split[split.count] + "$") ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase ).Replace _string ""


	----------- BY MAX ELABORATION -- this not allow choose pattern of suffix

	if split.count > 1 then
		_string = trimRight (substring _string 1 (_string.count - split[split.count].count ) ) delimiters

	format "_string:	% \n" _string

*/
--
--_string	= ( dotNetClass "System.Text.RegularExpressions.RegEx" "pattern" ).Replace _string "replace"
--
--RegEx	= ( dotNetClass "System.Text.RegularExpressions.RegEx" )
--
--matches = RegEx.matches _string ".*" ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase
--result	= (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return

