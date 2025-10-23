
/** OPEN FILE DIALOG
 *
 */
macroscript	_scene_open_xref_dialog
category:	"_Scene-Xref"
buttontext:	"Xref Scene"
toolTip:	"Xref Scene Dialog"
--icon:	"control:checkButton|MENU:_Scene"
icon:	"across:3|width:72|MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SCENE\Scene.mcr"
	on execute do
		max file xref scene
)

/** OPEN FILE DIALOG
 *
 */
macroscript	_scene_open_xref_dialog_object
category:	"_Scene-Xref"
buttontext:	"Xref Object"
toolTip:	"Xref Object Dialog"
--icon:	"control:checkButton|MENU:_Scene"
icon:	"width:72|MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SCENE\Scene.mcr"
	on execute do
		max file xref object
)


/** OPEN FILE DIALOG
 *
 */
macroscript	_scene_open_merge_object
category:	"_Scene-Xref"
buttontext:	"Merge"
toolTip:	"Merge Dialog"
--icon:	"control:checkButton|MENU:_Scene"
icon:	"width:72|MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SCENE\Scene.mcr"
	on execute do
		max file merge
)

