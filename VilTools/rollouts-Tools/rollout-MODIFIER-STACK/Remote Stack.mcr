
filein( getFilenamePath(getSourceFileName()) + "/CommandPanel/CommandPanel.ms" ) -- "./CommandPanel/CommandPanel.ms"

/**
 */
macroscript	modifiers_selected_modifiers_enable
category:	"_Modifier Stack"
buttontext:	"Enable selected"
toolTip:	"Enable selected modifiers"
icon:	"menu:true"
(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Remote Stack.mcr"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\CommandPanel\CommandPanel.ms"

	obj = selection[1]

	CommandPanel 	= CommandPanel_v()

	selected_modifiers = CommandPanel.getSelectedModifiers(obj)

	for modifier_index in selected_modifiers do
		obj.modifiers[modifier_index].enabled = true

	modPanel.setCurrentObject( modPanel.getCurrentObject() ) -- refresh modifier stack
)


/**
 */
macroscript	modifiers_selected_modifiers_disable
category:	"_Modifier Stack"
buttontext:	"Disable selected"
toolTip:	"Disable selected modifiers"
icon:	"menu:true"
(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Remote Stack.mcr"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\CommandPanel\CommandPanel.ms"

	obj = selection[1]

	CommandPanel 	= CommandPanel_v()

	selected_modifiers = CommandPanel.getSelectedModifiers(obj)

	for modifier_index in selected_modifiers do
		obj.modifiers[modifier_index].enabled = false

	modPanel.setCurrentObject( modPanel.getCurrentObject() ) -- refresh modifier stack
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



