filein( getFilenamePath(getSourceFileName()) + "/../rollout-LAYERS/Lib/LayersManager/LayersManager.ms" )	-- "./../rollout-LAYERS/Lib/LayersManager/LayersManager.ms"

/*------------------------------------------------------------------------------
	ISOLATE SELECTION
--------------------------------------------------------------------------------*/
/*
*/
macroscript	layer_isolate_selection
category:	"_Scene"
buttontext:	"Isolate Selection"
toolTip:	"Show only layers of selected objects\n\nActivate layer of first selected object"
--icon:	"#(path, index)"
(
	undo "Isolate Selection" on
	(
		(LayersManager_v()).isolateLayers( selection )

		layers_of_selected_objects = makeUniqueArray (for obj in selection collect obj.layer.name)

		/* SHOW OBJECTS IN SELECTION */
		for obj in selection where obj.isHidden do obj.isHidden = false

		/* GET VISIBLE OBJECTS */
		visible_objects = for obj in objects where obj.isHidden == false collect obj

		/* ISOLATE SELECTION OF OTHER OBEJCTS IN LAYER */
		if selection.count != visible_objects.count then
			IsolateSelection.EnterIsolateSelectionMode()
	)
)



/*------------------------------------------------------------------------------
	SHOW ONLY LAYERS OF SELECTION
--------------------------------------------------------------------------------*/
/*
*/
macroscript	layer_isolate_layers
category:	"_Scene"
buttontext:	"Isolate Layers"
toolTip:	"Show only layers of selected objects\n\nActivate layer of first selected object"
--icon:	"#(path, index)"
(
	undo "Isolate Layers" on
		(LayersManager_v()).isolateLayers( selection )
)


--/*
--*/
--macroscript	layer_hide_selected
--category:	"_Scene"
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

/*
*/
macroscript	layer_unhide
category:	"_Scene"
buttontext:	"All Layers"
toolTip:	"Unhide all"
--icon:	"#(path, index)"
(
	--(Layer_v()).setAllLayersVisible true
	--for i = 0 to LayerManager.count - 1 do (LayerManager.getLayer i).on = true
	for i = 0 to LayerManager.count - 1 do (LayerManager.getLayer i).on = true
)

/*
*/
macroscript	layer_unhide_matching_name
category:	"_Scene"
buttontext:	"All Layers"
toolTip:	"Show Layers without '_' prefix or default layer"
--icon:	"#(path, index)"
(
	pattern = "^_.*|^0$"
	--pattern = ".*default.*"

	local layer

	for i = 0 to LayerManager.count - 1 where (_layer = LayerManager.getLayer i) != undefined do
		_layer.on = not (( dotNetClass "System.Text.RegularExpressions.RegEx" ).match _layer.name pattern).success
)
