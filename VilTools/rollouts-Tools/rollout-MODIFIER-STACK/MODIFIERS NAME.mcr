
/* USE

	"./Lib/CommandPanel/CommandPanel.ms"

*/


/*------------------------------------------------------------------------------
	RENAME MODIFIERS
--------------------------------------------------------------------------------*/

/**
  */
macroscript	modifiers_rename_current_dialog
category:	"_Modifiers-Name"
buttontext:	"Rename"
--tooltip:	"Rename current modifier dialog. \n\nOption in menu: Open Dialog"
tooltip:	"Rename current modifier dialog."
icon:	"MENU:Rename • CTRL: Reset name|across:3"
autoUndoEnabled: true
(
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MODIFIERS NAME.mcr"
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModifierRenamer\ModifierRenamer.ms"
		if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
			(ModifierRenamer_v(curr_mod)).renameDialog generate:keyboard.controlPressed
	)
)

/**
  */
macroscript	modifiers_rename_current
category:	"_Modifiers-Name"
buttontext:	"Generate Name"
tooltip:	"Generate name for current modifier."
icon:	"MENU:true|title:GENERATE Name"
autoUndoEnabled: true
(
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MODIFIERS NAME.mcr"
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModifierRenamer\ModifierRenamer.ms"
		if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
			curr_mod.name = (ModifierRenamer_v(curr_mod)).generateName()
	)
)



/** UPPERCASE NAME
  */
macroscript	modifiers_rename_current_to_uppercase
category:	"_Modifiers-Name"
buttontext:	"Uppercase Name"
tooltip:	"Uppercase modifier name."
icon:	"MENU:true"
autoUndoEnabled: true
(
	on execute do
	(
		if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
			curr_mod.name = toUpper curr_mod.name
	)
)


/** COPY NAME
  */
macroscript	modifiers_copy_name
category:	"_Modifiers-Name"
buttontext:	"Copy Name"
tooltip:	"Copy Modifier name.\n\nIf clipboard contain Modifier name"
icon:	"MENU:true"
autoUndoEnabled: true
(
	on execute do
	(
		if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
			if (selected_modifiers = (ModifierStackRemote_v()).getSelectedModifiers()).count > 0 then
				setclipboardText selected_modifiers[1].name
	)
)

/** PASTE NAME
  */
macroscript	modifiers_paste_name
category:	"_Modifiers-Name"
buttontext:	"Paste Name"
tooltip:	"Paste Modifier name."
icon:	"MENU:true"
autoUndoEnabled: true
(
	on execute do
	(
		if ( curr_mod = modPanel.getCurrentObject() ) != undefined and (clip_text = getclipboardText()) != undefined then
		(
			if (selected_modifiers = (ModifierStackRemote_v()).getSelectedModifiers()).count > 0 then
				for selected_modifier in selected_modifiers do
					selected_modifiers[1].name = clip_text
		)
	)

)
