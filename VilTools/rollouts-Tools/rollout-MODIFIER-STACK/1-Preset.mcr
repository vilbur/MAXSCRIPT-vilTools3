filein( getFilenamePath(getSourceFileName()) + "/Lib/ModStackPreset/ModStackPreset.ms" )	-- "./Lib/ModStackPreset/ModStackPreset.ms"

/*
*
*/
macroscript	modifier_stact_preset_save
category:	"_Modifiers"
buttonText:	"Save"
tooltip:	"Save default preset of current object in Modifier Stack"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\1-Preset.mcr"

	max modify mode

	if ( currMod = modPanel.getCurrentObject() ) != undefined then
	(
		--presets = (ModStackPreset( meshsmooth )).getPresets()
		ModStackPreset = ModStackPreset_v(currMod)

		if queryBox ("Save preset ?\n\n\""+ModStackPreset.preset_name+"\"") title:"SAVE STACK PRESET"  then
			ModStackPreset.savePreset props:(getPropNames currMod)

		--messageBox "Preset saved" title:"PRESET SAVE"
	)
	else
		messageBox "Please select any item in modifier stack" title:"MODIFIER STACK PRESET"  beep:false

)

/*
*
*/
macroscript	modifier_stact_preset_load
category:	"_Modifiers"
buttonText:	"Load"
tooltip:	"Load default preset of current object in Modifier Stack"
(

	--filein( @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\1-Preset.mcr" )
	max modify mode

	if ( currMod = modPanel.getCurrentObject() ) != undefined then
	(
		--presets = (ModStackPreset( meshsmooth )).getPresets()
		ModStackPreset = ModStackPreset_v(currMod)

		if queryBox ("Load preset ?\n\n\""+ModStackPreset.preset_name+"\"") title:"LOAD STACK PRESET"  then
			ModStackPreset.loadPreset ( ModStackPreset.preset_name )
	)
	else
		messageBox "Please select any item in modifier stack" title:"MODIFIER STACK PRESET"  beep:false
)
/*
*
*/
macroscript	modifier_stact_preset_load_menu
category:	"_Modifiers"
buttonText:	"Load"
tooltip:	"Load preset menu"
(

	--filein( @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\1-Preset.mcr" )
	max modify mode

	--if classOf( current_modifier = ( modPanel.getCurrentObject() ) ) == currMod then

	if ( currMod = modPanel.getCurrentObject() ) != undefined then
	(
		Menu = RcMenu_v name:"ManagePresetsMenu"


		ModStackPreset = "(ModStackPreset_v("+ classOf currMod as string +"))"

		Menu.item ("Save preset")	(ModStackPreset+".savePresetDialog()")
		Menu.item ("Delete preset")	(ModStackPreset+".deletePreset()")
		Menu.item ("Open ini file")	(ModStackPreset+".openIni()")

		popUpMenu (Menu.create())
	)

)

/*
*
*/
macroscript	modifier_stact_open_ini
category:	"_Modifiers"
buttonText:	"Open Ini"
tooltip:	"Open ini file"
(

	--filein( @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\1-Preset.mcr" )
	max modify mode

	if ( currModObj = modPanel.getCurrentObject() ) != undefined then
	(

		if superClassOf currModObj != modifier then
			currModObj = selection[1].baseobject

		ModStackPreset = ModStackPreset_v(currModObj)

		if doesFileExist ModStackPreset.ini then
			DOSCommand ("start \"\" \""+ModStackPreset.ini+"\"")

		--ModStackPreset.openIni()
	)
	else
		messageBox "Please select any item in modifier stack" title:"MODIFIER STACK PRESET"  beep:false

)

/*
*
*/
macroscript	modifier_stact_open_ini_folder
category:	"_Modifiers"
buttonText:	"Open Ini"
tooltip:	"Openini file folder"
(

	--filein( @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\1-Preset.mcr" )
	max modify mode

	if ( currModObj = modPanel.getCurrentObject() ) != undefined then
	(
		if superClassOf currModObj != modifier then
			currModObj = selection[1].baseobject

		ModStackPreset = ModStackPreset_v(currModObj)


		if doesFileExist ModStackPreset.ini_dir then
			DOSCommand ("start \"\" \""+ModStackPreset.ini_dir+"\"")
	)
	else
		messageBox "Please select any item in modifier stack" title:"MODIFIER STACK PRESET"  beep:false

)

--fn printObjName obj callback =
--(
--	format "%: %\n" callback obj.name
--)

/* TEST
*
*/
macroscript	modifier_stact_test
category:	"_Modifiers"
buttonText:	"Test"
tooltip:	"Test"
(

	clearListener()
	filein( @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\1-Preset.mcr" )
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModStackPreset\ModStackPreset.ms"
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\CallBacks\preModifierAdded\loadModifierDefaults.ms"
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\CallBacks\postModifierAdded\prependPolySelectModifier.ms"
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\CallBacks\postModifierAdded\activatePolySelectModifier.ms"
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\CallBacks\nodeCreated\setDefaultPropertiesToObject.ms"


	CALLBACKMANAGER.add "setDefaultPropertiesToObject"	#nodeCreated
	CALLBACKMANAGER.add "loadModifierDefaults"	#preModifierAdded
	CALLBACKMANAGER.add "prependPolySelectModifier"	#postModifierAdded


	--callbacks.removeScripts  id:#newObjs
	--callbacks.addScript #nodeCreated "printObjName (callbacks.notificationParam()) #nodeCreated" id:#newObjs
	--callbacks.addScript #sceneNodeAdded "printObjName (callbacks.notificationParam()) #sceneNodeAdded" id:#newObjs



)
