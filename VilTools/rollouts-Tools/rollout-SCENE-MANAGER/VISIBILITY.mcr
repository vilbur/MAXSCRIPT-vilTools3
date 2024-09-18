/** Vis Source
 */
macroscript scenelayers_Vis_Source
category:	"_SceneLayers-Visibility"
buttonText:	"Vis Source"
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #SOURCE
	)
)

/** Vis Edit
 */
macroscript scenelayers_Vis_Edit
category:	"_SceneLayers-Visibility"
buttonText:	"Vis Edit"
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #EDIT
	)
)

/** Vis Final
 */
macroscript scenelayers_Vis_Final
category:	"_SceneLayers-Visibility"
buttonText:	"Vis Final"
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #FINAL
	)
)

/** Vis Print
 */
macroscript scenelayers_Vis_Print
category:	"_SceneLayers-Visibility"
buttonText:	"Vis Print"
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #PRINT
	)
)

