/*------------------------------------------------------------------------------
	LAYERS MANGER
------------------------------------------------------------------------------*/

/**
 */
function showLayerManagerCallback =
(
	LayerManager.editLayerByName ""
)

/**
 */
macroscript	layers_manager_autorun
category:	"_Layers"
buttontext:	"Layer Manager"
tooltip:	"Show\Hide Layer manager on scene open"
icon:	"control:checkbutton"
(
	if EventFired.val then
	(
		LayerManager.editLayerByName ""

		try( callbacks.addScript #filePostOpenProcess "showLayerManagerCallback()" id:#showLayerManagerCallback )catch()
	)
	else
	(
		LayerManager.closeDialog()

		try( callbacks.removeScripts #filePostOpenProcess id:#showLayerManagerCallback )catch()
	)
)


/**
 */
macroscript	_layers_manager_toggle
category:	"_Layers"
buttontext:	"Open Manager"
tooltip:	"Show\Hide Layer manager & Scene Explorer"
(
	--messageBox "Yupiii" title:"Title"  beep:false
	LayerManager.editLayerByName ""

	if not SceneExplorerManager.ExplorerExists(default_explorer = "Scene Explorer") then
		SceneExplorerManager.CreateExplorerFromDefault(default_explorer)
	else
		SceneExplorerManager.OpenExplorer(default_explorer)
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

/**
 */
macroscript	_layers_expand_layers_of_selection
category:	"_Layers"
buttontext:	"Expand Selection"
tooltip:	"Expand layers of selection"
icon:	"menu:true"
(
	LayersManager = LayersManager_v()

	LayersManager.expandLayersByObejcts( selection )
)

/*
*/
macroscript	layers_select_all_objects_selection
category:	"_Layers"
buttontext:	"Select Objects"
toolTip:	"Select Objects of selected layers\objects."
icon:	"menu:true"
(
	undo "Slect " on
	(
		(LayersManager_v()).isolateLayers( selection )
	)
)
/**
 */
macroscript	_layers_activate_curent_layer_of_selection
category:	"_Layers"
buttontext:	"Acivate Selection"
tooltip:	"Acivate layers of selection"
icon:	"menu:tooltip"
(
	LayersManager = LayersManager_v()

	selected_layers = LayersManager.getSelectLayersOrBySelection()

	LayersManager.setCurrent( selected_layers )

)

--/**
-- */
--macroscript	_layers_select_objects_of_selection
--category:	"_Layers"
--buttontext:	"Select objects"
--icon:	"Tooltip:'Select objects of selected layers\objects.\n'"
--(
--	messageBox "Manage Layers" title:"Title"  beep:false
--	LayersManager = LayersManager_v()
--
--	selected_layers = LayersManager.getSelectLayersOrBySelection()
--
--	--select (LayersManager.getObjectsInLayers(selected_layers))
--
--)
