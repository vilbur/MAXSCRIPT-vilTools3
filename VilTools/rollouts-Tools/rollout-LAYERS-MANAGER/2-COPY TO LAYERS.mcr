/** Copy Source
 */
macroscript scenelayers_Copy_Source
category:	"_SceneLayers-Copy"
buttonText:	"Copy Source"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#COPY layer_type: #SOURCE
	)
)

/** Copy Edit
 */
macroscript scenelayers_Copy_Edit
category:	"_SceneLayers-Copy"
buttonText:	"Copy Edit"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#COPY layer_type: #EDIT
	)
)

/** Copy Final
 */
macroscript scenelayers_Copy_Final
category:	"_SceneLayers-Copy"
buttonText:	"Copy Final"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#COPY layer_type: #FINAL
	)
)

/** Copy Print
 */
macroscript scenelayers_Copy_Print
category:	"_SceneLayers-Copy"
buttonText:	"Copy Print"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#COPY layer_type: #Print
	)
)

