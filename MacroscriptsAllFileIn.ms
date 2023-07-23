

all_macro_files = getFiles ( getFilenamePath(getSourceFileName()) + "/VilTools/rollouts-Tools/*.mcr" ) recurse:true  -- "./../../slot_properties.ini"


/** Is not on blacklist
 */
function isNotOnBlacklist macro_path =
(
	--format "\n"; print ".isNotOnBlacklist()"
	blalickst = #( "*/bak*",
				  "*\bak*",
				  "*rollout-OPTIONS\Menus.mcr"
	)

	allow_inport = true

	for pattern in blalickst where matchPattern macro_path pattern:pattern do
	(
		format "\nBLACKLISTED: %\n\n" macro_path

		allow_inport = false

		return false
	 )

	allow_inport --return
)


for macro_path in all_macro_files where isNotOnBlacklist macro_path do
(
	format "filein: % \n" macro_path

	filein macro_path
)