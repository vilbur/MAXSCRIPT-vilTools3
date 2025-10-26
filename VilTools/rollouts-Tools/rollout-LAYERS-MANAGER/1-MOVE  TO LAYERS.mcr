/** Move Source
 */
macroscript scenelayers_Move_Source
icon:	"MENU:true"
buttonText:	"Move Source"
category:	"_SceneLayers-Move"
(

	on execute do
	(
		(SceneLayers_v()).moveTo #SOURCE ( selection as Array )
	)
)

/** Move Edit
 */
macroscript scenelayers_Move_Edit
icon:	"MENU:true"
buttonText:	"Move Edit"
category:	"_SceneLayers-Move"
(

	on execute do
	(
		(SceneLayers_v()).moveTo #EDIT ( selection as Array )
	)
)

/** Move Final
 */
macroscript scenelayers_Move_Final
icon:	"MENU:true"
buttonText:	"Move Final"
category:	"_SceneLayers-Move"
(

	on execute do
	(
		(SceneLayers_v()).moveTo #FINAL ( selection as Array )
	)
)

/** Move Print
 */
macroscript scenelayers_Move_Print
icon:	"MENU:true"
buttonText:	"Move Print"
category:	"_SceneLayers-Move"
(

	on execute do
	(
		(SceneLayers_v()).moveTo #PRINT ( selection as Array )
	)
)

