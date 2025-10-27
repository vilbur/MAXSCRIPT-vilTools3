/** Ref Source
 */
macroscript scenelayers_Ref_Source
category:	"_SceneLayers-Reference"
buttonText:	"Ref Source"
icon:	"MENU:true"
(

	on execute do
	(
		(SceneLayers_v()).referenceTo #SOURCE ( selection as Array )
	)
)

/** Ref Edit
 */
macroscript scenelayers_Ref_Edit
category:	"_SceneLayers-Reference"
buttonText:	"Ref Edit"
icon:	"MENU:true"
(

	on execute do
	(
		(SceneLayers_v()).referenceTo #EDIT ( selection as Array )
	)
)

/** Ref Final
 */
macroscript scenelayers_Ref_Final
category:	"_SceneLayers-Reference"
buttonText:	"Ref Final"
icon:	"MENU:true"
(

	on execute do
	(
		(SceneLayers_v()).referenceTo #FINAL ( selection as Array )
	)
)

/** Ref Print
 */
macroscript scenelayers_Ref_Print
category:	"_SceneLayers-Reference"
buttonText:	"Ref Print"
icon:	"MENU:true"
(

	on execute do
	(
		(SceneLayers_v()).referenceTo #PRINT ( selection as Array )
	)
)

