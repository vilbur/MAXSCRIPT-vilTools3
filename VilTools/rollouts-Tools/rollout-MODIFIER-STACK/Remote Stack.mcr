
filein( getFilenamePath(getSourceFileName()) + "/Lib/CommandPanel/CommandPanel.ms" ) -- "./CommandPanel/CommandPanel.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/CircleStack/circleStack.ms" ) -- "./Lib/CircleStack/circleStack.ms"

/**
  * 1) Activate modify panel if not active
  * 2) If modify panel is active, then select next enabled modifier
 */
macroscript	modifier_select_enabled_modifier_next
category:	"_Modifier Stack"
buttontext:	"Next Enabled"
tooltip:	"Select Next Enabled Modifier"
(
	if( GetCommandPanelTaskMode() != #modify ) then
		max modify mode

	circleStack(#up)

)

/**
  * 1) Activate modify panel if not active
  * 2) If modify panel is active, then select next enabled modifier
 */
macroscript	modifier_select_enabled_modifier_previous
category:	"_Modifier Stack"
buttontext:	"Previous Enabled"
tooltip:	"Select Previous Enabled Modifier"
(
	if( GetCommandPanelTaskMode() != #modify ) then
		max modify mode

	circleStack(#down)
)


/**
  * 1) Activate modify panel if not active
  * 2) If modify panel is active, then select next enabled modifier
 */
macroscript	modifier_select_modifier_next
category:	"_Modifier Stack"
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

/**
  * 1) Activate modify panel if not active
  * 2) If modify panel is active, then select next enabled modifier
 */
macroscript	modifier_select_modifier_previous
category:	"_Modifier Stack"
buttontext:	"Previous Modifier"
tooltip:	"Select Previous Modifier"
(
	clearListener(); print("Cleared in:"+getSourceFileName())
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
--category:	"_Modifier Stack"
--buttontext:	"← → Mod"
--toolTip:	"Select previous\next enabled modifier.\nCtrl:Select disabled modifiers too"
--icon:	"menu:toolTip"
--(
--	--clearListener()
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

/**
 */
macroscript	modifiers_enable_selected
category:	"_Modifier Stack"
buttontext:	"Enable"
toolTip:	"Enable selected modifiers"
icon:	"menu:toolTip"
(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Remote Stack.mcr"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\CommandPanel\CommandPanel.ms"

	on execute do
		(CommandPanel_v()).toggleModifiers( selection[1] )( true )( #SELECTED )


	on AltExecute type do
		macros.run "_Modifier Stack" "modifiers_enable_all"
)

/**
 */
macroscript	modifiers_enable_all
category:	"_Modifier Stack"
buttontext:	"Enable"
toolTip:	"Enable All modifiers"
--icon:	"menu:toolTip"
(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Remote Stack.mcr"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\CommandPanel\CommandPanel.ms"

	on execute do
		(CommandPanel_v()).toggleModifiers( selection[1] )( true )( #ALL )
)

/**
 */
macroscript	modifiers_disable_selected
category:	"_Modifier Stack"
buttontext:	"Disable"
toolTip:	"Disable selected modifiers"
icon:	"menu:toolTip"
(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Remote Stack.mcr"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\CommandPanel\CommandPanel.ms"


	on execute do
		(CommandPanel_v()).toggleModifiers( selection[1] )( false )( #SELECTED )

	on AltExecute type do
		macros.run "_Modifier Stack" "modifiers_disable_all"
)

/**
 */
macroscript	modifiers_disable_all
category:	"_Modifier Stack"
buttontext:	"Disable"
toolTip:	"Disable All modifiers"
--icon:	"menu:toolTip"
(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Remote Stack.mcr"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\CommandPanel\CommandPanel.ms"

	on execute do
		(CommandPanel_v()).toggleModifiers( selection[1] )( false )( #ALL )
)


--/**
-- */
--macroscript	modifiers_select_down
--category:	"_Modifier Stask"
--buttontext:	"Selected Down"
----toolTip:	"Disable modifiers above active modifier when subobject is entered"
----icon:	"control:checkbox|enabled:false"
--(
--	clearListener()
--	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Remote Stack.mcr"
--	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\CommandPanel\CommandPanel.ms"
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
