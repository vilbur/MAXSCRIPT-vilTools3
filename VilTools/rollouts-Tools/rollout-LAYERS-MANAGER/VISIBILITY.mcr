/** Vis Source
 */
macroscript scenelayers_Vis_Source
category:	"_SceneLayers-Visibility"
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
buttonText:	"Vis Source"
(

	on execute do
	(
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #SOURCE
	)
)

/** Vis Edit
 */
macroscript scenelayers_Vis_Edit
category:	"_SceneLayers-Visibility"
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
buttonText:	"Vis Edit"
(

	on execute do
	(
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #EDIT
	)
)

/** Vis Final
 */
macroscript scenelayers_Vis_Final
category:	"_SceneLayers-Visibility"
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
buttonText:	"Vis Final"
(

	on execute do
	(
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #FINAL
	)
)

/** Vis Print
 */
macroscript scenelayers_Vis_Print
category:	"_SceneLayers-Visibility"
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
buttonText:	"Vis Print"
(

	on execute do
	(
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #PRINT
	)
)

