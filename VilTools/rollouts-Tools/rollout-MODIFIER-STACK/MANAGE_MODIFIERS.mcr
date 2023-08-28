


/*------------------------------------------------------------------------------
	AUTO END RESULT
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
macroscript	modifiers_rename_current
category:	"_Modifiers-Manage"
buttontext:	"Rename"
toolTip:	"Rename current modifier. \n\nOption in menu: Open Dialog"
--toolTip:	"Turn off \"Show end result\" on subobject edit"
icon:	"MENU:true"
(

	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"

	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE_MODIFIERS.mcr"
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModifierRenamer\ModifierRenamer.ms"

		if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
			curr_mod.name = (ModifierRenamer_v(curr_mod)).generateName()
	)
	on altExecute type do
	(
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE_MODIFIERS.mcr"
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModifierRenamer\ModifierRenamer.ms"

		if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
			(ModifierRenamer_v(curr_mod)).renameDialog genrate:false
	)


)