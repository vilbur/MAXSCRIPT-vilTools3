
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
icon:	"control:checkbutton|MENU:true|autorun:true"
(

	on execute do
		if EventFired == undefined or ( EventFired.get #val ) then -- run on startup if no fire by event
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

--/** SCENE EXPLORER
-- */
--macroscript	_layers_scene_explorer
--category:	"_Layers-Dialogs"
--buttontext:	"Scene Explorer"
--tooltip:	"Show\Hide Scene Explorer.\n\nIf checked, then manager is open on scene open"
--(
--	--messageBox "Yupiii" title:"Title"  beep:false
--	LayerManager.editLayerByName ""
--
--	if not SceneExplorerManager.ExplorerExists(default_explorer = "Scene Explorer") then
--		SceneExplorerManager.CreateExplorerFromDefault(default_explorer)
--	else
--		SceneExplorerManager.OpenExplorer(default_explorer)
--)

/*------------------------------------------------------------------------------
	SCENE EXPLORER
--------------------------------------------------------------------------------*/

/**
 */
function showSceneExplorerCallback =
(
	SceneExplorerManager.CreateExplorerFromDefault "Scene Explorer"
)


/**
 */
macroscript	_options_scene_explorer_toggle
category:	"_Otions"
buttontext:	"Scene Explorer"
tooltip:	"Show\Hide Scene Explorer.\n\nIf checked, then manager is open on scene open"
icon:	"control:checkbutton"
(

	default_explorer = "Scene Explorer"

	--explorer_exist = SceneExplorerManager.ExplorerExists(default_explorer)

	if EventFired.val then
	(
		if not SceneExplorerManager.ExplorerExists(default_explorer) then
			SceneExplorerManager.CreateExplorerFromDefault(default_explorer)
		else
			SceneExplorerManager.OpenExplorer(default_explorer)


		try( callbacks.addScript #filePostOpenProcess "showSceneExplorerCallback()" id:#showSceneExplorerCallback )catch()
	)
	else
	(
		SceneExplorerManager.CloseExplorer(default_explorer)

		try( callbacks.removeScripts #filePostOpenProcess id:#showSceneExplorerCallback )catch()
	)

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
