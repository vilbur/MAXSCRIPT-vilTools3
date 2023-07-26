
filein( getFilenamePath(getSourceFileName()) + "/CommandPanel/CommandPanel.ms" ) -- "./CommandPanel/CommandPanel.ms"



/**
 */
macroscript	modifiers_modifiers_enable_selected
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
		macros.run "_Modifier Stack" "modifiers_modifiers_enable_all"
)

/**
 */
macroscript	modifiers_modifiers_enable_all
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
macroscript	modifiers_modifiers_disable_selected
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
		macros.run "_Modifier Stack" "modifiers_modifiers_disable_all"
)

/**
 */
macroscript	modifiers_modifiers_disable_all
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



