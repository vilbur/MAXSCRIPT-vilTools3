filein( getFilenamePath(getSourceFileName()) + "/Lib/ToolMode.ms" )

/*---------------------------------------
	SELECT
---------------------------------------*/

/**
  *
  */
macroscript	tools_select_tool_or_axis_double
category:	"_Tools"
buttontext:	"Select"
toolTip:	"Select tool"
--icon:	"#(path, index)"
(
	(ToolMode_v tool_mode:#Select).setToolOrChangeSelectionType #( #Rectangle, #Circle, #Fence, #Lasso, #Paint )
)

/**
  *
  */
macroscript	tools_select_tool_or_axis
category:	"_Tools"
buttontext:	"Select"
toolTip:	"Select tool: RECTANGLE | LASSO"
icon:	"menu:_Tools"
(
	(ToolMode_v tool_mode:#Select).setToolOrChangeSelectionType #( #Rectangle, #Lasso )
)



/*---------------------------------------
	MOVE
---------------------------------------*/
/**  Move tool
 *
 *	 Axises in perspective  #X|#Y|#Z
 *	 Axises in orthographic #X|#Y|#XY
 */
macroscript	tools_move_tool_or_axis
category:	"_Tools"
buttontext:	"Move"
toolTip:	"Move tool: X | Y | Z"
icon:	"menu:_Tools"
(
	on isVisible  return selection.count>0

	on execute do( (ToolMode_v tool_mode:#Move perspective:#( #X, #Y, #Z ) ortho:#( #X, #Y ) ).setToolOrChangeAxis())
)

/**  Move tool
 *
 *	 Axises in perspective  #XY|#ZX|#YZ
 *	 Axises in orthographic #X|#Y|#XY
 */
macroscript	tools_move_tool_or_axis_double
category:	"_Tools"
buttontext:	"Move"
toolTip:	"Move tool: XY | ZX | YZ"
--icon:	"menu:_Tools"
(
	(ToolMode_v tool_mode:#Move perspective:#( #XY, #ZX, #YZ  ) ortho:#( #XY )).setToolOrChangeAxis()
)




/*---------------------------------------
	ROTATE
-----------------------------------------*/
/**  Rotate tool
 *
 *	 Axises in perspective  #X|#Y|#Z
 *	 Axises in orthographic #Z
 */
macroscript	tools_rotate_tool_or_axis
category:	"_Tools"
buttontext:	"Rotate"
toolTip:	"Rotate tool: X | Y | Z"
icon:	"menu:_Tools"
(
    on isVisible return selection.count>0

	on execute do (ToolMode_v tool_mode:#Rotate axises:#( #X, #Y, #Z )).setToolOrChangeAxis()

)




/*---------------------------------------
	SCALE
-----------------------------------------*/

/**  Uniform scale tool
 *
 *	 Axises in perspective  #X|#Y|#Z
 *	 Axises in orthographic #X|#Y|#XY
 */
macroscript	tools_non_uniform_scale_tool_or_axis
category:	"_Tools"
buttontext:	"Scale"
toolTip:	"Scale tool X | Y | Z | XY"
icon:	"menu:_Tools"
(
    on isVisible return selection.count>0

	on execute do (ToolMode_v tool_mode:#Nuscale perspective:#( #X, #Y, #Z ) ortho:#( #X, #Y )  ).setToolOrChangeAxis()
)

/** UNIFORM scale or NON UNIFORM SCALE circle double axis
 *
 *
 *	 Axises in orthographic #XY|#XYZ
 *	 Axises in perspective  #XY|#ZX|#YZ|#XYZ
 */
macroscript	tools_uniform_scale_tool_or_axis
category:	"_Tools"
buttontext:	"Scale"
toolTip:	"Scale tool:  XY | ZX | YZ | XYZ"
--icon:	"#(path, index)"
(

	/* PERSPECTIVE OR ISOMETRIC VIEW */
	if matchPattern ( viewport.getType() as string ) pattern:@"*user" then
	(
		if( toolMode.commandmode == #Nuscale and toolMode.axisConstraints == #YZ ) then
		(
			toolMode.axisConstraints = #XY

			toolMode.commandmode = #Uscale
		)
		else
			(ToolMode_v tool_mode:#Nuscale axises:#( #XY, #ZX, #YZ )  ).setToolOrChangeAxis() -- NON UNIFORM SCALE

	)
	else 	/* ORTHO VIEW */
	(

		if  toolMode.commandmode == #Uscale then
		(
			toolMode.axisConstraints = #XY

			toolMode.commandmode = #Nuscale
		)
		else
			toolMode.commandmode = #Uscale
	)

	format "% \n" ( if toolMode.commandmode == #Uscale then "UNIFORM SCALE" else "NON UNIFORM SCALE")

)
