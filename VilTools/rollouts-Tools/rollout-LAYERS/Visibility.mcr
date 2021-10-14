
/*
*/ 
macroscript	layer_all_layers_hide
category:	"_Layer"
buttontext:	"Active"
toolTip:	"Hide inactive layers or selected objects"
--icon:	"#(path, index)"
(
	_Layer = Layer_v()
	
	selection_layers	= #()
	
		for obj in selection do
			appendIfUnique selection_layers obj.layer

	_Layer.setAllLayersVisible false exclude:selection_layers
	
	
	if( selection.count == 0 ) then
		(_Layer.getActiveLayer()).on = true
)


/*
*/ 
macroscript	layer_all_layers_show
category:	"_Layer"
buttontext:	"Active"
toolTip:	"Show all layers"
--icon:	"#(path, index)"
(
	(Layer_v()).setAllLayersVisible true
)