
/* USES:

	"./Lib/OnNewNodeCallback.ms"
*/

/**
 */
macroscript	_obejct_create_line
category:	"_Create-Shapes"
buttontext:	"Line"
tooltip:	"Create Line"
icon:	"MENU:true"
autoUndoEnabled: true
(

	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OBJECT\Lib\onNewNodeCallback.ms"
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OBJECT\SHAPES.mcr"

		ON_NEW_NODE_DATA[#type] = #line

	    startObjectCreation line newNodeCallback:onNewNodeCallback
	)

)

/**
 */
macroscript	_obejct_create_curve
category:	"_Create-Shapes"
buttontext:	"Curve"
tooltip:	"Create Curve"
icon:	"MENU:true"
autoUndoEnabled: true
(

	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OBJECT\Lib\onNewNodeCallback.ms"
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OBJECT\SHAPES.mcr"

		--ON_NEW_NODE_DATA[#type] = #line

	    startObjectCreation line newNodeCallback:onNewNodeCallback
	)

)

/**
 */
macroscript	_obejct_create_rectangle
category:	"_Create-Shapes"
buttontext:	"Rectangle"
tooltip:	"Create Rectangle"
icon:	"MENU:true"
autoUndoEnabled: true
(

	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OBJECT\Lib\onNewNodeCallback.ms"
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-OBJECT\SHAPES.mcr"

	    startObjectCreation Rectangle newNodeCallback:onNewNodeCallback
	)

)