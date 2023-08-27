/**
 */
macroscript	_layers_activate_curent_layer_of_selection
category:	"_Layers-2"
buttontext:	"Set current"
tooltip:	"Set current layer by selection"
icon:	"MENU:Set Current"
(
	on execute do
	(
		LayersManager = LayersManager_v()

		selected_layers = LayersManager.getSelectedOrCurrent()

		LayersManager.setCurrent( selected_layers )
	)

	on altExecute type do
	(
		current_layer = (LayersManager_v()).getCurrent()

		current_layer.addNodes( selection )
	)
)


/* ADD TO CURRENT LAYER
*/
macroscript	layers_add_selection_to_current_layer
category:	"_Layers-2"
buttontext:	"Add to Layer"
toolTip:	"Add selection to current layer."
icon:	"MENU:ADD to Layer"
(
	undo "Add to current layer " on
	(
		layer_current = (LayersManager_v()).getCurrent()
		--format "layer_current:	% \n" layer_current
		for obj in selection do
			layer_current.addNode obj
	)
)


/* SELECT OBEJCTS IN LAYERS
*/
macroscript	layers_move_to_edit_layer
category:	"_Layers-2"
buttontext:	"Move to edit layer"
--toolTip:	"Select Objects of selected layers, or layers of selected objects."
icon:	"MENU:MOVE to edit layer"
(
	undo "Select " on
	(

		LayersManager = LayersManager_v()

		editLayer = LayersManager.newLayer(" ------- EDIT -------")

		editLayer.addNodes( selection )

	)
)



/* SELECT OBEJCTS IN LAYERS
*/
macroscript	layers_select_all_objects_selection
category:	"_Layers-2"
buttontext:	"Select Objects"
toolTip:	"Select Objects of selected layers, or layers of selected objects."
icon:	"MENU:SELECT Objects"
(
	undo "Select Objects By Layer" on
	(
		LayersManager = LayersManager_v()

		selected_layers = LayersManager.getSelectedOrCurrent()

		select (LayersManager.getObjectsInLayers( selected_layers ))
	)
)


/** SELECT CHILDREN LAYERS
 */
macroscript	_layers_manager_select_children_layer
category:	"_Layers-2"
buttontext:	"Select Child layers"
tooltip:	"Select Child layers"
icon:	"MENU:tooltip"
--icon:	"MENU:OFF by PREFIX|Tooltip:Toggle layers with same prefix\n\nE.G.: _Name\prefix-\1-Name\n\n"
(
	on execute do
	(
		LayersManager = LayersManager_v()

		selected_layers = LayersManager.getSelectedOrCurrent()

		layers_to_select = join selected_layers (LayersManager.getChildren(selected_layers))

		LayersManager.selectLayers ( layers_to_select )

		--LayersManager.selectLayersByObjects( for o in selection collect o )

	)
)




/** SELECT BY OBEJCT
 */
macroscript	_layers_manager_select_layer_by_objects
category:	"_Layers-2"
buttontext:	"Select By Objects"
tooltip:	"Select layers by Objects"
icon:	"MENU:tooltip"
--icon:	"MENU:OFF by PREFIX|Tooltip:Toggle layers with same prefix\n\nE.G.: _Name\prefix-\1-Name\n\n"
(
	on execute do
	(
		LayersManager = LayersManager_v()

		LayersManager.selectLayersByObjects( for o in selection collect o )
	)
)


/** SELECT BY PREFIX
 */
macroscript	_layers_manager_select_layer_by_prefix
category:	"_Layers-2"
buttontext:	"Select By Prefix"
tooltip:	"Select layers by prefix"
icon:	"MENU:true"
--icon:	"MENU:OFF by PREFIX|Tooltip:Toggle layers with same prefix\n\nE.G.: _Name\prefix-\1-Name\n\n"
(
	on execute do
	(
		clearListener(); print("Cleared in:"+getSourceFileName())

		layers_by_prefix = #()

		LayersManager = LayersManager_v()

		selected_layers = LayersManager.getSelectedOrCurrent()


		prefixes = for prefix in (LayersManager.getLayersPrefixes(selected_layers)) collect prefix+"*"


		format "prefixes:	% \n" prefixes
		----format "layers_by_prefix:	% \n" layers_by_prefix
		--if layers_by_prefix.count > 0 then


		LayersManager.selectLayers( LayersManager.getLayerByName(prefixes) )



		/**  WORKS BACKUP
		  *
		  */
		--local sceneExplorerInstance = SceneExplorerManager.GetActiveExplorer()
		--
		--sceneExplorerInstance.SelectLayerOfSelection()
		--
		--selected_layers = for layer in sceneExplorerInstance.SelectedItems() where superClassOf layer == Base_Layer collect layer --return
		--
		--format "selected_layers:	% \n" selected_layers
		--for selected_layer in selected_layers do
		--(
		--	format "\n"
		--	format "SELECTED_LAYER.name:	% \n" selected_layer.name
		--	format "SELECTED_LAYER:	% \n" selected_layer
		--
		--)

	)
)
