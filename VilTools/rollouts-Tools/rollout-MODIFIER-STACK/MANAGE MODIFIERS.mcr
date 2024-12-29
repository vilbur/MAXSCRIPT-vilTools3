

/*------------------------------------------------------------------------------

	ENABLE\DISABLE SELECTED MODIFIERS

--------------------------------------------------------------------------------*/


/** TOGGLE
 */
macroscript	modifiers_toggle_selected
category:	"_Modifiers-Manage"
buttontext:	"Toggle"
toolTip:	"Toggle selected modifiers. \n\nCTRL: Froce ENABLE modifiers. \n\nALT: Froce DIABLE modifiers"
icon:	"MENU:true|title:TOGGLE   Ctrl:on Alt:off"
(
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\CommandPanel\CommandPanel.ms"
		state = case of
		(
			( keyboard.controlPressed):	true
			( keyboard.altPressed):	false
			default:	#toggle
		)
		(ModifierStackRemote_v()).setState ( #SELECTED )( state )
	)
)

/** Copy
 */
macroscript	modifiers_copy_modifier
category:	"_Modifiers-Manage"
buttontext:	"Copy Modifier"
toolTip:	"Copy current modifier"
icon:	"MENU:true"
(
	on execute do
	(
		if( GetCommandPanelTaskMode() != #modify ) then
			max modify mode

		if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
		(

			modPanel.addModToSelection (copy curr_mod)  ui:on

			----addModifierWithLocalData selection[1]  curr_mod selection[1] <modifier index in source stack>
		)
	)
)
--/** Copy
-- */
--macroscript	modifiers_delete
--category:	"_Modifiers-Manage"
--buttontext:	"Delete Modifier"
--toolTip:	"Delete current modifier"
--icon:	"MENU:true"
--(
--	on execute do
--	(
--		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"
--		if( GetCommandPanelTaskMode() != #modify ) then
--			max modify mode
--
--		--if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
--		--(
--		--
--		--	--modPanel.addModToSelection (copy curr_mod)  ui:on
--		--
--		--
--		--
--		--	--addModifierWithLocalData selection[1]  curr_mod selection[1] <modifier index in source stack>
--		--
--		--
--		--)
--	)
--)

/** TOGGLE
 */
macroscript	modifiers_toggle_by_prefix
category:	"_Modifiers-Manage"
buttontext:	"Toggle by Prefix"
toolTip:	"Toggle selected modifiers. \n\nCTRL: Froce ENABLE modifiers. \n\nALT: Froce DIABLE modifiers"
icon:	"MENU:true|title:TOGGLE"
(
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"

		if (selected_modifiers = (ModifierStackRemote_v()).getSelectedModifiers()).count > 0 then
		(
			if (mod_name_split = filterString (selected_modifiers[1].name) "-_ ").count > 0 then
			(
				mods_by_prefix = #()

				for obj in selection do
					for _mod in obj.modifiers where matchPattern _mod.name pattern:( mod_name_split[1] + "*" ) do
						appendIfUnique mods_by_prefix _mod

				state = not mods_by_prefix[1].enabled

				for _mod in mods_by_prefix do _mod.enabled = state

				modPanel.setCurrentObject( modPanel.getCurrentObject() )

			)
		)
	)
)

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
		max modify mode

		filein( getFilenamePath(getSourceFileName()) + "/Lib/InstancedModifierFinder/InstancedModifierFinder.ms" )	-- "./Lib/InstancedModifierFinder/InstancedModifierFinder.ms"

		objects_with_mod = (InstancedModifierFinder_v( objects )).getObjectsWithInstance ( modPanel.getCurrentObject() )

		if objects_with_mod.count > 0 then
			select objects_with_mod

		else
			messageBox "There is no objects with this modifier instance" title:"MODIFIER INSTANCE"
	)
)

macroscript	modifiers_select_modifiers_by_same_name
category:	"_Modifiers-Manage"
buttontext:	"Select By Name"
toolTip:	"Select objects with modifier of same name as current modifier"
--toolTip:	"Turn off \"Show end result\" on subobject edit"
icon:	"MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"
	on execute do
	(
		max modify mode

		objs_with_mods = #()

		if ( _mod = modPanel.getCurrentObject() ) != undefined then
		(
			mod_name = _mod.name

			for obj in objects where not obj.isHidden and obj.modifiers[mod_name] != undefined do
				append objs_with_mods obj

			if objs_with_mods.count > 0 then
				select objs_with_mods
		)

	)
)

macroscript	modifiers_delete_modifiers_by_same_name
category:	"_Modifiers-Manage"
buttontext:	"Delete By Name"
toolTip:	"Delete modifiers of same name as current modifier from visible objects"
--toolTip:	"Turn off \"Show end result\" on subobject edit"
icon:	"MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"
	on execute do
	(
		max modify mode

		objs_with_mods = #()

		if ( _mod = modPanel.getCurrentObject() ) != undefined \
		and  queryBox ( "Delete modifier from visible objects ?\n\n" + (mod_name = _mod.name ) ) title:"DELETE MODIFIER" then
		(
			for obj in objects where not obj.isHidden and (mod_found = obj.modifiers[mod_name]) != undefined do
				deleteModifier obj mod_found
				--append objs_with_mods obj

			--if objs_with_mods.count > 0 then
			--	select objs_with_mods
		)

	)
)


macroscript	modifiers_instance_modifiers_on_obj_copy_callback
category:	"_Modifiers-Manage"
buttontext:	"Delete By Name"
toolTip:	""
icon:	"control:checkbox|across:1|autorun:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"
	on execute do
	(
		max modify mode

		objs_with_mods = #()

		if ( _mod = modPanel.getCurrentObject() ) != undefined \
		and  queryBox ( "Delete modifier from visible objects ?\n\n" + (mod_name = _mod.name ) ) title:"DELETE MODIFIER" then
		(
			for obj in objects where not obj.isHidden and (mod_found = obj.modifiers[mod_name]) != undefined do
				deleteModifier obj mod_found
				--append objs_with_mods obj

			--if objs_with_mods.count > 0 then
			--	select objs_with_mods
		)

	)
)