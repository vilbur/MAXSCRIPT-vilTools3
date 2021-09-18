filein( getFilenamePath(getSourceFileName()) + "/Lib/ToolMode.ms" )

/*---------------------------------------
	SELECT
-----------------------------------------*/
macroscript	tools_select_tool_or_axis
category:	"_Tools"
buttontext:	"Select"
toolTip:	"Select tool or change selection to Rectangle"
--icon:	"#(path, index)"
(
	(ToolMode_v tool_mode:#Select).setToolOrChangeSelectionType #( #Rectangle, #Circle )
)

--macroscript	tools_select_tool_or_axis_double
--category:	"_Tools"
--buttontext:	"Select"
--toolTip:	"Select tool or change selection to Rectangle|Circle|Fence|Lasso|Paint"
----icon:	"#(path, index)"
--(
--	(ToolMode_v tool_mode:#Select).setToolOrChangeSelectionType #Select #( #Rectangle, #Circle, #Fence, #Lasso, #Paint )
--)

/*---------------------------------------
	MOVE
-----------------------------------------*/
macroscript	tools_move_tool_or_axis
category:	"_Tools"
buttontext:	"Move"
toolTip:	"Move tool or change axis #x|#y|#z"
--icon:	"#(path, index)"
(
	(ToolMode_v tool_mode:#Move axises:#( #x, #y, #z )).setToolOrChangeAxis()
)

macroscript	tools_move_tool_or_axis_double
category:	"_Tools"
buttontext:	"Move"
toolTip:	"Move tool or change axis #xy,|#zx,|#yz"
--icon:	"#(path, index)"
(
	(ToolMode_v tool_mode:#Move axises:#( #xy, #zx, #yz  )).setToolOrChangeAxis()
)

/*---------------------------------------
	ROTATE
-----------------------------------------*/
macroscript	tools_rotate_tool_or_axis
category:	"_Tools"
buttontext:	"Rotate"
toolTip:	"Rotate tool or change axis in perspective"
--icon:	"#(path, index)"
(
	--(ToolMode_v tool_mode:#Rotate).setToolOrChangeAxis()
	(ToolMode_v tool_mode:#Rotate axises:#( #x, #y, #z )).setToolOrChangeAxis()
)

macroscript	tools_rotate_tool_or_axis_double
category:	"_Tools"
buttontext:	"Rotate"
toolTip:	"Rotate tool or change axis"
--icon:	"#(path, index)"
(
	(ToolMode_v tool_mode:#Rotate axises:#( #x, #y, #z )).setRotateToolOrChangeAxisInOrtho()
	
)

/*---------------------------------------
	NON UNIFORM SCALE
-----------------------------------------*/
macroscript	tools_non_uniform_scale_tool_or_axis
category:	"_Tools"
buttontext:	"Scale"
toolTip:	"Non uniform scale tool or change axis"
--icon:	"#(path, index)"
(
	(ToolMode_v tool_mode:#Nuscale).setToolOrChangeAxis()
)

/*---------------------------------------
	SCALE
-----------------------------------------*/
macroscript	tools_uniform_scale_tool_or_axis
category:	"_Tools"
buttontext:	"Scale"
toolTip:	"Scale tool or change axis"
--icon:	"#(path, index)"
(
	(ToolMode_v tool_mode:#Uscale).setToolOrChangeAxis()
)

