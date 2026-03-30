
/*------------------------------------------------------------------------------
	LAYERS MANGER DIALOGS
------------------------------------------------------------------------------*/


/** OPEN LAYERS MANAGER
 */
macroscript	layers_manager_keep_open_close
category:	"_Layers-Dialogs"
buttontext:	"Layer Manager"
tooltip:	"Show\Hide Layer Manager.\n\nIf checked, then manager is open on scene open"
icon:	"control:checkbutton|MENU:true|autorun:true|across:2"
(

	on execute do
	(
		--clearListener(); print("Cleared in:\n"+getSourceFileName())
		--format "EventFired: %\n" EventFired

		if EventFired == undefined or ( EventFired.get #val ) then -- run on startup if no fire by event
		(
			/* OEPN LAYER MANAGER ON SCENE OPEN */
			try( callbacks.addScript #filePostOpenProcess "LayerManager.editLayerByName \"\"" id:#showLayerManagerCallback )catch()

			LayerManager.editLayerByName ""
		)
		
		else -- if checkbutton is unchecked
		(
			LayerManager.closeDialog()
			
			try( callbacks.removeScripts #filePostOpenProcess id:#showLayerManagerCallback )catch()
		)
	)
)


/*------------------------------------------------------------------------------
	SCENE EXPLORER
--------------------------------------------------------------------------------*/

/**
 */
macroscript	_options_scene_explorer_toggle
category:	"_Otions"
buttontext:	"Scene Explorer"
tooltip:	"Show\Hide Scene Explorer.\n\nIf checked, then manager is open on scene open"
icon:	"control:checkbutton"
(

	default_explorer = "Scene Explorer"

	if EventFired.val then
	(
		if not SceneExplorerManager.ExplorerExists(default_explorer) then
			SceneExplorerManager.CreateExplorerFromDefault(default_explorer)
		else
			SceneExplorerManager.OpenExplorer(default_explorer)


		try( callbacks.addScript #filePostOpenProcess "SceneExplorerManager.CreateExplorerFromDefault \"Scene Explorer\"" id:#showSceneExplorerCallback )catch()
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
