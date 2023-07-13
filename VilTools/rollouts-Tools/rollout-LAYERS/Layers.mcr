/*------------------------------------------------------------------------------
	LAYERS MANGER
--------------------------------------------------------------------------------*/



/**
 */
macroscript	_layers_manager_toggle
category:	"_Layers"
buttontext:	"Open Manager"
tooltip:	"Show\Hide Layer manager & Scene Explorer"
--icon:	"control:checkbutton"
(

	--LayerManager.isDialogOpen()

	LayerManager.editLayerByName ""

	if not SceneExplorerManager.ExplorerExists(default_explorer = "Scene Explorer") then
		SceneExplorerManager.CreateExplorerFromDefault(default_explorer)
	else
		SceneExplorerManager.OpenExplorer(default_explorer)


)