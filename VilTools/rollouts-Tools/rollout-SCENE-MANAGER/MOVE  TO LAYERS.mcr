/** Move to Source
 */
macroscript scenelayers_Move_to_Source
category:	"_SceneLayers-Move"
buttonText:	"Move to Source"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#MOVE layer_type: #SOURCE
	)
)

/** Move to Edit
 */
macroscript scenelayers_Move_to_Edit
category:	"_SceneLayers-Move"
buttonText:	"Move to Edit"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#MOVE layer_type: #EDIT
	)
)

/** Move to Final
 */
macroscript scenelayers_Move_to_Final
category:	"_SceneLayers-Move"
buttonText:	"Move to Final"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#MOVE layer_type: #FINAL
	)
)

/** Move to Print
 */
macroscript scenelayers_Move_to_Print
category:	"_SceneLayers-Move"
buttonText:	"Move to Print"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#MOVE layer_type: #PRINT
	)
)

