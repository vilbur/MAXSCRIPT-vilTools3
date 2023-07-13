/*------------------------------------------------------------------------------
	LAYER MANGER
--------------------------------------------------------------------------------*/


/**
 */
function showLayerManagerCallback =
(
	LayerManager.editLayerByName ""
)

/**
 */
macroscript	_options_layer_manager_toggle
category:	"_Otions"
buttontext:	"Layer Manager"
tooltip:	"Show\Hide Layer manager on scene open"
icon:	"control:checkbutton"
(
	if EventFired.val then
	(
		LayerManager.editLayerByName ""

		try( callbacks.addScript #filePostOpenProcess "showLayerManagerCallback()" id:#showLayerManagerCallback )catch()
	)
	else
	(
		LayerManager.closeDialog()

		try( callbacks.removeScripts #filePostOpenProcess id:#showLayerManagerCallback )catch()
	)
)

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
tooltip:	"Show\Hide Scene Explorer on scene open"
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


/*------------------------------------------------------------------------------
	QUAD MENU
--------------------------------------------------------------------------------*/

/**  LINK TO NODE
 */
macroscript	_options_quadmenu_reset
category:	"_Otions"
buttontext:	"Reset Quads"
tooltip:	"Load default quad menu and menus"
(

	menuMan.loadMenuFile "$userscripts/MAXSCRIPT-vilTools3/QuadMenu/QuadMenu-deafalt.mnux"

	menuMan.setViewportRightClickMenu #nonePressed (menuMan.findQuadMenu "Default Viewport Quad")
	menuMan.setViewportRightClickMenu #nonePressed (menuMan.findQuadMenu "Modeling 1 [Cntrl+RMB]")

)

/*------------------------------------------------------------------------------
	MEMORY
--------------------------------------------------------------------------------*/
/**
 */
macroscript	_options_free_memory
category:	"_Otions"
buttontext:	"Free Memory"
tooltip:	"Remove Undo\n\nClean Texture Memory"
(

	gc()	--Garbage Collection.
	freeSceneBitmaps()	--Cleans up in texture memory.
	clearUndoBuffer()	--Removes your Undo’s

	messageBox "Memory CLeaned" title:"Memory Clean"
)


