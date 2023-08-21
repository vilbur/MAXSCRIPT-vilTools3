
/*------------------------------------------------------------------------------
	LAYERS MANGER DIALOGS
------------------------------------------------------------------------------*/
/**
 */
function showLayerManagerCallback =
(
	try( callbacks.addScript #filePostOpenProcess "showLayerManagerCallback()" id:#showLayerManagerCallback )catch()

	if not LayerManager.isDialogOpen()  then
		LayerManager.editLayerByName ""
)

/** OPEN LAYERS MANAGER
 */
macroscript	layers_manager_autorun
category:	"_Layers-Dialogs"
buttontext:	"Layer Manager"
tooltip:	"Show\Hide Layer Manager.\n\nIf checked, then manager is open on scene open"
icon:	"control:checkbutton"
(

	on execute do
		if EventFired == undefined or (EventFired != undefined and EventFired.val) then -- run on startup if no fire by event
		(
			--LayerManager.editLayerByName ""
			showLayerManagerCallback()
		)
		else
		(
			LayerManager.closeDialog()

			try( callbacks.removeScripts #filePostOpenProcess id:#showLayerManagerCallback )catch()
		)
)




/** WORKING LAYER DIALOG
 */
macroscript	layers_manager_toogle_dialog
category:	"_Layers-Dialogs"
buttontext:	"Working Layers"
tooltip:	"Open Working Layers Dialog.\n\nCreate for each layer of selected layer or selected object"
--icon:	"control:checkbutton|MENU:true|title:LAYER TOOGLE"
icon:	"MENU:Working Layers Dialog"
(
	--format "EventFired:	% \n" EventFired

	on execute do
	(
		clearListener(); print("Cleared in:"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersToogleDialog\LayersToogleDialog.ms"
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"

		LayersToogleDialog = LayersToogleDialog_v()

		LayersToogleDialog.create()
	)
)


/** WORKING LAYER DIALOG - RELAOD
 */
macroscript	layers_manager_toogle_dialog_resetini
category:	"_Layers-Dialogs"
buttontext:	"Working Layers"
tooltip:	"Reload with new layers set"
--icon:	"control:checkbutton"
(
	--format "EventFired:	% \n" EventFired

	on execute do
	(
		clearListener(); print("Cleared in:"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersToogleDialog\LayersToogleDialog.ms"
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"
		LayersToogleDialog = LayersToogleDialog_v()

		LayersToogleDialog.create reset_layers:true
	)

)

/** SCENE EXPLORER
 */
macroscript	_layers_scene_explorer
category:	"_Layers-Dialogs"
buttontext:	"Scene Explorer"
tooltip:	"Show\Hide Scene Explorer.\n\nIf checked, then manager is open on scene open"
(
	--messageBox "Yupiii" title:"Title"  beep:false
	LayerManager.editLayerByName ""

	if not SceneExplorerManager.ExplorerExists(default_explorer = "Scene Explorer") then
		SceneExplorerManager.CreateExplorerFromDefault(default_explorer)
	else
		SceneExplorerManager.OpenExplorer(default_explorer)
)



--/**
-- */
--macroscript	_layers_select_objects_of_selection
--category:	"_Layers-Dialogs"
--buttontext:	"Select objects"
--icon:	"Tooltip:'Select objects of selected layers\objects.\n'"
--(
--	messageBox "Manage Layers" title:"Title"  beep:false
--	LayersManager = LayersManager_v()
--
--	selected_layers = LayersManager.getSelectLayersOrBySelection()
--
--	--select (LayersManager.getObjectsInLayers(selected_layers))
--
--)
