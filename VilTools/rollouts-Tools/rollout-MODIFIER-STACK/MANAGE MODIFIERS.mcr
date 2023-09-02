


/*------------------------------------------------------------------------------
	SELECT MODIFIERS INSTANCES
--------------------------------------------------------------------------------*/


macroscript	modifiers_select_instrances
category:	"_Modifiers-Manage"
buttontext:	"Select Instances"
toolTip:	"Select objects with instance of current modifier"
--toolTip:	"Turn off \"Show end result\" on subobject edit"
icon:	"MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"
	on execute do
	(
		filein( getFilenamePath(getSourceFileName()) + "/Lib/InstancedModifierFinder/InstancedModifierFinder.ms" )	-- "./Lib/InstancedModifierFinder/InstancedModifierFinder.ms"
		objects_with_mod = (InstancedModifierFinder_v( objects )).getObjectsWithInstance ( modPanel.getCurrentObject() )

		if objects_with_mod.count > 0 then
			select objects_with_mod

		else
			messageBox "There is no objects with this modifier instance" title:"MODIFIER INSTANCE"
	)
)

/**
  *
  */
macroscript	modifiers_copy_name
category:	"_Modifiers-Manage"
buttontext:	"Copy Name"
toolTip:	"Copy Modifier name."-- \n\nOption in menu: Open Dialog"
--toolTip:	"Turn off \"Show end result\" on subobject edit"
icon:	"MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"

	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE_MODIFIERS.mcr"
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModifierRenamer\ModifierRenamer.ms"

		if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
			if (selected_modifiers = (ModifierStackRemote_v()).getSelectedModifiers()).count > 0 then
				setclipboardText selected_modifiers[1].name

	)
	--on altExecute type do
	--(
	--		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE_MODIFIERS.mcr"
	--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModifierRenamer\ModifierRenamer.ms"
	--
	--	--if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
	--		--(ModifierRenamer_v(curr_mod)).renameDialog generate:false
	--)

)

/**
  *
  */
macroscript	modifiers_name
category:	"_Modifiers-Manage"
buttontext:	"Paste Name"
toolTip:	"Paste Modifier name."-- \n\nOption in menu: Open Dialog"
--toolTip:	"Turn off \"Show end result\" on subobject edit"
icon:	"MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"

	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE_MODIFIERS.mcr"
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModifierRenamer\ModifierRenamer.ms"

		if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
		(
			clip_text = getclipboardText()

			if (selected_modifiers = (ModifierStackRemote_v()).getSelectedModifiers()).count > 0 then
				for selected_modifier in selected_modifiers do
					selected_modifiers[1].name = clip_text

		)

			--curr_mod.name = (ModifierRenamer_v(curr_mod)).generateName()
	)
	--on altExecute type do
	--(
	--		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE_MODIFIERS.mcr"
	--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModifierRenamer\ModifierRenamer.ms"
	--
	--	--if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
	--		--(ModifierRenamer_v(curr_mod)).renameDialog generate:false
	--)


)
