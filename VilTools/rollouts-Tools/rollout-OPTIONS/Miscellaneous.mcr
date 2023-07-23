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
