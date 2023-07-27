--filein( getFilenamePath(getSourceFileName()) + "/../rollout-LAYERS/Lib/LayersManager/LayersManager.ms" )	-- "./../rollout-LAYERS/Lib/LayersManager/LayersManager.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/toggleLayersByPrefix.ms" ) -- "./Lib/toggleLayersByPrefix.ms"






/*------------------------------------------------------------------------------
	HIDE \ UNHIDE LAYER BY SELECTION
------------------------------------------------------------------------------*/

/**
 *
 */
macroscript	layers_off_unselected
category:	"_Layers Visibility"
buttontext:	"Hide unselected"
toolTip:	"Hide unselected layers"
icon:	"menu:true|Tooltip:Turn off other layers then selected layers\objects.\n"
(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Visibility.mcr"

	LayersManager = LayersManager_v()

	selected_layers = LayersManager.getSelectLayersOrBySelection()

	format "selected_layers = % \n" selected_layers

	undo "Hide unselected layers" on
		layers_in_hierarchy = LayersManager.setVisibleTree( selected_layers )


	LayersManager.expandLayersByObejcts( selection )

	/* HIDE OBEJCTS IN PARENT LAYERS
		parent_layers = LayersManager.difference( layers_in_hierarchy )(selected_layers)

		LayersManager.setObjectsVisibility(parent_layers)(false)
	*/

	LayersManager.setCurrent( selected_layers )

)

/**
 *
 */
macroscript	layers_by_selection_off_selected
category:	"_Layers Visibility"
buttontext:	"Hide selected"
toolTip:	"Hide selected layers"
icon:	"menu:true|Tooltip:Turn off selected layers\objects.\n"
(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Visibility.mcr"

	LayersManager = LayersManager_v()

	selected_layers = LayersManager.getSelectLayersOrBySelection()

	undo "Hide unselected layers" on
		layers_in_hierarchy = LayersManager.setVisibility( selected_layers )(false)

)


/**
 *
 */
macroscript	layers_off_unselected_top
category:	"_Layers Visibility"
buttontext:	"Hide unselected"
toolTip:	"Hide unselected top layers"
icon:	"menu:tooltip"
(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Visibility.mcr"

	LayersManager = LayersManager_v()

	selected_layers = LayersManager.getSelectLayersOrBySelection()

	top_layers_selected = LayersManager.getTopLayers( selected_layers )
	top_layers_all		= LayersManager.getTopLayers( LayersManager.getAllLayers() )

	top_layers_to_hide = LayersManager.difference (top_layers_all) (top_layers_selected)

	undo "Hide unselected top layers" on
		LayersManager.setVisibility (top_layers_to_hide) (false)

	LayersManager.expandLayersByObejcts( selection )

	LayersManager.setCurrent( selected_layers )
)


/*------------------------------------------------------------------------------
	UNHIDE ALL LAYERS
------------------------------------------------------------------------------*/
/**
 *
 */
macroscript	layers_all_on
category:	"_Layers Visibility"
buttontext:	"Hide\Unhide"
toolTip:	"Unhide all layers"
icon:	"menu:tooltip"
(
	LayersManager = LayersManager_v()

	undo "Unhide all layers" on
		LayersManager.setVisibility(LayersManager.getAllLayers())(true)
)




/*------------------------------------------------------------------------------
	HIDE \ UNHIDE LAYER BY PREFIX
------------------------------------------------------------------------------*/


/**
  *
  * http://www.scriptspot.com/forums/3ds-max/general-scripting/select-layers
 */
macroscript	_layers_manager_toggle_same_prefix_on
category:	"_Layers Visibility"
buttontext:	"Hide\Unhide by prefix"
tooltip:	"Unhide by layer prefix"
icon:	"menu:tooltip|Tooltip:Toggle layers with same prefix\n\nE.G.: _Name\prefix-\1-Name\n\n"
(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Visibility.mcr"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\toggleLayersByPrefix.ms"

	toggleLayersByPrefix(true)
)

/**
  *
  * http://www.scriptspot.com/forums/3ds-max/general-scripting/select-layers
 */
macroscript	_layers_manager_toggle_same_prefix_off
category:	"_Layers Visibility"
buttontext:	"Hide\Unhide by prefix"
tooltip:	"Hide by layer prefix"
icon:	"menu:tooltip"
(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Visibility.mcr"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\toggleLayersByPrefix.ms"

	toggleLayersByPrefix(false)
)




