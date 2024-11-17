
/*------------------------------------------------------------------------------
	EXPAND \ COLLAPSE
--------------------------------------------------------------------------------*/

/** EXPAND SELECTED LAYERS
 */
macroscript	_layers_expand_layers_of_selection
category:	"_Layers-Manage"
buttontext:	"Expand Layers"
tooltip:	"Expand layers of selection.\n\nOptionable in menu: Auto Expand Layer Manager"
icon:	"MENU:EXPAND Layers|across:3"
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


/** CLONE LAYERS
 */
macroscript	_layers_manager_clone_layers
category:	"_Layers-Manage"
buttontext:	"Clone Layers"
tooltip:	"Copy selected objects to new layers"
icon:	"MENU:CLONE Layers"
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
