/** Instance to Source
 */
macroscript scenelayers_Instance_to_Source
category:	"_SceneLayers-Instance"
buttonText:	"Instance to Source"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#INSTANCE layer_type: #SOURCE
	)
)

/** Instance to Edit
 */
macroscript scenelayers_Instance_to_Edit
category:	"_SceneLayers-Instance"
buttonText:	"Instance to Edit"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#INSTANCE layer_type: #EDIT
	)
)

/** Instance to Final
 */
macroscript scenelayers_Instance_to_Final
category:	"_SceneLayers-Instance"
buttonText:	"Instance to Final"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#INSTANCE layer_type: #FINAL
	)
)

/** Instance to Print
 */
macroscript scenelayers_Instance_to_Print
category:	"_SceneLayers-Instance"
buttonText:	"Instance to Print"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#INSTANCE layer_type: #PRINT
	)
)

