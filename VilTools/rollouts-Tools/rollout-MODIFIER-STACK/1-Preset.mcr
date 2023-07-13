filein( getFilenamePath(getSourceFileName()) + "/Lib/ModStackPreset/ModStackPreset.ms" )	-- "./Lib/ModStackPreset/ModStackPreset.ms"

/*
*
*/
macroscript	modifier_stact_defaults_save
category:	"_Modifiers"
buttonText:	"Default"
tooltip:	"Save default preset of current object in Modifier Stack"
(
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\1-Preset.mcr"

	max modify mode

	if ( currMod = modPanel.getCurrentObject() ) != undefined then
	(
		--presets = (ModStackPreset( meshsmooth )).getPresets()
		ModStackPreset = ModStackPreset_v(currMod)

		ModStackPreset.savePreset props:(getPropNames currMod)
	)
	else
		messageBox "Please select any modifier in stack" title:"SAVE PRESET ERROR"  beep:false

)

/*
*
*/
macroscript	modifier_stact_defaults_load
category:	"_Modifiers"
buttonText:	"Default"
tooltip:	"Load default preset of current object in Modifier Stack"
(

	--filein( @"c:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIERS\Preset.mcr" )

	if ( currMod = modPanel.getCurrentObject() ) != undefined then
	(
		--presets = (ModStackPreset( meshsmooth )).getPresets()
		ModStackPreset = ModStackPreset_v(currMod)

		ModStackPreset.loadPreset ( ModStackPreset.getPresetName() )
	)
	else
		messageBox "Please select any modifier in stack" title:"SAVE PRESET ERROR"  beep:false


)

/*
*
*/
macroscript	modifier_stact_open_ini
category:	"_Modifiers"
buttonText:	"Open Ini"
tooltip:	"Open Modifier Stack ini ini"
(

	--filein( @"c:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIERS\Preset.mcr" )

	if ( currMod = modPanel.getCurrentObject() ) != undefined then
	(
		--presets = (ModStackPreset( meshsmooth )).getPresets()
		ModStackPreset = ModStackPreset_v(currMod)

		ModStackPreset.openIni()
	)
	else
		messageBox "Please select any modifier in stack" title:"SAVE PRESET ERROR"  beep:false


)
