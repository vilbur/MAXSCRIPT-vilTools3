/** Ref to Source
 */
macroscript scenelayers_Ref_to_Source
category:	"_SceneLayers-Reference"
buttonText:	"Ref to Source"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#REFERENCE layer_type: #SOURCE
	)
)

/** Ref to Edit
 */
macroscript scenelayers_Ref_to_Edit
category:	"_SceneLayers-Reference"
buttonText:	"Ref to Edit"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#REFERENCE layer_type: #EDIT
	)
)

/** Ref to Final
 */
macroscript scenelayers_Ref_to_Final
category:	"_SceneLayers-Reference"
buttonText:	"Ref to Final"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#REFERENCE layer_type: #FINAL
	)
)

/** Ref to Print
 */
macroscript scenelayers_Ref_to_Print
category:	"_SceneLayers-Reference"
buttonText:	"Ref to Print"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#REFERENCE layer_type: #PRINT
	)
)

