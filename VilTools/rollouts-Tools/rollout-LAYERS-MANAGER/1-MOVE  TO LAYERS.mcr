/** Move Source
 */
macroscript scenelayers_Move_Source
category:	"_SceneLayers-Move"
icon:	"MENU:true"
buttonText:	"Move Source"
(

	on execute do
	(
		(SceneLayers_v()).moveTo #SOURCE ( selection as Array )
	)
)

/** Move Edit
 */
macroscript scenelayers_Move_Edit
category:	"_SceneLayers-Move"
icon:	"MENU:true"
buttonText:	"Move Edit"
(

	on execute do
	(
		(SceneLayers_v()).moveTo #EDIT ( selection as Array )
	)
)

/** Move Final
 */
macroscript scenelayers_Move_Final
category:	"_SceneLayers-Move"
icon:	"MENU:true"
buttonText:	"Move Final"
(

	on execute do
	(
		(SceneLayers_v()).moveTo #FINAL ( selection as Array )
	)
)

/** Move Print
 */
macroscript scenelayers_Move_Print
category:	"_SceneLayers-Move"
icon:	"MENU:true"
buttonText:	"Move Print"
(

	on execute do
	(
		(SceneLayers_v()).moveTo #PRINT ( selection as Array )
	)
)

