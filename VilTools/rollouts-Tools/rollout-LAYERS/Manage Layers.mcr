/*------------------------------------------------------------------------------
	LAYERS MANGER
--------------------------------------------------------------------------------*/

/**
 */
macroscript	_layers_manager_toggle
category:	"_Layers"
buttontext:	"Open Manager"
tooltip:	"Show\Hide Layer manager & Scene Explorer"
(
	LayerManager.editLayerByName ""

	if not SceneExplorerManager.ExplorerExists(default_explorer = "Scene Explorer") then
		SceneExplorerManager.CreateExplorerFromDefault(default_explorer)
	else
		SceneExplorerManager.OpenExplorer(default_explorer)
)

/**
  *
  * http://www.scriptspot.com/forums/3ds-max/general-scripting/select-layers
 */
macroscript	_layers_manager_select_same_prefix
category:	"_Layers"
buttontext:	"Select by prefix"
tooltip:	"Select all layers starting with same prefix\n\nE.G.: '_Name|prefix-|1-Name' "
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Manage Layers.mcr"
	function selectLayers str =
	(
		clearSelection()

		for i = 1 to LayerManager.count-1 where matchPattern (LayerManager.getLayer i).name pattern:(str +"*") do
		(
			(LayerManager.getLayer i).select on
		)
	)

	LayerMngr = SceneExplorerManager.GetActiveExplorer()

	layers_arr = LayerMngr.SelectedItems()

	if layers_arr.count > 0 do
	(
		layer_name = trimLeft layers_arr[1].name

		matches = ( dotNetClass "System.Text.RegularExpressions.RegEx" ).matches layer_name "^([^A-Za-z]+).*" ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase

		if matches.count > 0 then
			prefix = matches.item[0].groups.item[1].value -- get second item from firs array

		else if (string_split = filterString layer_name "-_ ").count > 0 then
			prefix = string_split[1]
		else
			prefix = layer_name

		selectLayers(prefix)
	)
)

/**
 */
macroscript	_layers_manager_clone_layers
category:	"_Layers"
buttontext:	"Clone Layers"
tooltip:	"Copy selected objects to new layers"
(
	undo "Clone Layers" on
	(
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
