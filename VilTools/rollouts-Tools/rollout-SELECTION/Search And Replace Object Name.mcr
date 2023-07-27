filein( getFilenamePath(getSourceFileName()) + "/Lib/ObjectRenamer/ObjectRenamer.ms" )

/*------------------------------------------------------------------------------
	EDIT TEXT
--------------------------------------------------------------------------------*/

/**  SEARCH
  *
  */
macroscript selection_edit_search_in_names
category:	"Selection"
buttonText:	"[search in name]"
tooltip:	"Search text in names of selection"
icon:	"control:editText|across:3"
--icon:"offset:[-32,16]"											 -- BUG: offset does not work in groupsbox
(
	format "EventFired	= % \n" EventFired
	--search_text = ROLLOUT_selection.search_in_name.text

	--format "search_text	= % \n" search_text
)

/**  REPlACE
  *
  */
macroscript selection_edit_replace_in_names
category:	"Selection"
buttonText:	"[replace in name]"
tooltip:	"Replace text in names of selection"
icon:	"control:editText|across:3"
(
	format "EventFired	= % \n" EventFired

)

/*------------------------------------------------------------------------------
	BUTTON Search & Replace
--------------------------------------------------------------------------------*/

/**
  *
  */
macroscript selection_search_and_replace
category:	"Selection"
buttonText:	"Search & Replace"
tooltip:	"Search & Replace in names of selection"
icon:	"across:3"
(

	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SELECTION\Search And Replace Object Name.mcr"

	--messageBox "Placeholder" title:""
	format "EventFired	= % \n" EventFired

	for obj in selection do
	(
		search_text  = ROLLOUT_selection.ET_search_in_name.text
		replace_text = ROLLOUT_selection.ET_replace_in_name.text
		--format "search_text	= % \n" search_text
		--format "replace_text	= % \n" replace_text

		if search_text != "" then
			obj.name = ( dotNetObject "System.Text.RegularExpressions.Regex" search_text ).Replace obj.name replace_text
			--obj_name = ( dotNetObject "System.Text.RegularExpressions.Regex" "left" ).Replace obj.name "right"
			--format "obj_name	= % \n" obj_name
	)

)
