filein( getFilenamePath(getSourceFileName()) + "/Lib/ModifierPreset/addModifierOrLoadPreset.ms" )	-- "./Lib/ModifierPreset/addModifierOrLoadPreset.ms"

/*
*
*/
macroscript	modifier_defaults_save
category:	"_Modifiers"
buttonText:	"Default"
tooltip:	"Save default preset of current modifier"
(
	--filein( @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIERS ⭐\1-Preset.mcr" )	-- ""

	if ( current_modifier = modPanel.getCurrentObject() ) != undefined then
	(
		--presets = (ModifierPreset_v( meshsmooth )).getPresets()
		ModifierPreset = ModifierPreset_v(current_modifier)

		--ModifierPreset.savePreset props:(getPropNames current_modifier)
	)
	else
		messageBox "Please select any modifier in stack" title:"SAVE PRESET ERROR"  beep:false

)

/*
*
*/
macroscript	modifier_defaults_load
category:	"_Modifiers"
buttonText:	"Default"
tooltip:	"Load default preset of current modifier"
(

	--filein( @"c:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIERS\Preset.mcr" )

	if ( current_modifier = modPanel.getCurrentObject() ) != undefined then
	(
		--presets = (ModifierPreset_v( meshsmooth )).getPresets()
		ModifierPreset = ModifierPreset_v(current_modifier)

		ModifierPreset.loadPreset (( classOf current_modifier ) as string)
	)
	else
		messageBox "Please select any modifier in stack" title:"SAVE PRESET ERROR"  beep:false


)
