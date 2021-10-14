filein( getFilenamePath(getSourceFileName()) + "/Lib/Layer.ms" )
/*
*/ 
macroscript	layers_rename_current_layer
category:	"_Layer"
buttontext:	"Rename"
toolTip:	"Rename current layer"
--icon:	"#(path, index)"
(
	temp_name	= "layer_rename_temp"
	current_layer	= LayerManager.current
	dialog	= dotNetObject "MaxCustomControls.RenameInstanceDialog" current_layer.name
	dialog.text	= "Rename layer"
	modal	= dialog.Showmodal()
	
	new_name = dialog.InstanceName
	
	current_layer.setName temp_name

	(LayerManager.getLayerFromName temp_name).setName new_name
	
)

/*
*/ 
macroscript layers_delete_empty_layers
category:	"_Layer" 
buttontext:	"Delete"
toolTip:	"Delete empty layers"

(
	default_layer	= LayerManager.getLayer 0
	default_layer.current	= true

	try
	(	
		_layercount	= for i = 1 to (LayerManager.count - 1) collect i
		_revlayers	= #()
		
		for i in _layercount.count to 1 by -1 do append _revlayers _layercount[i]
	
		for j in _revlayers do
		(
			_getlayer = LayerManager.getlayer j
			LayerManager.deleteLayerByName _getlayer.name
		)		
	)
	catch()
)


