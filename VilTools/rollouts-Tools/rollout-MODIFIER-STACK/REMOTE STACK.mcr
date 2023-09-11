
filein( getFilenamePath(getSourceFileName()) + "/Lib/CircleStack/CircleStack.ms" ) -- "./Lib/CircleStack/circleStack.ms"

/* USE

	"./Lib/CommandPanel/CommandPanel.ms"

*/

/*------------------------------------------------------------------------------

	ENABLE\DISABLE SELECTED MODIFIERS

--------------------------------------------------------------------------------*/
/** TOGGLE
 */
macroscript	modifiers_toggle_selected
category:	"_Modifiers-Remote"
buttontext:	"Toggle"
toolTip:	"Toggle selected modifiers. \n\nCTRL: Froce ENABLE modifiers. \n\nALT: Froce DIABLE modifiers"
icon:	"MENU:true|title:TOGGLE"
(
	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\CommandPanel\CommandPanel.ms"
		state = case of
		(
			( keyboard.controlPressed):	true
			( keyboard.altPressed):	false
			default:	#toggle
		)
		(ModifierStackRemote_v()).setState ( #SELECTED )( state )
	)
)

/*------------------------------------------------------------------------------
	RENAME MODIFIER
--------------------------------------------------------------------------------*/

/**
  */
macroscript	modifiers_rename_current
category:	"_Modifiers-Remote"
buttontext:	"Generate Name"
toolTip:	"Generate name for current modifier."
icon:	"MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"

	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE_MODIFIERS.mcr"
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModifierRenamer\ModifierRenamer.ms"

		if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
			curr_mod.name = (ModifierRenamer_v(curr_mod)).generateName()
	)

	--on altExecute type do
	--(
	--		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE_MODIFIERS.mcr"
	--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModifierRenamer\ModifierRenamer.ms"
	--
	--	if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
	--		(ModifierRenamer_v(curr_mod)).renameDialog generate:false
	--)
)

/**
  */
macroscript	modifiers_rename_current_dialog
category:	"_Modifiers-Remote"
buttontext:	"Rename"
toolTip:	"Rename current modifier dialog. \n\nOption in menu: Open Dialog"
icon:	"MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"

	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE_MODIFIERS.mcr"
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModifierRenamer\ModifierRenamer.ms"

		if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
			(ModifierRenamer_v(curr_mod)).renameDialog generate:false
	)
)

/**
  */
macroscript	modifiers_rename_current_to_uppercase
category:	"_Modifiers-Remote"
buttontext:	"Uppercase Name"
toolTip:	"Uppercase modifier name."
icon:	"MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE MODIFIERS.mcr"

	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\MANAGE_MODIFIERS.mcr"
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModifierRenamer\ModifierRenamer.ms"

		if ( curr_mod = modPanel.getCurrentObject() ) != undefined then
			curr_mod.name = toUpper curr_mod.name
	)


)




