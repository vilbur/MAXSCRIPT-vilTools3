/*------------------------------------------------------------------------------
	ISOLATE LAYERS
------------------------------------------------------------------------------*/

/**
 *
 */
macroscript	layers_isolate_selected
category:	"_Layers-1"
buttontext:	"Isolate Selected"
toolTip:	"Isolate Selected layers"
icon:	"MENU:ISOLATE Selected|Tooltip:Show only selected layers, or layers of objects.\nIsolate current Layer if nothing is selected"
(
	on execute do
	(
		LayersManager = LayersManager_v()

		layers_selected = LayersManager.getSelectedOrCurrent()

		undo "Isolate selected layers" on
			LayersManager.hideUnselected isolate:true

		LayersManager.setCurrent( layers_selected )

		LayersManager.expand( selected_layers )
	)
)

/*------------------------------------------------------------------------------
	HIDE
--------------------------------------------------------------------------------*/
/**
 *
 */
macroscript	layers_by_selection_off_selected
category:	"_Layers-1"
buttontext:	"Hide selected"
toolTip:	"Hide selected layers"
icon:	"MENU:HIDE Selected|Tooltip:Turn off selected layers, or layers of objects.\n"
(
	on execute do
	(
		--clearListener()
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Visibility.mcr"
		LayersManager = LayersManager_v()

		selected_layers = LayersManager.getSelectedOrCurrent()

		format "\n-----------\nARRAY:selected_layers:%\n" selected_layers; for selected_layer in selected_layers do format "selected_layer:	%\n" selected_layer.name

		undo "Hide selected layers" on
			LayersManager.setVisibility( selected_layers )(false)

	)
)

/** UNHIDE TOP LAYERS
 *
 */
macroscript	layers_off_unselected_top
category:	"_Layers-1"
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

		--layers_hidden = LayersManager.getLayerByProp(#isHidden)(true)

		undo "Hide unselected layers" on
			LayersManager.hideUnselected()

		LayersManager.setCurrent( selected_layers )

		--LayersManager.expand( selected_layers )
	)
)