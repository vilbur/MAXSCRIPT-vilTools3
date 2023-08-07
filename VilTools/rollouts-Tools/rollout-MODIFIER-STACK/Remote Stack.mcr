
filein( getFilenamePath(getSourceFileName()) + "/Lib/CommandPanel/CommandPanel.ms" ) -- "./CommandPanel/CommandPanel.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/CircleStack/circleStack.ms" ) -- "./Lib/CircleStack/circleStack.ms"

/**
  * 1) Activate modify panel if not active
  * 2) If modify panel is active, then select next enabled modifier
 */
macroscript	modifier_stack_smart_circle_down
category:	"_Modifier Stack"
buttontext:	"Circle Stack"
toolTip:	"Go modify panel down"
(
	format "GetCommandPanelTaskMode():	% \n" (GetCommandPanelTaskMode())
	
	if( GetCommandPanelTaskMode() != #modify ) then
		max modify mode


	circleStack(#down)


	--/**
	-- */
	--function selectNextEnabledModifier modifiers index =
	--(
	--	format "\n"; print ".selectNextEnabledModifier()"
	--	index_next = index + 1
	--
	--	while index_next <= modifiers.count and modifiers[index_next].enabled == false do
	--		index_next += 1
	--
	--	if selection.count > 1 then
	--	(
	--		print "SELECT MODIFIER - MUTLIPLE OBJECTS"
	--
	--		/* GO DOWN ISTACK n TIMES TO NEXT ENABLED MODIFIER */
	--		if index_next <= modifiers.count then
	--			for i = 1 to index_next - index do
	--				max prev mod
	--		else /* SELECT FIRST MODIFIER */
	--			for i = 1 to modifiers.count do
	--				max next mod
	--
	--	)
	--	else
	--	(
	--		print "SELECT MODIFIER - SINGLE OBJECT"
	--		modPanel.setCurrentObject selection[1].modifiers[index_next]
	--	)
	--
	--)
	--
	--if selection.count > 0 then
	--(
	--	modifiers = if selection.count > 1 then (InstancedModifierFinder( selection )).getInstancedModifiers() else selection[1].modifiers
	--
	--	if( GetCommandPanelTaskMode() != #modify ) then
	--		max modify mode
	--
	--	if modifiers.count > 1 and ( current_mod = modPanel.getCurrentObject() ) != undefined then
	--	(
	--		index_current = if superClassOf current_mod == modifier then findItem modifiers current_mod else 0
	--
	--		if selection.count == 1 and index_current == modifiers.count then
	--			modPanel.setCurrentObject $.baseObject -- select baseobject if last modifier is active
	--
	--		else if selection.count == 1 and index_current == 0 then
	--			modPanel.setCurrentObject $.modifiers[1] -- select first modifier if baseobject is active
	--
	--		else
	--			selectNextEnabledModifier( modifiers )( index_current )
	--	)
	--)
)

/**
  * 1) Activate modify panel if not active
  * 2) If modify panel is active, then select next enabled modifier
 */
macroscript	modifier_stack_smart_circle_up
category:	"_Modifier Stack"
buttontext:	"Circle Stack"
toolTip:	"Go modify panel up"
(

	if( GetCommandPanelTaskMode() != #modify ) then
		max modify mode


	circleStack(#up)

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
