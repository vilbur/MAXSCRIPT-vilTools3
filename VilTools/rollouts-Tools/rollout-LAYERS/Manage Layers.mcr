/*------------------------------------------------------------------------------
	LAYERS MANGER
------------------------------------------------------------------------------*/

/**
 */
function showLayerManagerCallback =
(
	try( callbacks.addScript #filePostOpenProcess "showLayerManagerCallback()" id:#showLayerManagerCallback )catch()

	if not LayerManager.isDialogOpen()  then
		LayerManager.editLayerByName ""
)


/**
 */
macroscript	layers_manager_autorun
category:	"_Layers"
buttontext:	"Layer Manager"
tooltip:	"Show\Hide Layer Manager.\n\nIf checked, then manager is open on scene open"
icon:	"control:checkbutton"
(
	--format "EventFired:	% \n" EventFired

	on execute do
		if EventFired == undefined or (EventFired != undefined and EventFired.val) then -- run on startup if no fire by event
		(
			--LayerManager.editLayerByName ""
			showLayerManagerCallback()
		)
		else
		(
			LayerManager.closeDialog()

			try( callbacks.removeScripts #filePostOpenProcess id:#showLayerManagerCallback )catch()
		)
)



/**
 */
macroscript	layers_manager_toogle_dialog
category:	"_Layers"
buttontext:	"Layer Toogle"
tooltip:	"Open Manager Toogle Window.\n\nCreate for each layer of selected layer or object"
icon:	"control:checkbutton"
(
	--format "EventFired:	% \n" EventFired

	on execute do
	(
		filein( getFilenamePath(getSourceFileName()) + "/Lib/LayersToogleDialog/LayersToogleDialog.ms" ) -- "./Lib/LayersToogleDialog/LayersToogleDialog.ms"

		LayersToogleDialog = LayersToogleDialog_v()
	)

)



/**
 */
macroscript	_layers_manager_toggle
category:	"_Layers"
buttontext:	"Scene Explorer"
tooltip:	"Show\Hide Scene Explorer.\n\nIf checked, then manager is open on scene open"
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
macroscript	_layers_expand_layers_of_selection
category:	"_Layers"
buttontext:	"Expand Selection"
tooltip:	"Expand layers of selection.\n\nOptionable in menu: Auto Expand Layer Manager"
icon:	"MENU:true|title:EXPAND Selection"
(
	on execute do
	(
		LayersManager = LayersManager_v()

		LayersManager.expandLayersByObejcts( selection )
	)

	on altExecute type do
	(
		(SceneExplorerManager.GetActiveExplorer()).AutoExpand = not (SceneExplorerManager.GetActiveExplorer()).AutoExpand
	)


)

/*
*/
macroscript	layers_select_all_objects_selection
category:	"_Layers"
buttontext:	"Select Objects"
toolTip:	"Select Objects of selected layers\objects."
icon:	"MENU:true|title:SELECT Objects"
(
	undo "Select " on
	(
		(LayersManager_v()).isolateLayers( selection )
	)
)

/*
*/
macroscript	layers_add_selection_to_current_layer
category:	"_Layers"
buttontext:	"Add to current layer"
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


/**
 */
macroscript	_layers_manager_clone_layers
category:	"_Layers"
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
