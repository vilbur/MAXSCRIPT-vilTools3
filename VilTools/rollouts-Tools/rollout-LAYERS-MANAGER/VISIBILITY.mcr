/** Vis Source
 */
macroscript scenelayers_Vis_Source
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
buttonText:	"Vis Source"
category:	"_SceneLayers-Visibility"
(

	on execute do
	(
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #SOURCE
	)
)

/** Vis Edit
 */
macroscript scenelayers_Vis_Edit
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
buttonText:	"Vis Edit"
category:	"_SceneLayers-Visibility"
(

	on execute do
	(
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #EDIT
	)
)

/** Vis Final
 */
macroscript scenelayers_Vis_Final
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
buttonText:	"Vis Final"
category:	"_SceneLayers-Visibility"
(

	on execute do
	(
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #FINAL
	)
)

/** Vis Print
 */
macroscript scenelayers_Vis_Print
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
buttonText:	"Vis Print"
category:	"_SceneLayers-Visibility"
(

	on execute do
	(
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #PRINT
	)
)

