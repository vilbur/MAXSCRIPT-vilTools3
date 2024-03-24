/** Move to objects own layer
 */
macroscript scenelayers_move_to_layer_by_object
category:	"_SceneLayers-Manage"
buttonText:	"Layer By Object"
tooltip:	"Creale Layer for each select object"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerByObject( selection as Array )
	)
)
