/** Copy Source
 */
macroscript scenelayers_Copy_Source
category:	"_SceneLayers-Copy"
icon:	"MENU:true"
buttonText:	"Copy Source"
(

	on execute do
	(
		(SceneLayers_v()).copyTo #SOURCE ( selection as Array )
	)
)

/** Copy Edit
 */
macroscript scenelayers_Copy_Edit
category:	"_SceneLayers-Copy"
icon:	"MENU:true"
buttonText:	"Copy Edit"
(

	on execute do
	(
		(SceneLayers_v()).copyTo #EDIT ( selection as Array )
	)
)

/** Copy Final
 */
macroscript scenelayers_Copy_Final
category:	"_SceneLayers-Copy"
icon:	"MENU:true"
buttonText:	"Copy Final"
(

	on execute do
	(
		(SceneLayers_v()).copyTo #FINAL ( selection as Array )
	)
)

/** Copy Print
 */
macroscript scenelayers_Copy_Print
category:	"_SceneLayers-Copy"
icon:	"MENU:true"
buttonText:	"Copy Print"
(

	on execute do
	(
		(SceneLayers_v()).copyTo #Print ( selection as Array )
	)
)

