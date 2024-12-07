--filein( getFilenamePath(getSourceFileName()) + "/../../../../../../MAXSCRIPT-UI-framework/Lib/Menus/RcMenu/RcMenu.ms" )	--"./../../../../../../MAXSCRIPT-UI-framework/Lib/Menus/RcMenu/RcMenu.ms"


/** Manage preset menu
 */
function managePresetMenu _modifier =
(
	format "\n"; print "managePresetMenu()"
	max modify mode
	
	ModStackPreset = ModStackPreset_v( _modifier )

	format "HAS PRESET: \"%\"\n" (ModStackPreset.hasPreset())

	modifier_class = classOf _modifier
	format "modifier_class: %\n" modifier_class

	if classOf( current_modifier = ( modPanel.getCurrentObject() ) ) == modifier_class then
	(
		Menu = RcMenu_v name:"ManagePresetsMenu"

		
		if not ModStackPreset.hasPreset() then
			ModStackPreset.saveDefaultPreset()

		
		
		
		ModStackPresetString  = "(ModStackPreset_v("+ modifier_class as string +"))"

		--Menu.item ("Save preset")	(ModStackPresetString +".savePresetDialog()")
		--Menu.item ("Delete preset")	(ModStackPresetString +".deletePreset()")
		--Menu.item ("Open ini file")	(ModStackPresetString +".openIni()")

		--if ModStackPreset.hasPreset() then
			--for preset_name in (presets = ModStackPreset.getPresets()) do 
			for preset_name in ModStackPreset.getPresets() do 
				Menu.item ("Load preset: " + preset_name )	(ModStackPresetString +".loadPreset preset:\""+preset_name+"\" rename:true")
		
		popUpMenu (Menu.create())
		
	)
)
