/** Select Source
 */
macroscript scenelayers_Select_Source
category:	"_SceneLayers-Select"
buttonText:	"Select Source"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).selectIn #SOURCE ( selection as Array ) select_more:keyboard.controlPressed
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
		(SceneLayers_v()).selectIn #EDIT ( selection as Array ) select_more:keyboard.controlPressed
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
		(SceneLayers_v()).selectIn #FINAL ( selection as Array ) select_more:keyboard.controlPressed
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
		(SceneLayers_v()).selectIn #PRINT ( selection as Array ) select_more:keyboard.controlPressed
	)
)

