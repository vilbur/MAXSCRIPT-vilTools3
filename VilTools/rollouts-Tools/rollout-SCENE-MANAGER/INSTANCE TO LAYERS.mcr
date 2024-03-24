/** Instaance to Source
 */
macroscript scenelayers_Instaance_to_Source
category:	"_SceneLayers-Instance"
buttonText:	"Instaance to Source"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayer( selection as Array ) mode:#INSTANCE layer_type: #SOURCE
	)
)

/** Instaance to Edit
 */
macroscript scenelayers_Instaance_to_Edit
category:	"_SceneLayers-Instance"
buttonText:	"Instaance to Edit"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayer( selection as Array ) mode:#INSTANCE layer_type: #EDIT
	)
)

/** Instaance to Final
 */
macroscript scenelayers_Instaance_to_Final
category:	"_SceneLayers-Instance"
buttonText:	"Instaance to Final"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayer( selection as Array ) mode:#INSTANCE layer_type: #FINAL
	)
)

/** Instaance to Print
 */
macroscript scenelayers_Instaance_to_Print
category:	"_SceneLayers-Instance"
buttonText:	"Instaance to Print"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayer( selection as Array ) mode:#INSTANCE layer_type: #PRINT
	)
)

