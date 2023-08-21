--filein( getFilenamePath(getSourceFileName()) + "/Lib/ObjectRenamer/ObjectRenamer.ms" )

/*------------------------------------------------------------------------------
	EDIT TEXT
--------------------------------------------------------------------------------*/

/**  SEARCH
  *
  */
macroscript layers_edit_search_in_names
category:	"Layers"
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
macroscript layers_edit_replace_in_names
category:	"Layers"
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
macroscript layers_search_and_replace
category:	"Layers"
buttonText:	"Search & Replace"
tooltip:	"Regex Search & Replace in layer names in selected layers"
icon:	"across:3"
(

	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\ Search And Replace Name.mcr"

	--messageBox "Placeholder" title:""
	format "EventFired	= % \n" EventFired
	LayersManager = LayersManager_v()

	selected_layers = LayersManager.getSelectedOrCurrent()

	undo "Rename Layers" on
		for layer in selected_layers do
		(
			search_text  = ROLLOUT_layers.ET_search_in_name.text
			replace_text = ROLLOUT_layers.ET_replace_in_name.text
			format "search_text	= % \n" search_text
			format "replace_text	= % \n" replace_text

			if search_text != "" then
			try(
				--layer.name = ( dotNetObject "System.Text.RegularExpressions.Regex" search_text ).Replace layer.name replace_text

				layer_renamed =  ( dotNetObject "System.Text.RegularExpressions.Regex" search_text ).Replace layer.name replace_text

				layer.setName layer_renamed

			)catch(
				format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
				format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
				format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
				format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())
			)
				--obj_name = ( dotNetObject "System.Text.RegularExpressions.Regex" "left" ).Replace obj.name "right"
				--format "obj_name	= % \n" obj_name
		)

)
