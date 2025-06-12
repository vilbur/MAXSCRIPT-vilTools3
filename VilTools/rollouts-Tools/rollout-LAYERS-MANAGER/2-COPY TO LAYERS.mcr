/** Copy Source
 */
macroscript scenelayers_Copy_Source
category:	"_SceneLayers-Copy"
buttonText:	"Copy Source"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).copyTo #SOURCE ( selection as Array )
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
		(SceneLayers_v()).copyTo #EDIT ( selection as Array )
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
		(SceneLayers_v()).copyTo #FINAL ( selection as Array )
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
		(SceneLayers_v()).copyTo #Print ( selection as Array )
	)
)