--/** ENABLE
-- */
--macroscript	modifiers_enable_selected
--category:	"_Modifiers-Remote"
--buttontext:	"Enable"
--toolTip:	"Enable selected modifiers"
--icon:	"MENU:true|title:ENABLE"
--(
--	on execute do
--		(ModifierStackRemote_v()).setState ( #SELECTED )( #toggle )
--
--	on AltExecute type do
--		macros.run "_Modifiers-Remote" "modifiers_enable_all"
--)

--/** ENABLE RIGHTCLICK
-- */
--macroscript	modifiers_enable_all
--category:	"_Modifiers-Remote"
--buttontext:	"Enable"
--toolTip:	"Enable All modifiers"
--(
--	on execute do
--		(ModifierStackRemote_v()).setState ( #SELECTED )( true )
--)
--
--/** DISABLE
-- */
--macroscript	modifiers_disable_selected
--category:	"_Modifiers-Remote"
--buttontext:	"Disable"
--toolTip:	"Disable selected modifiers"
--icon:	"MENU:true|title:DISABLE"
--(
--	on execute do
--		(ModifierStackRemote_v()).setState ( #SELECTED )( false )
--
--	on AltExecute type do
--		macros.run "_Modifiers-Remote" "modifiers_disable_all"
--)
--
--/** DISABLE RIGHTCLICK
-- */
--macroscript	modifiers_disable_all
--category:	"_Modifiers-Remote"
--buttontext:	"Disable"
--toolTip:	"Disable All modifiers"
--(
--	on execute do
--		(ModifierStackRemote_v()).setState ( #ALL )( false )
--)

/** DELETE
 */
macroscript	modifiers_delete_selected
category:	"_Modifiers-Remote"
buttontext:	"Delete"
toolTip:	"Delete Selected modifiers"
icon:	"MENU:true|title:DELETE"
(
	on execute do
	(
		clearListener(); print("Cleared in:"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\REMOTE STACK.mcr"
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModifierStackRemote\ModifierStackRemote.ms"
		--CommandPanel 	= ModifierStackRemote_v()

		--selected_modifiers =  (ModifierStackRemote_v()).getSelectedModifiers()
		--format "SELECTED_MODIFIERS:	% \n" selected_modifiers
		if (selected_modifiers = (ModifierStackRemote_v()).getSelectedModifiers()).count > 0 then
			for obj in selection do
				for selected_modifier in selected_modifiers do
					deleteModifier obj selected_modifier

	)
)




/*------------------------------------------------------------------------------

	SMART NAVIGATION IN STACK

--------------------------------------------------------------------------------*/

/** SMART REMOTE UP
  *
  * 1) Activate modify panel if not active
  * 2) If modify panel is active, then select next enabled modifier
 */
macroscript	modifier_smart_remote_up
category:	"_Modifiers-Remote"
buttontext:	"Smart UP"
tooltip:	"GO | SELECT | DESELECT mods in stack. \n\nCTRL: On go mode select disabled mods also. \n\nSHIFT: Select mods. \n\nALT: Deselect mods. \n\nCTRL + SHIFT: Select all mods UP"
(
	on execute do
	(
		clearListener(); print("Cleared in:"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModifierStackRemote\ModifierStackRemote.ms"
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Remote Stack.mcr"
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\CircleStack\CircleStack.ms"

		/** Is pressed
		  *
		  */
		function pressed key = execute ("keyboard."+key as string+"Pressed")


		if( GetCommandPanelTaskMode() != #modify ) then
			max modify mode

		case of
		(

			( pressed #CONTROL and pressed #SHIFT ):	circleStack #UP mode:#ADD_ALL
			( pressed #CONTROL ):	circleStack #UP	which:#ALL
			( pressed #SHIFT ):	circleStack #UP	which:#ALL mode:#ADD
			( pressed #ALT ):	circleStack #DOWN	which:#ALL mode:#REMOVE


			default:	circleStack #UP
		)
	)
)

/** SMART REMOTE DOWN
  *
  * 1) Activate modify panel if not active
  * 2) If modify panel is active, then select next enabled modifier
 */
macroscript	modifier_smart_remote_down
category:	"_Modifiers-Remote"
buttontext:	"Smart Down"
tooltip:	"GO | SELECT | DESELECT mods in stack. \n\nCTRL: On go mode select disabled mods also. \n\nSHIFT: Select mods. \n\nALT: Deselect mods. \n\nCTRL + SHIFT: Select all mods DOWN"
(

	on execute do
	(
		clearListener(); print("Cleared in:"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\ModifierStackRemote\ModifierStackRemote.ms"
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Remote Stack.mcr"
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\CircleStack\CircleStack.ms"


		function pressed key = execute ("keyboard."+key as string+"Pressed")


		if( GetCommandPanelTaskMode() != #modify ) then
			max modify mode

		case of
		(
			( pressed #CONTROL and pressed #SHIFT ):	circleStack #DOWN mode:#ADD_ALL
			( pressed #CONTROL ):	circleStack #DOWN	which:#ALL
			( pressed #SHIFT ):	circleStack #DOWN	which:#ALL mode:#ADD
			( pressed #ALT ):	circleStack #UP 	which:#ALL mode:#REMOVE

			default:	circleStack #DOWN
		)
	)
)
