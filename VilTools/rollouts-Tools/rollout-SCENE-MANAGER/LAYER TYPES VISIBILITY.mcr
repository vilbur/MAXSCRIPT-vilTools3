/** Show Hide Source
 */
macroscript scenelayers_Source
category:	"_SceneLayers-Visibility"
buttonText:	"Show Hide Source"
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #SOURCE
	)
)

/** Show Hide Edit
 */
macroscript scenelayers_Edit
category:	"_SceneLayers-Visibility"
buttonText:	"Show Hide Edit"
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #EDIT
	)
)

/** Show Hide Final
 */
macroscript scenelayers_Final
category:	"_SceneLayers-Visibility"
buttonText:	"Show Hide Final"
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #FINAL
	)
)

/** Show Hide Print
 */
macroscript scenelayers_Print
category:	"_SceneLayers-Visibility"
buttonText:	"Show Hide Print"
toolTip:	"CTRL:Isolate"
icon:	"MENU:true"
(

	on execute do (
		(SceneLayers_v()).setVisibility isolate:keyboard.controlPressed layer_type: #PRINT
	)
)

