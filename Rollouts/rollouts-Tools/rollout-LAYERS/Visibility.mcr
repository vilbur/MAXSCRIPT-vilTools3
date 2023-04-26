/*------------------------------------------------------------------------------
	HIDE
--------------------------------------------------------------------------------*/
/*
*/
macroscript	layer_hide_unselected
category:	"_Layer"
buttontext:	"Hide"
toolTip:	"Show only layers of selected objects\n\nActivate layer of first selected object"
--icon:	"#(path, index)"
(
	undo "HIde Layers" on
	(

		all_layers       = for i = 0 to LayerManager.count - 1 collect LayerManager.getLayer i

		layer_of_selected_objects = makeUniqueArray (for obj in selection collect obj.layer)

		for _layer in all_layers where findItem layer_of_selected_objects _layer == 0 do _layer.on = false


		active_layer = for layer_of_selected_object in layer_of_selected_objects where layer_of_selected_object.current collect layer_of_selected_object



		if active_layer.count == 0 then
			selection[1].layer .current  = true

		--current_layer	= LayerManager.getLayer 1

	)
)


/*
*/
macroscript	layer_hide_selected
category:	"_Layer"
buttontext:	"Hide"
toolTip:	"Hide layers of selected objects"
--icon:	"#(path, index)"
(
	--(Layer_v()).setAllLayersVisible true
	messageBox "Hide layers of selected objects" title:"Rclick"  beep:false


)

/*------------------------------------------------------------------------------
	UNHIDE
--------------------------------------------------------------------------------*/

/*
*/
macroscript	layer_unhide
category:	"_Layer"
buttontext:	"Unhide"
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
category:	"_Layer"
buttontext:	"Unhide"
toolTip:	"Unhide all layers without '_' prefix or default layer"
--icon:	"#(path, index)"
(
	pattern = "^_.*|^0$"
	--pattern = ".*default.*"

	local layer

	for i = 0 to LayerManager.count - 1 where (_layer = LayerManager.getLayer i) != undefined do
		_layer.on = not (( dotNetClass "System.Text.RegularExpressions.RegEx" ).match _layer.name pattern).success
)



/*------------------------------------------------------------------------------
	LAYER MANGER
--------------------------------------------------------------------------------*/


/**
 */
function showLayerManagerCallback =
(

	LayerManager.editLayerByName ""
)


/**
 */
macroscript	_options_layer_manager_toggle
category:	"_Layer"
buttontext:	"Layer Manager"
tooltip:	"Show\Hide Layoer manager on scene open"
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








