--filein( getFilenamePath(getSourceFileName()) + "/Lib/ObjectRenamer/ObjectRenamer.ms" )

/*------------------------------------------------------------------------------
	EDIT TEXT
--------------------------------------------------------------------------------*/

/**  SEARCH
  */
macroscript layers_edit_search_in_names
category:	"_Layers"
buttonText:	"[search in name]"
tooltip:	"Search text in names of selection"
icon:	"control:editText|across:3"
(
	format "EventFired	= % \n" EventFired
)

/**  REPlACE
  */
macroscript layers_edit_replace_in_names
category:	"_Layers"
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
  */
macroscript layers_search_and_replace
category:	"_Layers"
buttonText:	"Search & Replace"
tooltip:	"Regex Search & Replace in layer names in selected layers"
icon:	"across:3"
(

	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-LAYERS\Layers Name.mcr"

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






/*------------------------------------------------------------------------------
	MANAGE LAYERS NAME
--------------------------------------------------------------------------------*/

/**  Rename Dialog
  */
macroscript layers_rename_selected_layers
category:	"_Layers-Name"
buttonText:	"Rename Layers"
tooltip:	"Rename selected layers"
icon:		"MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Layers Name.mcr"

	layer_names_string = ""

	LayersManager = LayersManager_v()

    selected_layers = LayersManager.getSelectedOrCurrent()

	for selected_layer in selected_layers do
	(
		_dotNet	= dotNetObject "MaxCustomControls.RenameInstanceDialog" selected_layer.name
		_dialog_result	= dotNetClass "System.Windows.Forms.DialogResult"

		_dotNet.ShowModal()

		_ok 	= dotNet.comparEenums (_dotNet.DialogResult) ( _dialog_result.Ok )
		_canel	= dotNet.comparEenums (_dotNet.DialogResult) ( _dialog_result.Cancel )

        if( _ok and (_string = _dotNet.InstanceName) != "" and _standroid != selected_layer.name  ) then
	    (
			selected_layer.setName ( _string + "#")

			selected_layer.setName ( trimRight selected_layer.name "#" )
		)
	)
)
/**  Uppercase
  */
macroscript layers_name_case_toggle
category:	"_Layers-Name"
buttonText:	"Upper\Lower Case"
tooltip:	"Toggle selected layers name upprcase\lowercase"
icon:		"MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Layers Name.mcr"

	/** Regex get match
	  */
	function rxGetMatch _string pattern ignore_case:true =
	(
		RegEx	= ( dotNetClass "System.Text.RegularExpressions.RegEx" )

		IgnoreCase = ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase

		matches = if ignore_case then RegEx.matches _string pattern IgnoreCase else RegEx.matches _string pattern

		groups = (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return

		if groups.count == 1 then groups[1] else groups
	)

	layer_names_string = ""

	LayersManager = LayersManager_v()

	selected_layers = LayersManager.getSelectedOrCurrent()

	for layer in selected_layers do layer_names_string += layer.name

	lower_case = rxGetMatch layer_names_string "[a-z]" ignore_case:false
	upper_case = rxGetMatch layer_names_string "[A-Z]" ignore_case:false

	for layer in selected_layers do
	(
		temp_name = ( if upper_case.count > lower_case.count  then toLower layer.name else toUpper layer.name ) + "#"

		layer.setName (temp_name)

		layer.setName ( trimRight layer.name "#" )
	)
)