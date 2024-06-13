/** Inst Source
 */
macroscript scenelayers_Inst_Source
category:	"_SceneLayers-Instance"
buttonText:	"Inst Source"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#INSTANCE layer_type: #SOURCE
	)
)

/** Inst Edit
 */
macroscript scenelayers_Inst_Edit
category:	"_SceneLayers-Instance"
buttonText:	"Inst Edit"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#INSTANCE layer_type: #EDIT
	)
)

/** Inst Final
 */
macroscript scenelayers_Inst_Final
category:	"_SceneLayers-Instance"
buttonText:	"Inst Final"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#INSTANCE layer_type: #FINAL
	)
)

/** Inst Print
 */
macroscript scenelayers_Inst_Print
category:	"_SceneLayers-Instance"
buttonText:	"Inst Print"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).moveToLayerType( selection as Array ) mode:#INSTANCE layer_type: #PRINT
	)
)

