/*------------------------------------------------------------------------------
	UNHIDE
------------------------------------------------------------------------------*/

/**
 *
 */
macroscript	layers_all_on
category:	"_Layers-Visibility"
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
category:	"_Layers-Visibility"
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
category:	"_Layers-Visibility"
buttontext:	"ON\OFF by prefix"
tooltip:	"Hide by layer prefix"
icon:	"MENU:Toggle by prefix|Tooltip:Toggle layers with same prefix\n\nE.G.: _Name\prefix-\1-Name\n\n"
autoUndoEnabled:true
(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Visibility.mcr"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\toggleLayersByPrefix.ms"
	on execute do
		undo "Toggle by prefix" on
		(
			_selection = for obj in selection collect obj

			LayersManager = LayersManager_v()

			selected_layers = LayersManager.getSelectedOrCurrent()
			format "\n-----------\nARRAY:selected_layers:\n";  for layer in selected_layers do format "layer:	%\n" layer.name

			layer_name = trimLeft selected_layers[1].name "-_ " -- remove delimeter from left side of string E.G.: " - HELP  - Layer"
			format "layer_name:	% \n" layer_name

			if ( layer_name_split = filterString layer_name "-_ ").count > 0 then  -- split by delimeter E.G.: " - HELP  - Layer"
			(
				layers_by_prefix = LayersManager.getLayerByName( layer_name_split[1]+"*" )

				if layers_by_prefix.count > 0 then
					LayersManager.setVisibility(layers_by_prefix)( not selected_layers[1].on )
			)

			select _selection
		)
)


--/**
--  *
--  * http://www.scriptspot.com/forums/3ds-max/general-scripting/select-layers
-- */
--macroscript	_layers_manager_toggle_same_prefix_off
--category:	"_Layers-Visibility"
--buttontext:	"ON\OFF by prefix"
--tooltip:	"Hide by layer prefix"
--icon:	"Tooltip:Toggle layers with same prefix\n\nE.G.: _Name\prefix-\1-Name\n\n"
--autoUndoEnabled:true
--(
--	--clearListener()
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Visibility.mcr"
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\toggleLayersByPrefix.ms"
--	on execute do
--	(
--		toggleLayersByPrefix(false)
	--)
--)

--/**
--  *
--  * http://www.scriptspot.com/forums/3ds-max/general-scripting/select-layers
-- */
--macroscript	_layers_manager_toggle_same_prefix_on
--category:	"_Layers-Visibility"
--buttontext:	"ON\OFF by prefix"
--tooltip:	"Unhide by layer prefix"
--(
--	--clearListener()
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Visibility.mcr"
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\toggleLayersByPrefix.ms"
--	on execute do
--	(
--		toggleLayersByPrefix(true)
--	)
--)
