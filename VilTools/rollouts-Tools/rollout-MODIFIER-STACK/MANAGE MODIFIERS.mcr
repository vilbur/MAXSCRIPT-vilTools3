
--global ASK_FOR_INSTANCE

/** 
  *	
  */
macroscript	modifiers_auto_instance
category:	"_Modifiers-Manage"
buttontext:	"INSTANCE MODIFIERS ON OBJECT COPY"
toolTip:	"Ask for instance modifiers on object copy"
icon:	"control:checkbox|MENU:true|across:1|offset:[0,8]|align:#CENTER|AUTORUN:TRUE"
(
	--on IsChecked do ASK_FOR_INSTANCE != undefined

	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\CallBacks\postNodesCloned\instanceModifiersOnCopy.ms"
		
		--if ASK_FOR_INSTANCE == undefined or ( EventFired != undefined and EventFired.val ) then
		if EventFired == undefined or ( EventFired != undefined and EventFired.val ) then
		(
			CALLBACKMANAGER.start "instanceModifiersOnCopy" --"./../../../CallBacks/postNodesCloned/instanceModifiersOnCopy.ms"
	
			--ASK_FOR_INSTANCE = true
		)
		else
		(
			CALLBACKMANAGER.kill "instanceModifiersOnCopy"
	
			--ASK_FOR_INSTANCE = undefined
		)
	)
)


/*------------------------------------------------------------------------------

	ENABLE\DISABLE SELECTED MODIFIERS

--------------------------------------------------------------------------------*/


/** TOGGLE
 */
macroscript	modifiers_toggle_selected
category:	"_Modifiers-Manage"
buttontext:	"ON\OFF"
toolTip:	"Toggle selected modifiers. \n\nCTRL: Froce ENABLE modifiers. \n\nALT: Froce DIABLE modifiers"
icon:	"MENU:true|across:4|offset:[0,8]|title:TOGGLE   Ctrl:on Alt:off"
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
buttontext:	"ON\OFF Prefix"
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

macroscript	modifiers_select_modifiers_by_same_name
category:	"_Modifiers-Manage"
buttontext:	"Select By Name"
toolTip:	"Select objects with modifier of same name as current modifier"
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


/* SELECT MODIFIERS INSTANCES
*/ 
macroscript	modifiers_select_instrances
category:	"_Modifiers-Manage"
buttontext:	"Select INSTANCES"
toolTip:	"Select objects with instance of current modifier"
icon:	"MENU:true|across:3"
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

/* SELECT MODIFIERS INSTANCES
*/ 
macroscript	modifiers_reinstrance
category:	"_Modifiers-Manage"
buttontext:	"REINSTANCE"
toolTip:	"Reinstance modifiers on selection by\n\n    LAST OBJECT"
icon:	"MENU:true"
(
	print "instanceModifiersOnCopy()"
	
	on execute do
	(
		with redraw off
		(
		
			master_object	= selection[ selection.count ]
		
			for_replace = deleteItem ( selection as Array ) selection.count
			
			--format "master_object: %\n" master_object
			--format "for_replace: %\n" for_replace
			if queryBox ("Instance modifiers to nodes ?\n\nSOURCE: "+master_object.name) then
			(
				current_panel = getCommandPanelTaskMode()
				
				max create mode
				--max modify mode
		
				for dest_node in for_replace do 
					for m = dest_node.modifiers.count to 1 by -1 do
						deleteModifier dest_node m
		
		
				
				for i = 1 to for_replace.count do
					for m = master_object.modifiers.count to 1 by -1 do
						addModifier for_replace[i] master_object.modifiers[m] --before:(index - 1)
		
						--instanceModifier master_object for_replace[i] master_object.modifiers[m] m
		
				setCommandPanelTaskMode mode:current_panel
			)
			
		)
		
		redrawViews()
	)
)

macroscript	modifiers_modifiers_make_unique_group
category:	"_Modifiers-Manage"
buttontext:	"Make UNIQUE"
toolTip:	"GROUP modifiers in selection"
icon:	"MENU:true|tooltip:MAKE SELECTED MODIFIERS UNIQUE"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"
		
		ModifierStack = ModifierStackRemote_v()

		modifiers = ModifierStack.getSelectedModifiers()

		InstanceMgr.MakeModifiersUnique ( selection as Array ) modifiers #group -- {#prompt|#individual|#group}
	)
)

macroscript	modifiers_modifiers_make_unique
category:	"_Modifiers-Manage"
buttontext:	"Make UNIQUE"
toolTip:	"UNIQUE FOR EACH OBJECT"
--toolTip:	"Turn off \"Show end result\" on subobject edit"
icon:	"MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"
		
		ModifierStack = ModifierStackRemote_v()

		modifiers = ModifierStack.getSelectedModifiers()

		format "MODIFIERS: %\n" MODIFIERS
		
		InstanceMgr.MakeModifiersUnique ( selection as Array ) modifiers #individual -- {#prompt|#individual|#group}

	)
)





--macroscript	modifiers_delete_modifiers_by_same_name
--category:	"_Modifiers-Manage"
--buttontext:	"Delete By Name"
--toolTip:	"Delete modifiers of same name as current modifier from visible objects"
----toolTip:	"Turn off \"Show end result\" on subobject edit"
--icon:	"MENU:true"
--(
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"
--	on execute do
--	(
--		max modify mode
--
--		objs_with_mods = #()
--
--		if ( _mod = modPanel.getCurrentObject() ) != undefined \
--		and  queryBox ( "Delete modifier from visible objects ?\n\n" + (mod_name = _mod.name ) ) title:"DELETE MODIFIER" then
--		(
--			for obj in objects where not obj.isHidden and (mod_found = obj.modifiers[mod_name]) != undefined do
--				deleteModifier obj mod_found
--				--append objs_with_mods obj
--
--			--if objs_with_mods.count > 0 then
--			--	select objs_with_mods
--		)
--
--	)
--)
--
--
--macroscript	modifiers_instance_modifiers_on_obj_copy_callback
--category:	"_Modifiers-Manage"
--buttontext:	"Delete By Name"
--toolTip:	""
--icon:	"control:checkbox|across:1|autorun:true"
--(
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"
--	on execute do
--	(
--		max modify mode
--
--		objs_with_mods = #()
--
--		if ( _mod = modPanel.getCurrentObject() ) != undefined \
--		and  queryBox ( "Delete modifier from visible objects ?\n\n" + (mod_name = _mod.name ) ) title:"DELETE MODIFIER" then
--		(
--			for obj in objects where not obj.isHidden and (mod_found = obj.modifiers[mod_name]) != undefined do
--				deleteModifier obj mod_found
--				--append objs_with_mods obj
--
--			--if objs_with_mods.count > 0 then
--			--	select objs_with_mods
--		)
--
--	)
--)