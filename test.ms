clearListener(); print("Cleared in:"+getSourceFileName())

/** Regex is match
  *
  * @return boolean
  */
function rxIsMatch _string pattern ignore_case:true =
(
	RegExDotNet	= ( dotNetClass "System.Text.RegularExpressions.RegEx" )

	IgnoreCase = ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase

	if ignore_case then RegExDotNet.isMatch _string pattern IgnoreCase else  RegExDotNet.isMatch _string pattern
)

/** Regex get match
  */
function rxGetMatch _string pattern ignore_case:true =
(
	RegExDotNet	= ( dotNetClass "System.Text.RegularExpressions.RegEx" )

	IgnoreCase = ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase

	matches = if ignore_case then RegExDotNet.matches _string pattern IgnoreCase else  RegExDotNet.matches _string pattern

	groups = (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return

	if groups.count == 1 then groups[1] else groups


)


/** Regex replace
  */
function rxReplace _string _search _replace ignore_case:true =
(
	RegExDotNet	= ( dotNetClass "System.Text.RegularExpressions.RegEx" )

	IgnoreCaseOption = ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase

	RegExReplace = if ignore_case then ( dotNetObject "System.Text.RegularExpressions.Regex" _search IgnoreCaseOption ) else ( dotNetObject "System.Text.RegularExpressions.Regex" _search )

	RegExReplace.Replace _string _replace
)


input = "fox foo FOO bar 333 999"


--format "isMatch:	% \n" (rxIsMatch input "foo")

format "rxGetMatch:	% \n" (rxGetMatch input "(foo)" )

--format "rxReplace:	% \n" (rxReplace input "foo" "TEST" ignore_case:false )


/* IS MATCH \GET MATCH */
--format "MATCH:	% \n" ((regex input ".*" )	== input )
--format "MATCH:	% \n" ((regex input "\s" )	== " " )
--format "MATCH:	% \n" ((regex input "jumps" )	== "jumps" )
--
--
--/* GET MATCH GROUP */
--format "GROUP:	% \n" ((regex input "([^\s]+)" )	== #( "quick", "fox", "jumps", "over", "foo", "bar" ) )
--
--
--/* GET MATCH MULTIPLE GROUPS */
--
--regex input ".*(foo)" 	-- #(#("foo", "foo"))
--regex input ".*(foo)" ignore_case:false	-- #(#("foo", "foo"))
----
----format "GROUPS:	% \n" ((regex input "(foo)" ignore_case:false )	== #(#( "fox", "foo" )  , #( "bar" )) )
----format "GROUPS:	% \n" ((regex input "(foo)" )	== #(#( "fox", "foo" )  , #( "bar" )) )
----format "GROUPS:	% \n" ((regex input "(foo)" )	== #(#( "fox", "foo" )  , #( "bar" )) )
----format "GROUPS:	% \n" ((regex input "(\d+)" )	== #(#( "fox", "foo" )  , #( "bar" )) )
----format "GROUPS:	% \n" ((regex input ".*(333)\s(999)" )	== #(#( "fox", "foo" )  , #( "bar" )) )