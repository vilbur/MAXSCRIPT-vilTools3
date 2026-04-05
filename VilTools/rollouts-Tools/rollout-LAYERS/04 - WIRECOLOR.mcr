
/** COLLAPSE SELECTED LAYERS
 */
macroscript	_layers_wirecolor_by_layer
category:	"_Layers-Wirecolor"
buttontext:	"WIRECOLOR"
tooltip:	"Toggle wirecolor by OBJECT \ LAYER\n\nALT IN MENU: Toggle all objects in layers"
icon:	"across:3|MENU:Wirecolor BY OBJECT"
(
	/* Toggle colorByLayer based on majority state
	   If more objects are true -> set all to false
	   If more objects are false -> set all to true */
	function toggleColorByLayer objs: apply_to_all_objects_in_layers:false =
	(
		true_count = 0
		false_count = 0
		
		if objs == unsupplied then
		(
			objs = ( if selection.count > 0 then selection else objects ) as Array
			
			/* GET ALL OBJECTS FROM LAYERS */ 
			if apply_to_all_objects_in_layers then
			(
				LayersManager = LayersManager_v()
		
				selected_layers = LayersManager.getSelectedOrCurrent()
					
				objs = LayersManager.getObjectsInLayers(selected_layers)
			)
		)
		
		/* HOW MANY OBJS HAS false\true */ 
		for o in objs do
			case o.colorByLayer of
			(
				true:  true_count  += 1
				false: false_count += 1
			)
		
		/* TOGGLE to other state fo majority of objects */ 
		target_state = false_count > true_count
		
		for o in objs do o.colorByLayer = target_state
		
		format "% objects has set colorByLayer to: %\n" objs.count target_state
	)
	
	/* TEST */
	on execute do
		toggleColorByLayer()
		
		
	on altExecute type do
		toggleColorByLayer apply_to_all_objects_in_layers:true
		
)


/** COLLAPSE SELECTED LAYERS
 */
macroscript	_layers_wirecolor_random
category:	"_Layers-Wirecolor"
buttontext:	"WIRECOLOR"
tooltip:	"Set random wirecolor to current layers"
icon:	"MENU:Wirecolor RANDOM"
(
	on execute do
	(
		LayersManager = LayersManager_v()

		selected_layers = LayersManager.getSelectedOrCurrent()
		--format "\n-----------\nARRAY:selected_layers:%\n" selected_layers; for selected_layer in selected_layers do format "selected_layer:	%\n" selected_layer.name
		--LayersManager.expand( selected_layers )
		
		for selected_layer in selected_layers do
			--format "selected_layer: %\n" selected_layer.name
			selected_layer.wirecolor = color ( random 0 255 ) ( random 0 255 ) ( random 0 255 )
		
	)
)

