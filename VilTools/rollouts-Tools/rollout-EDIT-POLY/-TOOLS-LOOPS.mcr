/** Ｌ Ｏ Ｏ Ｐ   Ｔ Ｏ Ｏ Ｌ Ｓ ▼
 */
macroscript epoly_tools_Loop_Tools
category:	"_Epoly-Loops"
buttonText:	"Ｌ Ｏ Ｏ Ｐ   Ｔ Ｏ Ｏ Ｌ Ｓ ▼"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		executeEpolyLoopTool #LoopTools
	)
)

/** Center
 */
macroscript epoly_tools_Center_Loop
category:	"_Epoly-Loops"
buttonText:	"Center"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		executeEpolyLoopTool "CenterLoop"
	)
)

/** Space
 */
macroscript epoly_tools_Space_Loop
category:	"_Epoly-Loops"
buttonText:	"Space"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		executeEpolyLoopTool "SpaceLoop"
	)
)

/** Straigh
 */
macroscript epoly_tools_Straigh_Loop
category:	"_Epoly-Loops"
buttonText:	"Straigh"
toolTip:	"Ctrl: Autoloop \nAlt: Space vertices on loop evenly"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		executeEpolyLoopTool "StraighLoop"
	)
)

/** Curve
 */
macroscript epoly_tools_Curve_Loop
category:	"_Epoly-Loops"
buttonText:	"Curve"
toolTip:	"Ctrl: Autoloop \nAlt: Space vertices on loop evenly"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		executeEpolyLoopTool "CurveLoop"
	)
)

/** Circle
 */
macroscript epoly_tools_Circle_Loop
category:	"_Epoly-Loops"
buttonText:	"Circle"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		executeEpolyLoopTool "CircleLoop"
	)
)

/** Relax
 */
macroscript epoly_tools_Relax_Loop
category:	"_Epoly-Loops"
buttonText:	"Relax"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true|#id:#Relax_loop"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		executeEpolyLoopTool "RelaxLoop"
	)
)

