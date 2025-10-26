/** Select Source
 */
macroscript scenelayers_Select_Source
icon:	"MENU:true"
buttonText:	"Select Source"
category:	"_SceneLayers-Select"
(

	on execute do
	(
		(SceneLayers_v()).selectIn #SOURCE ( selection as Array ) select_more:keyboard.controlPressed
	)
)

/** Select Edit
 */
macroscript scenelayers_Select_Edit
icon:	"MENU:true"
buttonText:	"Select Edit"
category:	"_SceneLayers-Select"
(

	on execute do
	(
		(SceneLayers_v()).selectIn #EDIT ( selection as Array ) select_more:keyboard.controlPressed
	)
)

/** Select Final
 */
macroscript scenelayers_Select_Final
icon:	"MENU:true"
buttonText:	"Select Final"
category:	"_SceneLayers-Select"
(

	on execute do
	(
		(SceneLayers_v()).selectIn #FINAL ( selection as Array ) select_more:keyboard.controlPressed
	)
)

/** Select Print
 */
macroscript scenelayers_Select_Print
icon:	"MENU:true"
buttonText:	"Select Print"
category:	"_SceneLayers-Select"
(

	on execute do
	(
		(SceneLayers_v()).selectIn #PRINT ( selection as Array ) select_more:keyboard.controlPressed
	)
)

