/** Ref Source
 */
macroscript scenelayers_Ref_Source
category:	"_SceneLayers-Reference"
icon:	"MENU:true"
buttonText:	"Ref Source"
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
icon:	"MENU:true"
buttonText:	"Ref Edit"
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
icon:	"MENU:true"
buttonText:	"Ref Final"
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
icon:	"MENU:true"
buttonText:	"Ref Print"
(

	on execute do
	(
		(SceneLayers_v()).referenceTo #PRINT ( selection as Array )
	)
)

