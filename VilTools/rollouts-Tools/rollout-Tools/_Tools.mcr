filein( getFilenamePath(getSourceFileName()) + "/Lib/ToolMode.ms" )

/*---------------------------------------
	MOVE
-----------------------------------------*/
macroscript	tools_move_tool_or_axis
category:	"_Tools"
buttontext:	"Move\Axis"
toolTip:	"Move tool or change axis x|y|z"
--icon:	"#(path, index)"
(
	(ToolMode_v()).setToolOrChangeAxis #Move #( #x, #y, #z )
)

macroscript	tools_move_tool_or_axis_double
category:	"_Tools"
buttontext:	"Move\Axis"
toolTip:	"Move tool or change axis xy|zx|yz"
--icon:	"#(path, index)"
(
	(ToolMode_v()).setToolOrChangeAxis #Move #( #xy, #zx, #yz )
)

/*---------------------------------------
	ROTATE
-----------------------------------------*/
macroscript	tools_rotate_tool_or_axis
category:	"_Tools"
buttontext:	"Rotate\Axis"
toolTip:	"Rotate tool or change axis x|y|z"
--icon:	"#(path, index)"
(
	(ToolMode_v()).setToolOrChangeAxis #Rotate #( #x, #y, #z )
)

macroscript	tools_rotate_tool_or_axis_double
category:	"_Tools"
buttontext:	"Rotate\Axis"
toolTip:	"Rotate tool or change axis xy|zx|yz"
--icon:	"#(path, index)"
(
	(ToolMode_v()).setToolOrChangeAxis #Rotate #( #xy, #zx, #yz )
)

/*---------------------------------------
	SCALE
-----------------------------------------*/
macroscript	tools_scale_tool_or_axis
category:	"_Tools"
buttontext:	"Scale\Axis"
toolTip:	"Scale tool or change axis x|y|z"
--icon:	"#(path, index)"
(
	(ToolMode_v()).setToolOrChangeAxis #Nuscale #( #x, #y, #z )
)

macroscript	tools_scale_tool_or_axis_double
category:	"_Tools"
buttontext:	"Scale\Axis"
toolTip:	"Scale tool or change axis xy|zx|yz"
--icon:	"#(path, index)"
(
	(ToolMode_v()).setToolOrChangeAxis #Nuscale #( #xy, #zx, #yz )
)

/*---------------------------------------
	SELECT
-----------------------------------------*/
macroscript	tools_select_tool_or_axis
category:	"_Tools"
buttontext:	"Select\Axis"
toolTip:	"Select tool or change selection to Rectangle"
--icon:	"#(path, index)"
(
	(ToolMode_v()).setToolOrChangeSelectionType #Select #( #Rectangle )
)

macroscript	tools_select_tool_or_axis_double
category:	"_Tools"
buttontext:	"Select\Axis"
toolTip:	"Select tool or change selection to Rectangle|Circle|Fence|Lasso|Paint"
--icon:	"#(path, index)"
(
	(ToolMode_v()).setToolOrChangeSelectionType #Select #( #Rectangle, #Circle, #Fence, #Lasso, #Paint )
)
