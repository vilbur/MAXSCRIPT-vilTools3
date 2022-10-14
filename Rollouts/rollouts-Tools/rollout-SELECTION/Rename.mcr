--filein( getFilenamePath(getSourceFileName()) + "/Lib/ObjectRenamer/ObjectRenamer.ms" )

/**  
  *	
  */
macroscript selection_name_convert_case_sence
category:	"Selection"
buttonText:	"Convert Case"
tooltip:	"Convert case sense of selected object names"
--icon:	"control:checkbox|Groupbox:Prefix|across:1"
(
	filein( @"c:\GoogleDrive\Programs\CG\3DsMax\scripts\vilTools3\Rollouts\rollouts-Tools\rollout-SELECTION\Rename.mcr" ) -- DEV

	for obj in selection do 
	(
		----obj_name = obj.name
		RX = ( dotNetClass "System.Text.RegularExpressions.RegEx" )
		has_lowercase = (RX.match obj.name "[a-z]").success
		has_uppercase = (RX.match obj.name "[A-Z]").success
	
		if has_lowercase and not has_uppercase then -- if "lower case" then "Capital Case"
		(
			capital_string	= ""
			delimeters	= "-_, "

			test_delimeters	= RX.matches obj.name ("["+delimeters+"]") ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase 
			delimeters_match	= (for matchIdx = 0 to test_delimeters.count-1 collect for groupIdx = 0 to test_delimeters.item[matchIdx].groups.count-1 collect ( test_delimeters.item[matchIdx].groups.item[groupIdx].value )) --return
			
			delimeter = if delimeters_match.count > 0 then delimeters_match[1][1] else ""
			
			for word in (filterString obj.name delimeters) do
				capital_string += replace word 1 1 ( toUpper word[1]) + delimeter

			obj.name = trimRight capital_string delimeter
		)
		else if has_uppercase and not has_lowercase then -- if "lower case" then "Capital Case"
			obj.name = toLower obj.name
		
		else if has_lowercase and has_uppercase then 
			obj.name = toUpper obj.name
	)
	
)

--function regexGetMatches string pattern ignorecase:true =
--(
--	rx         = dotNetClass "System.Text.RegularExpressions.RegEx"
--	rx_options	= dotNetClass "System.Text.RegularExpressions.RegexOptions"
--	
--	matches = if (ignorecase) then rx.matches string pattern rx_options.IgnoreCase else rx.matches string pattern 
--	
--	(for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return
--),

/*------------------------------------------------------------------------------
	GROUPBOX PREFIX
--------------------------------------------------------------------------------*/

--/**  
--  *	
--  */
--macroscript selection_edit_name_prefix_by_parent
--category:	"Selection"
--buttonText:	"by parent"
--tooltip:	""
--icon:	"control:checkbox|Groupbox:Prefix|across:1"
--(
--	
--)
--
--/**  
--  *	
--  */
--macroscript selection_edit_name_prefix_by_layer
--category:	"Selection"
--buttonText:	"by layer"
--tooltip:	""
--icon:	"control:checkbox|Groupbox:Prefix|across:1"
--(
--	
--)




--/**  
--  *	
--  */
--macroscript selection_edit_name
--category:	"Selection"
--buttonText:	"[Object base name]"
--tooltip:	"original name is used, if name is empty"
--icon:	"control:editText|Groupbox:Base Name|across:1"
----icon:"offset:[-32,16]" -- BUG: offset does not work in groupsbox
--(
--	
--)

/*------------------------------------------------------------------------------
	SUFFIX
--------------------------------------------------------------------------------*/

--macroscript selection_edit_name_suffix_by_parent
--category:	"Selection"
--buttonText:	"A-Z"
--tooltip:	""
--icon:	"control:checkbox|Groupbox:Suffix|across:1"
--(
--	
--)
--
--
--/**  
--  *	
--  */
--macroscript selection_rename
--category:	"Selection"
--buttonText:	"Rename"
--tooltip:	"Load Selection"
--icon:	"across:1|height:48"
--(
--	
--	ObjectRenamer = ObjectRenamer_v()
--	
--	_selection = selection
--	
--	ObjectRenamer.rename _selection
--		
--	select _selection
--)
