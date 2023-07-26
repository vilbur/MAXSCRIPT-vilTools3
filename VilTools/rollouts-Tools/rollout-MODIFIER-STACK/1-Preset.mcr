--filein( getFilenamePath(getSourceFileName()) + "/Lib/ModStackPreset/ModStackPreset.ms" )	-- "./Lib/ModStackPreset/ModStackPreset.ms"

/*
*
*/
macroscript	modifier_stact_defaults_save
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
macroscript	modifier_stact_defaults_load
category:	"_Modifiers"
buttonText:	"Load"
tooltip:	"Load default preset of current object in Modifier Stack"
(

	--filein( @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\1-Preset.mcr" )

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







