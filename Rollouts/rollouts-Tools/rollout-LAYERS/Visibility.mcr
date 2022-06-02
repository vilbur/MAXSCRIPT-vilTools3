
/*
*/ 
macroscript	layer_hide_unselected
category:	"_Layer"
buttontext:	"Hide"
toolTip:	"Hide layers of unselected objects"
--icon:	"#(path, index)"
(

	all_layers       = for i = 0 to LayerManager.count - 1 collect LayerManager.getLayer i
	
	selection_layers = makeUniqueArray (for obj in selection collect obj.layer)

	
	for _layer in all_layers where findItem selection_layers _layer == 0 do _layer.on = false

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