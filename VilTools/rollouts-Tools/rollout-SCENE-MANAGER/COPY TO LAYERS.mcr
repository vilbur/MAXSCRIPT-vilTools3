/** Copy to Source
 */
macroscript scenelayers_Copy_to_Source
category:	"_SceneLayers-Copy"
buttonText:	"Copy to Source"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayer( selection as Array ) mode:#COPY layer_type: #SOURCE
	)
)

/** Copy to Edit
 */
macroscript scenelayers_Copy_to_Edit
category:	"_SceneLayers-Copy"
buttonText:	"Copy to Edit"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayer( selection as Array ) mode:#COPY layer_type: #EDIT
	)
)

/** Copy to Final
 */
macroscript scenelayers_Copy_to_Final
category:	"_SceneLayers-Copy"
buttonText:	"Copy to Final"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayer( selection as Array ) mode:#COPY layer_type: #FINAL
	)
)

/** Copy to Print
 */
macroscript scenelayers_Copy_to_Print
category:	"_SceneLayers-Copy"
buttonText:	"Copy to Print"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayer( selection as Array ) mode:#COPY layer_type: #PRINT
	)
)

