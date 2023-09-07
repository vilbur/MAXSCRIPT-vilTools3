/**
 */
macroscript	_layers_activate_curent_layer_of_selection
category:	"_Layers-2"
buttontext:	"Set current"
tooltip:	"Set current layer by selection"
icon:	"MENU:Set Current"
autoUndoEnabled:true
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
buttontext:	"Add to layer"
toolTip:	"Add to first selected layer \n or layer of last selected object."
icon:	"MENU:ADD to Layer"
autoUndoEnabled:true
(
	--on execute do
	----undo "Add to current layer " on
	--(
	--	current_layer = (LayersManager_v()).getCurrent()
	--
	--	current_layer.addNodes( selection )
	--)
	--
	on execute do
	--on altExecute type do
	(
		LayersManager = LayersManager_v()

		selected_layers_in_mngr = LayersManager.getSelectedByManager()

		if selected_layers_in_mngr.count > 1 then
		(
			selected_layers_in_mngr[1].addNodes( deleteItem _selection _selection.count )
		)
		else if selection.count >= 2 then
		(
			_selection = for o in selection collect o

			master_obj = _selection[_selection.count]

			master_obj.layer.addNodes( deleteItem _selection _selection.count )
		)
		else
			messageBox "Select Layer in manager \n\n or \n\nSelect 2 obejcts at least. \nObejcts will be added to layer of last selection object" title:"ADD TO LAYER"

	)

)

/* SELECT OBEJCTS IN LAYERS
*/
macroscript	layers_move_to_edit_layer
category:	"_Layers-2"
buttontext:	"Move to edit layer"
--toolTip:	"Select Objects of selected layers, or layers of selected objects."
icon:	"MENU:MOVE to edit layer"
autoUndoEnabled:true
(
	on execute do
		--undo "Select " on
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
toolTip:	"Select Objects of selected layers, or layers of selected objects \n\nMenu Option: Select objects in all nensted layers"
icon:	"MENU:Select OBJECTS"
autoUndoEnabled:true
(
	on execute do
		undo "Select Objects By Layer" on
		(
			LayersManager = LayersManager_v()

			selected_layers = LayersManager.getSelectedOrCurrent()

			select (LayersManager.getObjectsInLayers( selected_layers ))
		)

	on altExecute type do
	(
		LayersManager = LayersManager_v()

		selected_layers = LayersManager.getSelectedOrCurrent()

		layers_tree = (LayersManager.getNestedLayers(selected_layers))

		selectmore (LayersManager.getObjectsInLayers(layers_tree))
	)

)

/** SELECT CHILDREN LAYERS
 */
macroscript	_layers_manager_select_children_layer
category:	"_Layers-2"
buttontext:	"Select Child layers"
tooltip:	"Select Child layers \n\nMenu Option: Select all nensted layers"
icon:	"MENU:Select CHILD Layers"
autoUndoEnabled:true
(
	on execute do
	(
		LayersManager = LayersManager_v()

		selected_layers = LayersManager.getSelectedOrCurrent()

		layers_to_select = join selected_layers (LayersManager.getChildren(selected_layers))

		LayersManager.selectLayers ( layers_to_select )

		--LayersManager.selectLayersByObjects( for o in selection collect o )
	)

	on altExecute type do
	(
		LayersManager = LayersManager_v()

		selected_layers = LayersManager.getSelectedOrCurrent()

		LayersManager.selectLayers (LayersManager.getNestedLayers(selected_layers))

	)
)


/** SELECT BY OBEJCT
 */
macroscript	_layers_manager_select_layer_by_objects
category:	"_Layers-2"
buttontext:	"Select By Objects"
tooltip:	"Select layers by Objects"
icon:	"MENU:tooltip"
autoUndoEnabled:true
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
icon:	"MENU:true|Tooltip:Toggle layers with same prefix\n\nE.G.: _Name\prefix-\1-Name\n\n"
autoUndoEnabled:true
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
