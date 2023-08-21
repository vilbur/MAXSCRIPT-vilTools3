
/*------------------------------------------------------------------------------
	EXPAND \ COLLAPSE
--------------------------------------------------------------------------------*/

/** EXPAND SELECTED LAYERS
 */
macroscript	_layers_expand_layers_of_selection
category:	"_Layers-Manage"
buttontext:	"Expand Layers"
tooltip:	"Expand layers of selection.\n\nOptionable in menu: Auto Expand Layer Manager"
icon:	"MENU:EXPAND Layers"
(
	on execute do
	(
		clearListener(); print("Cleared in:"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Manage Layers.mcr"
		LayersManager = LayersManager_v()

		selected_layers = LayersManager.getSelectedOrCurrent()
		format "\n-----------\nARRAY:selected_layers:%\n" selected_layers; for selected_layer in selected_layers do format "selected_layer:	%\n" selected_layer.name
		LayersManager.expand( selected_layers )
	)

	on altExecute type do
	(
		state = not (SceneExplorerManager.GetActiveExplorer()).AutoExpand

		(SceneExplorerManager.GetActiveExplorer()).AutoExpand = state
		print ("AUTO EXPAND OF LAYERS MANAGER: " + toUpper (state as string ) )
	)
)

/** COLLAPSE SELECTED LAYERS
 */
macroscript	_layers_collapse_all_layers
category:	"_Layers-Manage"
buttontext:	"Collapse Layers"
tooltip:	"Collapse Layers in manager"
icon:	"MENU:COLLAPSE Layers"
(
	on execute do
		(LayersManager_v()).CollapseAll()
)

/* SELECT OBEJCTS IN LAYERS
*/
macroscript	layers_select_all_objects_selection
category:	"_Layers-Manage"
buttontext:	"Select Objects"
toolTip:	"Select Objects of selected layers, or layers of selected objects."
icon:	"MENU:true|title:SELECT Objects"
(
	undo "Select " on
	(
		LayersManager = LayersManager_v()

		selected_layers = LayersManager.getSelectedOrCurrent()

		select (LayersManager.getObjectsInLayers( selected_layers ))
	)
)

/* ADD TO CURRENT LAYER
*/
macroscript	layers_add_selection_to_current_layer
category:	"_Layers-Manage"
buttontext:	"Add to Layer"
toolTip:	"Add selection to current layer."
icon:	"MENU:true"
(
	undo "Add to current layer " on
	(
		layer_current = (LayersManager_v()).getCurrent()
		--format "layer_current:	% \n" layer_current
		for obj in selection do
			layer_current.addNode obj
	)
)



/** SELECT BY PREFIX
 */
macroscript	_layers_manager_select_layer_by_prefix
category:	"_Layers-Manage"
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

/** SELECT BY OBEJCT
 */
macroscript	_layers_manager_select_layer_by_objects
category:	"_Layers-Manage"
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
/** SELECT CHILDREN LAYERS
 */
macroscript	_layers_manager_select_children_layer
category:	"_Layers-Manage"
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

/** CLONE LAYERS
 */
macroscript	_layers_manager_clone_layers
category:	"_Layers-Manage"
buttontext:	"Clone Layers"
tooltip:	"Copy selected objects to new layers"
icon:	"MENU:true"
(
	undo "Clone Layers" on
	(

		--/** Ask string dialog
		-- */
		--function askStringDialog =
		--(
		--	--format "\n"; print ".askStringDialog()"
		--	-- instantiate the object
		--	_dotNet = dotNetObject "MaxCustomControls.RenameInstanceDialog" "Default text"
		--	_dotNet = dotNetObject "MaxCustomControls.RenameInstanceDialog" "Default text"
		--	_dotNet.text ="Title"
		--
		--	DialogResult = _dotNet.Showmodal()
		--
		--	--test if the ok button was pressed
		--	dotnet.compareenums TheObj.DialogResult ((dotnetclass "System.Windows.Forms.DialogResult").OK)
		--	--get the new text string
		--	entered_string = _dotNet.InstanceName
		--
		--	format "entered_string	= % \n" entered_string
		--)

		/* SUFFIX TO ADD TO NEW LAYERS */

		suffix = "-COPY"

		/* FUNCTION TO GET OR CREATE A LAYER FROM A NAME */
		function getOrCreateLayerFromName layerName =
		(
			new_layer = layermanager.getLayerFromName layerName

			if new_layer == undefined do
				new_layer = layermanager.newLayerFromName layerName

			new_layer
		)

		/* GET THE CURRENT SELECTION */
		_selection = getCurrentSelection()

		/* CLONE THE NODES */
		maxOps.cloneNodes _selection cloneType:#copy actualNodeList:_selection newNodes:&new_objs

		/* ITERATE THE SELECTION TO ORGANIZE THE NEW NODES INTO NEW LAYERS */
		for o = 1 to _selection.count do
		(
			/* CREATE THE LAYER IF NEEDED */
			old_layer = _selection[o].layer

			new_layer = getOrCreateLayerFromName (old_layer.name + suffix)

			/* ADD THE CLONED OBJECT TO THE NEW LAYER */
			new_layer.addNode new_objs[o]

			/* CHECK THE PARENT OF THE OLD LAYER */
			parent_layer = old_layer.getParent()

			if parent_layer != undefined do
			(
				newParent = getOrCreateLayerFromName (parent_layer.name + suffix)
				new_layer.setParent newParent
			)
		)

		select new_objs
	)
)
