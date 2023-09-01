/*------------------------------------------------------------------------------
	UNHIDE
------------------------------------------------------------------------------*/

/**
 *
 */
macroscript	layers_all_on
category:	"_Layers-4"
buttontext:	"Hide\Unhide"
toolTip:	"Unhide all layers"
icon:	"MENU:UNHIDE ALL layers"
autoUndoEnabled:true
(
	on execute do
	(
		LayersManager = LayersManager_v()

		undo "Unhide all layers" on
			LayersManager.setVisibility(LayersManager.getAllLayers())(true)
	)

	on altExecute type do
	(
		macros.run "_Layers-1" "layers_all_on"

		for obj in objects where obj.isHidden do obj.isHidden = false
	)

)

/**
 *
 */
macroscript	layers_unhide_selected
category:	"_Layers-4"
buttontext:	"On Selected"
toolTip:	"Unhide selected layers, or layers of objects. \n\nMenu Option:Unhide objects also"
icon:	"MENU:UNHIDE Selected"
autoUndoEnabled:true
(
	on execute do
	(
		LayersManager = LayersManager_v()

		selected_layers = LayersManager.getSelectedOrCurrent()

		format "selected_layers:	% \n" selected_layers[1].name

		--undo "Unhide selected layers" on
		LayersManager.setVisibility( selected_layers )(true)

		--LayersManager.setCurrent( selected_layers )
	)

	on altExecute type do
	(
		LayersManager = LayersManager_v()

		selected_layers = LayersManager.getSelectedOrCurrent()

		--format "selected_layers:	% \n" selected_layers[1].name

		--undo "Unhide selected layers" on
			LayersManager.setVisibility( selected_layers )(true)

		for obj in LayersManager.getObjectsInLayers( selected_layers ) do
			obj.isHidden = false

	)

)


/*------------------------------------------------------------------------------
	HIDE \ UNHIDE LAYER BY PREFIX
------------------------------------------------------------------------------*/

/**
  *
  * http://www.scriptspot.com/forums/3ds-max/general-scripting/select-layers
 */
macroscript	_layers_manager_toggle_same_prefix_off
category:	"_Layers-4"
buttontext:	"ON\OFF by prefix"
tooltip:	"Hide by layer prefix"
icon:	"Tooltip:Toggle layers with same prefix\n\nE.G.: _Name\prefix-\1-Name\n\n"
autoUndoEnabled:true
(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Visibility.mcr"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\toggleLayersByPrefix.ms"
	on execute do
	(
		toggleLayersByPrefix(false)
	)
)

/**
  *
  * http://www.scriptspot.com/forums/3ds-max/general-scripting/select-layers
 */
macroscript	_layers_manager_toggle_same_prefix_on
category:	"_Layers-4"
buttontext:	"ON\OFF by prefix"
tooltip:	"Unhide by layer prefix"
(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Visibility.mcr"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\toggleLayersByPrefix.ms"
	on execute do
	(
		toggleLayersByPrefix(true)
	)
)
