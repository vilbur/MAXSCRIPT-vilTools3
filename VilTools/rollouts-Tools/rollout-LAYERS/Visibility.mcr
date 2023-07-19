filein( getFilenamePath(getSourceFileName()) + "/../rollout-LAYERS/Lib/LayersManager/LayersManager.ms" )	-- "./../rollout-LAYERS/Lib/LayersManager/LayersManager.ms"

/*------------------------------------------------------------------------------
	ISOLATE SELECTION
--------------------------------------------------------------------------------*/
--/*
--*/
--macroscript	visibility_only_layers_of_selection
--category:	"_Visibility"
--buttontext:	"Selected"
--toolTip:	"Show only layers of selected objects"
----icon:	"#(path, index)"
--(
--	undo "Show Only Layers Of Selection" on
--	(
--		(LayersManager_v()).isolateLayers( selection )
--	)
--)

/*------------------------------------------------------------------------------
	ON\OFF ALL
--------------------------------------------------------------------------------*/
/**
 *
 */
macroscript	visibility_all_on
category:	"_Layers"
buttontext:	"All On\ Off"
toolTip:	"All On\ Off"
--icon:	"Tooltip:" --"#(path, index)"
(
	all_layers = for i = 0 to LayerManager.count - 1 collect LayerManager.getLayer i

	for _layer in all_layers do
		_layer.on = true

)
/**
 *
 */
macroscript	visibility_all_off
category:	"_Layers"
buttontext:	"All On\ Off"
toolTip:	"All On\ Off"
--icon:	"Tooltip:" --"#(path, index)"
(
	all_layers = for i = 0 to LayerManager.count - 1 collect LayerManager.getLayer i

	for _layer in all_layers do
		_layer.on = false
)






/*------------------------------------------------------------------------------
	ON\OFF BY OBEJCTS
--------------------------------------------------------------------------------*/

/**
 *
 */
macroscript	visibility_on_by_selection
category:	"_Layers"
buttontext:	"On By Selection"
toolTip:	"On By Selection"
--icon:	"Tooltip:" --"#(path, index)"
(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Visibility.mcr"

	LayersManager = LayersManager_v()

	layers = LayersManager.getLayersByObjects( selection )

	LayersManager.setVisible( layers )

	LayersManager.setCurrent( layers )

)

/**
 *
 */
macroscript	visibility_on_by_selection_and_hide_obejcts_in_parent_layer
category:	"_Layers"
buttontext:	"On By Selection"
toolTip:	"On By Selection and hide obejcts in parent layers"
--icon:	"Tooltip:" --"#(path, index)"
(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Lib\LayersManager\LayersManager.ms"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Visibility.mcr"

	LayersManager = LayersManager_v()

	layers_of_selection = LayersManager.getLayersByObjects( selection )

	layers_in_hierarchy = LayersManager.setVisible( layers_of_selection )

	other_visible_layers =  for layers in layers_in_hierarchy where findItem layers_of_selection layers == 0 collect layers

	/* HIDE OBEJCTS IN OTHER LAYERS THEN SELECTED OBEJCTS */
	for obj in LayersManager.getObjectsInLayers( other_visible_layers ) where not obj.isHidden  do
		obj.isHidden = true

	LayersManager.setCurrent( layers_of_selection )
)



--/**
-- *
-- */
--macroscript	_layers_manager_turn_on
--category:	"_Layers"
--buttontext:	"Turn On"
--tooltip:	"Toggle visibility of selected layers in manager.\n\tActive layer is used if nothing is selected.\n\nIf layer is nested then turn on all its parents"
--(
--	--clearListener()
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Manage Layers.mcr"
--	on execute do
--	(
--
--		LayersManager = LayersManager_v()
--
--		selected_layers = getSelectedLayers()
--
--		if selected_layers.count == 0 then
--			selected_layers = #(LayerManager.current)
--
--		layers = selected_layers -- loop until bottom
--
--
--		/* LOOP HIERARCHY FROM BOTTOM TO TOP AND GET LAYERS */
--		for curent_layer in selected_layers do
--			while curent_layer.getParent() != undefined do
--				appendIfUnique layers (curent_layer = curent_layer.getParent())
--
--		for layer in layers do
--			layer.on = true
--	)
--)


