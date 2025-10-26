/** Copy Source
 */
macroscript scenelayers_Copy_Source
icon:	"MENU:true"
buttonText:	"Copy Source"
category:	"_SceneLayers-Copy"
(

	on execute do
	(
		(SceneLayers_v()).copyTo #SOURCE ( selection as Array )
	)
)

/** Copy Edit
 */
macroscript scenelayers_Copy_Edit
icon:	"MENU:true"
buttonText:	"Copy Edit"
category:	"_SceneLayers-Copy"
(

	on execute do
	(
		(SceneLayers_v()).copyTo #EDIT ( selection as Array )
	)
)

/** Copy Final
 */
macroscript scenelayers_Copy_Final
icon:	"MENU:true"
buttonText:	"Copy Final"
category:	"_SceneLayers-Copy"
(

	on execute do
	(
		(SceneLayers_v()).copyTo #FINAL ( selection as Array )
	)
)

/** Copy Print
 */
macroscript scenelayers_Copy_Print
icon:	"MENU:true"
buttonText:	"Copy Print"
category:	"_SceneLayers-Copy"
(

	on execute do
	(
		(SceneLayers_v()).copyTo #Print ( selection as Array )
	)
)

