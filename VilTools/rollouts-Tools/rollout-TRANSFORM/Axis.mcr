filein( getFilenamePath(getSourceFileName()) + "/Lib/Gizmo.ms" )

/**  
  *	
  */
macroscript	_Transform_axis_XY
category:	"_Transform"
buttontext:	"Circle Single"
toolTip:	"Circle active axis x|y"
--icon:	"#(path, index)"
(
	(Gizmo_v()).circle #( #x, #y )
)

/**  
  *	
  */
macroscript	_Transform_axis_XYZ
category:	"_Transform"
buttontext:	"Circle Single"
toolTip:	"Circle active axis x|y|z"
--icon:	"#(path, index)"
(
	(Gizmo_v()).circle #( #x, #y, #z )
)

/**  
  *	
  */
macroscript	_Transform_axis_XyZx
category:	"_Transform"
buttontext:	"Circle Double"
toolTip:	"Circle active axis xy|zx"
--icon:	"#(path, index)"
(
	(Gizmo_v()).circle #( #xy, #zx )
)

/**  
  *	
  */
macroscript	_Transform_axis_XyZxYz
category:	"_Transform"
buttontext:	"Circle Double"
toolTip:	"Circle active axis xy|zx|yz"
--icon:	"#(path, index)"
(
	(Gizmo_v()).circle #( #xy, #zx, #yz )
)