--/*
--*/
--macroscript	visibility_off_selected
--category:	"_Layers"
--buttontext:	"Off Unselected"
--toolTip:	"Turn Off layers of unselcted obejcts"
----icon:	"#(path, index)"
--(
--	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-LAYERS\Visibility.mcr"
--
--	undo "Off Unselected" on
--	(
--
--		(LayersManager_v()).isolateLayers( selection )
--
--		layers_of_selected_objects = makeUniqueArray (for obj in selection collect obj.layer.name)
--
--
--		--/* SHOW OBJECTS IN SELECTION */
--		--for obj in selection where obj.isHidden do obj.isHidden = false
--		--
--		--/* GET VISIBLE OBJECTS */
--		--visible_objects = for obj in objects where obj.isHidden == false collect obj
--		--
--		--/* ISOLATE SELECTION OF OTHER OBEJCTS IN LAYER */
--		--if selection.count != visible_objects.count then
--		--	IsolateSelection.EnterIsolateSelectionMode()
--
--		--macros.run "Scene Explorer" "SECollapseAll"
--
--		--macros.run "Scene Explorer" "SEExpandSelected"
--
--
--	)
--)





--/*
--*/
--macroscript	visibility_isolate_selection
--category:	"_Layers"
--buttontext:	"Isolate"
--toolTip:	"Isolate selected objects and hide other layers"
----icon:	"#(path, index)"
--(
--	undo "Isolate Layers Of Selection" on
--	(
--		(LayersManager_v()).isolateLayers( selection )
--
--		layers_of_selected_objects = makeUniqueArray (for obj in selection collect obj.layer.name)
--
--		/* SHOW OBJECTS IN SELECTION */
--		for obj in selection where obj.isHidden do obj.isHidden = false
--
--		/* GET VISIBLE OBJECTS */
--		visible_objects = for obj in objects where obj.isHidden == false collect obj
--
--		/* ISOLATE SELECTION OF OTHER OBEJCTS IN LAYER */
--		if selection.count != visible_objects.count then
--			IsolateSelection.EnterIsolateSelectionMode()
--	)
--)



--/*
--*/
--macroscript	visibility_hide_selected
--category:	"_Visibility"
--buttontext:	"Hide"
--toolTip:	"Hide layers of selected objects"
----icon:	"#(path, index)"
--(
--	--(Layer_v()).setAllLayersVisible true
--	messageBox "Hide layers of selected objects" title:"Rclick"  beep:false
--)

/*------------------------------------------------------------------------------
	SHOW ALL LAYER
--------------------------------------------------------------------------------*/

--/*
--*/
--macroscript	visibility_unhide
--category:	"_Visibility"
--buttontext:	"All Layers"
--toolTip:	"Unhide all"
----icon:	"#(path, index)"
--(
--	--(Layer_v()).setAllLayersVisible true
--	--for i = 0 to LayerManager.count - 1 do (LayerManager.getLayer i).on = true
--	for i = 0 to LayerManager.count - 1 do (LayerManager.getLayer i).on = true
--)
--
--/*
--*/
--macroscript	visibility_unhide_matching_name
--category:	"_Visibility"
--buttontext:	"All Layers"
--toolTip:	"Show Layers without '_' prefix or default layer"
----icon:	"#(path, index)"
--(
--	pattern = "^_.*|^0$"
--	--pattern = ".*default.*"
--
--	local layer
--
--	for i = 0 to LayerManager.count - 1 where (_layer = LayerManager.getLayer i) != undefined do
--		_layer.on = not (( dotNetClass "System.Text.RegularExpressions.RegEx" ).match _layer.name pattern).success
--)
