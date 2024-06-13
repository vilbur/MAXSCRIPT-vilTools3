/** Ref Source
 */
macroscript scenelayers_Ref_Source
category:	"_SceneLayers-Reference"
buttonText:	"Ref Source"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#REFERENCE layer_type: #SOURCE
	)
)

/** Ref Edit
 */
macroscript scenelayers_Ref_Edit
category:	"_SceneLayers-Reference"
buttonText:	"Ref Edit"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#REFERENCE layer_type: #EDIT
	)
)

/** Ref Final
 */
macroscript scenelayers_Ref_Final
category:	"_SceneLayers-Reference"
buttonText:	"Ref Final"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#REFERENCE layer_type: #FINAL
	)
)

/** Ref Print
 */
macroscript scenelayers_Ref_Print
category:	"_SceneLayers-Reference"
buttonText:	"Ref Print"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#REFERENCE layer_type: #PRINT
	)
)

