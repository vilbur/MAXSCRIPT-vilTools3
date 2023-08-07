/** Set Flow
 */
macroscript epoly_tools_Set_Flow
category:	"_Epoly-Loops"
buttonText:	"Set Flow"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject( 2 )	and	isSubObject #( 1 )

	on execute do (
		executeEpolyLoopTool "SetFlow"
	)
)

/** Center Loop
 */
macroscript epoly_tools_Center_Loop
category:	"_Epoly-Loops"
buttonText:	"Center Loop"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		executeEpolyLoopTool "CenterLoop"
	)
)

/** Space Loop
 */
macroscript epoly_tools_Space_Loop
category:	"_Epoly-Loops"
buttonText:	"Space Loop"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		executeEpolyLoopTool "SpaceLoop"
	)
)

/** Straigh Loop
 */
macroscript epoly_tools_Straigh_Loop
category:	"_Epoly-Loops"
buttonText:	"Straigh Loop"
toolTip:	"Ctrl: Autoloop \nAlt: Space vertices on loop evenly"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		executeEpolyLoopTool "StraighLoop"
	)
)

/** Curve Loops
 */
macroscript epoly_tools_Curve_Loops
category:	"_Epoly-Loops"
buttonText:	"Curve Loops"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		executeEpolyLoopTool "CurveLoops"
	)
)

/** Circle Loop
 */
macroscript epoly_tools_Circle_Loop
category:	"_Epoly-Loops"
buttonText:	"Circle Loop"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		executeEpolyLoopTool "CircleLoop"
	)
)

/** Relax Loop
 */
macroscript epoly_tools_Relax_Loop
category:	"_Epoly-Loops"
buttonText:	"Relax Loop"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do (
		executeEpolyLoopTool "RelaxLoop"
	)
)

