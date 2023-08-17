filein( getFilenamePath(getSourceFileName()) + "/../rollout-LAYERS/Lib/LayersManager/LayersManager.ms" )	-- "./../rollout-LAYERS/Lib/LayersManager/LayersManager.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/toggleLayersByPrefix.ms" ) -- "./Lib/toggleLayersByPrefix.ms"



/**
 */
macroscript	_layers_activate_curent_layer_of_selection
category:	"_Layers-Visibility"
buttontext:	"Set current"
tooltip:	"Set current layer by selection"
icon:	"MENU:Set Current"
(
	on execute do
	(
		LayersManager = LayersManager_v()

		selected_layers = LayersManager.getSelectLayersOrBySelection()

		LayersManager.setCurrent( selected_layers )
	)
)



/*------------------------------------------------------------------------------
	HIDE \ UNHIDE LAYER BY SELECTION
------------------------------------------------------------------------------*/

/**
 *
 */
macroscript	layers_isolate_selected
category:	"_Layers-Visibility"
buttontext:	"Isolate Selected"
toolTip:	"Isolate Selected layers"
icon:	"MENU:ISOLATE Selected|Tooltip:Show only selected layers, or layers of objects.\nIsolate current Layer if nothing is selected"
(
	on execute do
	(
		LayersManager = LayersManager_v()

		undo "Isolate selected layers" on
			LayersManager.hideUnselected isolate:true


		LayersManager.setCurrent( selected_layers )

		LayersManager.expand( selected_layers )

	)

)

/**
 *
 */
macroscript	layers_unhide_selected
category:	"_Layers-Visibility"
buttontext:	"On Selected"
toolTip:	"Unhide selected layers, or layers of objects"
icon:	"MENU:UNHIDE Selected"
(
	on execute do
	(
		LayersManager = LayersManager_v()

		selected_layers = LayersManager.getSelectLayersOrBySelection()

		format "selected_layers:	% \n" selected_layers
		undo "Unhide selected layers" on
			LayersManager.setVisibility( selected_layers )(true)
	)
)


/**
 *
 */
macroscript	layers_by_selection_off_selected
category:	"_Layers-Visibility"
buttontext:	"Hide selected"
toolTip:	"Hide selected layers"
icon:	"MENU:HIDE Selected|Tooltip:Turn off selected layers, or layers of objects.\n"
(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Visibility.mcr"
	on execute do
	(
		LayersManager = LayersManager_v()

		selected_layers = LayersManager.getSelectLayersOrBySelection()

		undo "Hide unselected layers" on
			layers_in_hierarchy = LayersManager.setVisibility( selected_layers )(false)
	)
)



/** UNHIDE TOP LAYERS
 *
 */
macroscript	layers_off_unselected_top
category:	"_Layers-Visibility"
buttontext:	"Hide Unselected"
toolTip:	"Hide unselected top layers"
icon:	"MENU:HIDE Unselected"
(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Visibility.mcr"
	on execute do
	(
		LayersManager = LayersManager_v()

		undo "Hide unselected layers" on
			LayersManager.hideUnselected()


		LayersManager.setCurrent( selected_layers )

		LayersManager.expand( selected_layers )
	)
)


/*------------------------------------------------------------------------------
	UNHIDE ALL LAYERS
------------------------------------------------------------------------------*/

/**
 *
 */
macroscript	layers_all_on
category:	"_Layers-Visibility"
buttontext:	"Hide\Unhide"
toolTip:	"Unhide all layers"
icon:	"MENU:UNHIDE ALL layers"
(
	on execute do
	(
		LayersManager = LayersManager_v()

		undo "Unhide all layers" on
			LayersManager.setVisibility(LayersManager.getAllLayers())(true)
	)

	on altExecute type do
	(
		macros.run "_Layers-Visibility" "layers_all_on"

		for obj in objects where obj.isHidden do obj.isHidden = false
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
category:	"_Layers-Visibility"
buttontext:	"ON\OFF by prefix"
tooltip:	"Hide by layer prefix"
icon:	"Tooltip:Toggle layers with same prefix\n\nE.G.: _Name\prefix-\1-Name\n\n"
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
category:	"_Layers-Visibility"
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
