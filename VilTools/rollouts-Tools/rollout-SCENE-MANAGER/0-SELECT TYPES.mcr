/** Select Source
 */
macroscript scenelayers_Select_Source
category:	"_SceneLayers-Select"
buttonText:	"Select Source"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).selectLayerType( selection as Array ) select_more:keyboard.controlPressed layer_type: #SOURCE
	)
)

/** Select Edit
 */
macroscript scenelayers_Select_Edit
category:	"_SceneLayers-Select"
buttonText:	"Select Edit"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).selectLayerType( selection as Array ) select_more:keyboard.controlPressed layer_type: #EDIT
	)
)

/** Select Final
 */
macroscript scenelayers_Select_Final
category:	"_SceneLayers-Select"
buttonText:	"Select Final"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).selectLayerType( selection as Array ) select_more:keyboard.controlPressed layer_type: #FINAL
	)
)

/** Select Print
 */
macroscript scenelayers_Select_Print
category:	"_SceneLayers-Select"
buttonText:	"Select Print"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).selectLayerType( selection as Array ) select_more:keyboard.controlPressed layer_type: #PRINT
	)
)

