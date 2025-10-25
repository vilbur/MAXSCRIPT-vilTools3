/** Select Source
 */
macroscript scenelayers_Select_Source
category:	"_SceneLayers-Select"
icon:	"MENU:true"
buttonText:	"Select Source"
(

	on execute do
	(
		(SceneLayers_v()).selectIn #SOURCE ( selection as Array ) select_more:keyboard.controlPressed
	)
)

/** Select Edit
 */
macroscript scenelayers_Select_Edit
category:	"_SceneLayers-Select"
icon:	"MENU:true"
buttonText:	"Select Edit"
(

	on execute do
	(
		(SceneLayers_v()).selectIn #EDIT ( selection as Array ) select_more:keyboard.controlPressed
	)
)

/** Select Final
 */
macroscript scenelayers_Select_Final
category:	"_SceneLayers-Select"
icon:	"MENU:true"
buttonText:	"Select Final"
(

	on execute do
	(
		(SceneLayers_v()).selectIn #FINAL ( selection as Array ) select_more:keyboard.controlPressed
	)
)

/** Select Print
 */
macroscript scenelayers_Select_Print
category:	"_SceneLayers-Select"
icon:	"MENU:true"
buttonText:	"Select Print"
(

	on execute do
	(
		(SceneLayers_v()).selectIn #PRINT ( selection as Array ) select_more:keyboard.controlPressed
	)
)

