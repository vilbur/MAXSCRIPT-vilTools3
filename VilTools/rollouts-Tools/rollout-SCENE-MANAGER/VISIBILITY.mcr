/** Vis Vis Source
 */
macroscript scenelayers_Vis_Source
category:	"_SceneLayers-Visibility"
buttonText:	"Vis Vis Source"
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #SOURCE
	)
)

/** Vis Vis Edit
 */
macroscript scenelayers_Vis_Edit
category:	"_SceneLayers-Visibility"
buttonText:	"Vis Vis Edit"
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #EDIT
	)
)

/** Vis Vis Final
 */
macroscript scenelayers_Vis_Final
category:	"_SceneLayers-Visibility"
buttonText:	"Vis Vis Final"
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #FINAL
	)
)

/** Vis Vis Print
 */
macroscript scenelayers_Vis_Print
category:	"_SceneLayers-Visibility"
buttonText:	"Vis Vis Print"
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #PRINT
	)
)

