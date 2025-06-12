/** Inst Source
 */
macroscript scenelayers_Inst_Source
category:	"_SceneLayers-Instance"
buttonText:	"Inst Source"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).InstanceTo #SOURCE ( selection as Array )
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
		(SceneLayers_v()).InstanceTo #EDIT ( selection as Array )
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
		(SceneLayers_v()).InstanceTo #FINAL ( selection as Array )
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
		(SceneLayers_v()).InstanceTo #PRINT ( selection as Array )
	)
)

