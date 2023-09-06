clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../RegExer.ms" )	-- "./../RegExer.ms"



/* GET MATCH */
--matches = (RegExer_v( "foo-111-999" )).getMatches("(\d+)")
--format "MATCHES:	% \n" matches
--
--matches = (RegExer_v( "foo-001" )).getMatches("(.*)-(\d+)")
--format "MATCHES:	% \n" matches
--
/* IS MATCH */
--is_match = (RegExer_v( "foo-001" )).isMatch(".*")
--format "IS_MATCH:	% \n" is_match
--
/* REPALCE */
--replaced = (RegExer_v( "foo-bar" )).replaceInString("bar")("BAZ")
--format "REPLACED:	% \n" replaced


/* REMVOE SUFFIX */
--result = (RegExer_v( "foo-" )).removeSufix()
----format "result:	% \n" result
--format "result:	% \n" (result == "foo")
--
--result = (RegExer_v( "foo-bar_01" )).removeSufix()
--format "result:	% \n" (result == "foo-bar")
--
--result = (RegExer_v( "foo-bar-Test-#01" )).removeSufix()
--format "result:	% \n" (result == "foo-bar-Test")
--
--
--result = (RegExer_v( "foo-bar-Test#01" )).removeSufix delimiters:"#"
--format "result:	% \n" (result == "foo-bar-Test")
--
--((RegExer_v( "foo-bar-Test" )).removeSufix  pattern:"\d+")
--format "result:	% \n" (result == "foo-bar-Test")
--
--
--(RegExer_v( "foo-bar-Test-01")).removeSufix pattern:"\d+"
--format "result:	% \n" (result == "foo-bar-Test")


/*
	EQUIVALENT OF:

	_string	= "foo-bar-Test-#01"
	delimiters	= "-_"
	split	= filterString _string delimiters


	----------- BY REGEX
	if split.count > 1 then
		_string = ( dotNetObject "System.Text.RegularExpressions.Regex"  ( "["+delimiters+ "]"+ split[split.count] + "$") ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase ).Replace _string ""


	----------- BY MAX ELABORATION -- this not allow choose pattern of sufix

	if split.count > 1 then
		_string = trimRight (substring _string 1 (_string.count - split[split.count].count ) ) delimiters

	format "_string:	% \n" _string

*/
