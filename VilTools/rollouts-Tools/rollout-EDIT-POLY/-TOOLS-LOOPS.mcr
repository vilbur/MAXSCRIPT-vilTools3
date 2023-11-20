/** Ｌ Ｏ Ｏ Ｐ   Ｔ Ｏ Ｏ Ｌ Ｓ ▼
 */
macroscript epoly_tools_Loop_Tools
category:	"_Epoly-Loop-Tools"
buttonText:	"Ｌ Ｏ Ｏ Ｐ   Ｔ Ｏ Ｏ Ｌ Ｓ ▼"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		execute EpolyLoopTool #LoopTools
	)
)

/** Center
 */
macroscript epoly_tools_Center_Loop
category:	"_Epoly-Loop-Tools"
buttonText:	"Center"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		execute EpolyLoopTool "CenterLoop"
	)
)

/** Space
 */
macroscript epoly_tools_Space_Loop
category:	"_Epoly-Loop-Tools"
buttonText:	"Space"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		execute EpolyLoopTool "SpaceLoop"
	)
)

/** Straigh
 */
macroscript epoly_tools_Straigh_Loop
category:	"_Epoly-Loop-Tools"
buttonText:	"Straigh"
toolTip:	"Ctrl: Autoloop \nAlt: Space vertices on loop evenly"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		execute EpolyLoopTool "StraighLoop"
	)
)

/** Curve
 */
macroscript epoly_tools_Curve_Loop
category:	"_Epoly-Loop-Tools"
buttonText:	"Curve"
toolTip:	"Ctrl: Autoloop \nAlt: Space vertices on loop evenly"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		execute EpolyLoopTool "CurveLoop"
	)
)

/** Circle
 */
macroscript epoly_tools_Circle_Loop
category:	"_Epoly-Loop-Tools"
buttonText:	"Circle"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		execute EpolyLoopTool "CircleLoop"
	)
)

/** Relax
 */
macroscript epoly_tools_Relax_Loop
category:	"_Epoly-Loop-Tools"
buttonText:	"Relax"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true|#id:#Relax_loop"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		execute EpolyLoopTool "RelaxLoop"
	)
)

