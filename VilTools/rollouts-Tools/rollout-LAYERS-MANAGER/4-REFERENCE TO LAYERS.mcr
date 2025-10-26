/** Ref Source
 */
macroscript scenelayers_Ref_Source
icon:	"MENU:true"
buttonText:	"Ref Source"
category:	"_SceneLayers-Reference"
(

	on execute do
	(
		(SceneLayers_v()).referenceTo #SOURCE ( selection as Array )
	)
)

/** Ref Edit
 */
macroscript scenelayers_Ref_Edit
icon:	"MENU:true"
buttonText:	"Ref Edit"
category:	"_SceneLayers-Reference"
(

	on execute do
	(
		(SceneLayers_v()).referenceTo #EDIT ( selection as Array )
	)
)

/** Ref Final
 */
macroscript scenelayers_Ref_Final
icon:	"MENU:true"
buttonText:	"Ref Final"
category:	"_SceneLayers-Reference"
(

	on execute do
	(
		(SceneLayers_v()).referenceTo #FINAL ( selection as Array )
	)
)

/** Ref Print
 */
macroscript scenelayers_Ref_Print
icon:	"MENU:true"
buttonText:	"Ref Print"
category:	"_SceneLayers-Reference"
(

	on execute do
	(
		(SceneLayers_v()).referenceTo #PRINT ( selection as Array )
	)
)

