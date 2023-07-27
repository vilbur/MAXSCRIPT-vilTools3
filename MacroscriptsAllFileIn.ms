/*

	THIS CODE SHOULD BE IN STRUCT PLACED ELSEWHERE

*/


all_macro_files = getFiles ( getFilenamePath(getSourceFileName()) + "/VilTools/rollouts-Tools/*.mcr" ) recurse:true  -- "./../../slot_properties.ini"


--global DEBUG_PRINT = true
global DEBUG_PRINT = false

/** Is not on blacklist
 */
function isNotOnBlacklist macro_path =
(
	--format "\n"; print ".isNotOnBlacklist()"
	--format "macro_path = % \n" macro_path

	blalickst = #( "*/bak*",
				  "*\\bak*",
				  "*-UNUSED*",
				  "*rollout-OPTIONS\Menus.mcr"
	)

	allow_inport = true

	for pattern in blalickst where matchPattern macro_path pattern:pattern do
	(
		if DEBUG_PRINT then
			format "\nBLACKLISTED: %\n\n" macro_path

		allow_inport = false

		return false
	 )

	allow_inport --return
)


for macro_path in all_macro_files where isNotOnBlacklist macro_path do
(
	--if DEBUG_PRINT then
	--	format "filein: % \n" macro_path

	try(
		(ScriptFile_Content_v(macro_path)).importMacroscriptsToMenus()
	)catch(

		format "!!!!! FILEIN *.mcr file ERROR\n\n%\n\n" (getCurrentException())
	)
)


DEBUG_PRINT = undefined
