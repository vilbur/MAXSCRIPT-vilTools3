
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
toolTip:	"Toggle selected modifiers"
icon:	"MENU:true|title:TOGGLE"
(
	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\CommandPanel\CommandPanel.ms"
		(CommandPanel_v()).setStateSelectedModifiers( #toggle )( #SELECTED )
	)
)


/** ENABLE
 */
macroscript	modifiers_enable_selected
category:	"_Modifiers-Remote"
buttontext:	"Enable"
toolTip:	"Enable selected modifiers"
icon:	"MENU:true|title:ENABLE"
(
	on execute do
		(CommandPanel_v()).setStateSelectedModifiers( true )( #SELECTED )

	on AltExecute type do
		macros.run "_Modifiers-Remote" "modifiers_enable_all"
)

/** ENABLE RIGHTCLICK
 */
macroscript	modifiers_enable_all
category:	"_Modifiers-Remote"
buttontext:	"Enable"
toolTip:	"Enable All modifiers"
(
	on execute do
		(CommandPanel_v()).setStateSelectedModifiers( true )( #ALL )
)

/** DISABLE
 */
macroscript	modifiers_disable_selected
category:	"_Modifiers-Remote"
buttontext:	"Disable"
toolTip:	"Disable selected modifiers"
icon:	"MENU:true|title:DISABLE"
(
	on execute do
		(CommandPanel_v()).setStateSelectedModifiers( false )( #SELECTED )

	on AltExecute type do
		macros.run "_Modifiers-Remote" "modifiers_disable_all"
)

/** DISABLE RIGHTCLICK
 */
macroscript	modifiers_disable_all
category:	"_Modifiers-Remote"
buttontext:	"Disable"
toolTip:	"Disable All modifiers"
(
	on execute do
		(CommandPanel_v()).setStateSelectedModifiers( false )( #ALL )
)

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
		--clearListener(); print("Cleared in:"+getSourceFileName())
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Remote_Stack.mcr"

		--CommandPanel 	= CommandPanel_v()

		if (selected_modifiers = (CommandPanel_v()).getSelectedModifiers()).count > 0 then
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
--tooltip:	"Select Previous Enabled Modifier"
(
	on execute do
	(
		clearListener(); print("Cleared in:"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\CommandPanel\CommandPanel.ms"
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Remote_Stack.mcr"
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\CircleStack\CircleStack.ms"
		--format "keyboard.shiftPressed:	% \n" keyboard.shiftPressed

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
--tooltip:	"Select Next Enabled Modifier"
(

	on execute do
	(
		clearListener(); print("Cleared in:"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\CommandPanel\CommandPanel.ms"
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Remote_Stack.mcr"
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











/*------------------------------------------------------------------------------

	DEPRECATED

--------------------------------------------------------------------------------*/

/** GO NEXT ENABLED
  *
  * 1) Activate modify panel if not active
  * 2) If modify panel is active, then select next enabled modifier
 */
macroscript	modifier_go_enabled_next
category:	"_Modifiers-Remote"
buttontext:	"Next Enabled"
tooltip:	"Select Next Enabled Modifier"
(
	if( GetCommandPanelTaskMode() != #modify ) then
		max modify mode

	circleStack(#up)
)

/** GO PREVIOUS ENABLED
  *
  * 1) Activate modify panel if not active
  * 2) If modify panel is active, then select next enabled modifier
 */
macroscript	modifier_go_enabled_previous
category:	"_Modifiers-Remote"
buttontext:	"Previous Enabled"
tooltip:	"Select Previous Enabled Modifier"
(
	if( GetCommandPanelTaskMode() != #modify ) then
		max modify mode

	circleStack(#down)
)


/** GO NEXT
  *
  * 1) Activate modify panel if not active
  * 2) If modify panel is active, then select next enabled modifier
 */
macroscript	modifier_go_next
category:	"_Modifiers-Remote"
buttontext:	"Next Modifier"
tooltip:	"Select Next Modifier"
(

	modifiers = if selection.count > 1 then (InstancedModifierFinder( selection )).getInstancedModifiers() else selection[1].modifiers

	if ( current_mod = modPanel.getCurrentObject() ) != undefined and modifiers.count > 0 then
	(
		index_current = if superClassOf current_mod == modifier then findItem modifiers current_mod else 0

		format "index_current:	% \n" index_current
		format "modifiers.count:	% \n" modifiers.count

		if index_current == 1 then
		(
			if selection.count == 1 then
				modPanel.setCurrentObject selection[1].baseObject -- select baseobject if last modifier is active
			else
				for i = 1 to modifiers.count - 1 do
					max prev mod
		)
		else
			max next mod
	)
)

/** GO PREVIOUS
  *
  * 1) Activate modify panel if not active
  * 2) If modify panel is active, then select next enabled modifier
 */
macroscript	modifier_go_previous
category:	"_Modifiers-Remote"
buttontext:	"Previous Modifier"
tooltip:	"Select Previous Modifier"
(
	--clearListener(); print("Cleared in:"+getSourceFileName())
	modifiers = if selection.count > 1 then (InstancedModifierFinder( selection )).getInstancedModifiers() else selection[1].modifiers

	if ( current_mod = modPanel.getCurrentObject() ) != undefined and modifiers.count > 0 then
	(
		index_current = if superClassOf current_mod == modifier then findItem modifiers current_mod else 0

		if index_current == modifiers.count then
		(
			if selection.count == 1 then
				modPanel.setCurrentObject selection[1].modifiers[1] node:selection[1]

			else
				for i = 1 to modifiers.count - 1  do
					max next mod
		)
		else
			max prev mod

		--format "index_current:	% \n" index_current
		format "modifiers.count:	% \n" modifiers.count
	)

)



--/**
-- */
--macroscript	modifiers_enable_selected
--category:	"_Modifiers-Remote"
--buttontext:	"← → Mod"
--toolTip:	"Select previous\next enabled modifier.\nCtrl:Select disabled modifiers too"
--icon:	"MENU:toolTip"
--(
--	----clearListener()
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Remote Stack.mcr"
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\CommandPanel\CommandPanel.ms"
--
--	on execute do
--	(
--		max modify mode
--
--		if( current_mod = modPanel.getCurrentObject() ) != undefined then
--		(
--
--
--
--		)
--
--	)
--
--)


--/**
-- */
--macroscript	modifiers_select_down
--category:	"_Modifier Stask"
--buttontext:	"Selected Down"
----toolTip:	"Disable modifiers above active modifier when subobject is entered"
----icon:	"control:checkbox|enabled:false"
--(
--	C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Lib\CommandPanel\CommandPanel.ms
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Remote Stack.mcr"
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\CommandPanel\CommandPanel.ms"
--
--	obj = selection[1]
--
--	CommandPanel 	= CommandPanel_v()
--
--
--	format "CommandPanel.list_box = % \n" CommandPanel.list_box
--
--	--WM_LBUTTONDOWN = 0x0201
--	--
--	--windows.postMessage CommandPanel.list_box WM_LBUTTONDOWN  0 0
--
--
--	--modPanel.setCurrentObject( modPanel.getCurrentObject() ) -- refresh modifier stack
--
--)
