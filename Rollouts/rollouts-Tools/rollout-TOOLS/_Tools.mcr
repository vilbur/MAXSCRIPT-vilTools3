filein( getFilenamePath(getSourceFileName()) + "/Lib/ToolMode.ms" )

/*---------------------------------------
	SELECT
---------------------------------------*/
macroscript	tools_select_tool_or_axis
category:	"_Tools"
buttontext:	"Select"
toolTip:	"Select tool or swith selection region Rectangle|Circle"
icon:	"menu:_Tools"
(
	(ToolMode_v tool_mode:#Select).setToolOrChangeSelectionType #( #Rectangle, #Circle )
)

macroscript	tools_select_tool_or_axis_double
category:	"_Tools"
buttontext:	"Select"
toolTip:	"Select tool or change selection to Rectangle|Circle|Fence|Lasso|Paint"
icon:	"#(path, index)"
(
	(ToolMode_v tool_mode:#Select).setToolOrChangeSelectionType #Select #( #Rectangle, #Circle, #Fence, #Lasso, #Paint )
)

/*---------------------------------------
	MOVE
---------------------------------------*/
/**  Move tool
 *
 *	 Axises in perspective  #x|#y|#z
 *	 Axises in orthographic #x|#y|#xy
 */
macroscript	tools_move_tool_or_axis
category:	"_Tools"
buttontext:	"Move"
toolTip:	"Move tool or change axis #x|#y|#z"
icon:	"menu:_Tools"
(
	on isVisible  return selection.count>0

	on execute do( (ToolMode_v tool_mode:#Move axises:#( #x, #y, #z )).setToolOrChangeAxis())
)

/**  Move tool
 *
 *	 Axises in perspective  #xy|#zx|#yz
 *	 Axises in orthographic #x|#y|#xy
 */
macroscript	tools_move_tool_or_axis_double
category:	"_Tools"
buttontext:	"Move"
toolTip:	"Move tool or change axis #xy,|#zx,|#yz"
--icon:	"menu:_Tools"
(
	(ToolMode_v tool_mode:#Move axises:#( #xy, #zx, #yz  )).setToolOrChangeAxis()
)

/*---------------------------------------
	ROTATE
-----------------------------------------*/
/**  Rotate tool
 *
 *	 Axises in perspective  #x|#y|#z
 *	 Axises in orthographic #z
 */
macroscript	tools_rotate_tool_or_axis
category:	"_Tools"
buttontext:	"Rotate"
toolTip:	"Rotate tool or change axis in perspective"
icon:	"menu:_Tools"
(
    on isVisible return selection.count>0
	
	on execute do (ToolMode_v tool_mode:#Rotate axises:#( #x, #y, #z )).setToolOrChangeAxis()
)

/**  Rotate tool
 *
 *	 Axises in perspective  #x|#y|#z
 *	 Axises in orthographic #x|#y|#z
 */
macroscript	tools_rotate_tool_or_all_axises
category:	"_Tools"
buttontext:	"Rotate"
toolTip:	"Rotate tool or change axis"
--icon:	"#(path, index)"
(
	(ToolMode_v tool_mode:#Rotate axises:#( #x, #y, #z )).setRotateToolOrChangeAxisInOrtho()
	
)

/*---------------------------------------
	SCALE
-----------------------------------------*/

/**  Uniform scale tool
 *	
 *	 Axises in perspective  #x|#y|#z
 *	 Axises in orthographic #x|#y|#xy
 */
macroscript	tools_non_uniform_scale_tool_or_axis
category:	"_Tools"
buttontext:	"Scale"
toolTip:	"Non uniform scale tool or change axis #x|#y|#z"
icon:	"menu:_Tools"
(
    on isVisible return selection.count>0

	on execute do (ToolMode_v tool_mode:#Nuscale axises:#( #x, #y, #z )).setToolOrChangeAxis()
)

/**  Select and switvh non uniform scale and uniform tool
 *	
 */
macroscript	tools_uniform_scale_tool_or_axis
category:	"_Tools"
buttontext:	"Scale"
toolTip:	"Scale tool or change axis"
--icon:	"#(path, index)"
(
	
	--format "TEST = % \n" (toolMode.commandmode != #Uscale or toolMode.axisConstraints == #YZ)

	if( toolMode.commandmode == #Nuscale and toolMode.axisConstraints == #YZ ) then
	(
		toolMode.axisConstraints = #XY 
		
		(ToolMode_v tool_mode:#Uscale axises:#( #xy, #zx, #yz  )).setToolOrChangeAxis()
	)
	else
		(ToolMode_v tool_mode:#Nuscale axises:#( #xy, #zx, #yz  )).setToolOrChangeAxis()	
)
