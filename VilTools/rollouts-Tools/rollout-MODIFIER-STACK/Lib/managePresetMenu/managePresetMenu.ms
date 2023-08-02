
/** Manage preset menu
 */
function managePresetMenu modifier_class =
(
	--format "\n"; print ".managePresetMenu()"

	if classOf( current_modifier = ( modPanel.getCurrentObject() ) ) == modifier_class then
	(
		Menu = RcMenu_v name:"ManagePresetsMenu"
		--Menu.item ("Save preset")	("savePreset   " + modifier_class as string )
		--Menu.item ("Delete Preset")	("deletePreset " + modifier_class as string )
		--_Modifier = "(ModifierPreset_v("+ modifier_class as string +"))"
		_Modifier = "(ModStackPreset_v("+ modifier_class as string +"))"

		Menu.item ("Save preset")	(_Modifier+".savePresetDialog()")
		Menu.item ("Delete preset")	(_Modifier+".deletePreset()")
		Menu.item ("Open ini file")	(_Modifier+".openIni()")

		popUpMenu (Menu.create())
	)
)
