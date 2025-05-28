
/* NEW LAYER
*/
macroscript	layers_new_layer
category:	"_Layers-Manage"
buttontext:	"New Layer"
--toolTip:	"Select Objects of selected layers, or layers of selected objects."
icon:	"MENU:NEW Layer|across:2"
(
	undo "Select " on
	(
		LayersManager = LayersManager_v()

		selected_layers = LayersManager.getSelectedOrCurrent()

		parent_layer = selected_layers[1]

		parent_layer_name = if parent_layer != undefined then parent_layer.name else ""

		-- instantiate the object
		--default_text	= "default_text"
		_dotNet	= dotNetObject "MaxCustomControls.RenameInstanceDialog" parent_layer_name
		_dialog_result	= dotNetClass "System.Windows.Forms.DialogResult"

		_dotNet.ShowModal()

		_ok 	= dotNet.comparEenums (_dotNet.DialogResult) ( _dialog_result.Ok )
		_canel	= dotNet.comparEenums (_dotNet.DialogResult) ( _dialog_result.Cancel )
		--_string	= _dotNet.InstanceName

		if( _ok and (_string = _dotNet.InstanceName) != ""  ) then
		(
			newLayer = LayersManager.newLayer(_string) parent:parent_layer

			newLayer.addNodes( selection )

			newLayer.addNodes( selection )
		)
	)
)

/* NEW LAYER BY MATERIAL
*/
macroscript	layers_new_layer_by_material
category:	"_Layers-Manage"
buttontext:	"New Layer by MAT"
--toolTip:	"Select Objects of selected layers, or layers of selected objects."
icon:	"MENU:NEW Layer|across:2"
(
	undo "Select by material" on
	(
		LayersManager = LayersManager_v()

		_selection = for o in selection where o.material != undefined collect o

		materials_selection =  makeUniqueArray (for obj in _selection collect obj.material.name )

		for mat_name in materials_selection do
		(
			objects_with_mat =  for obj in _selection where obj.material.name == mat_name collect obj

			parent_layer = objects_with_mat[1].layer


			if (obj_layer = LayerManager.getLayerFromName mat_name ) == undefined then
				obj_layer = LayersManager.newLayer(mat_name) parent:parent_layer

			obj_layer.addNodes( objects_with_mat )

		)
	)
)