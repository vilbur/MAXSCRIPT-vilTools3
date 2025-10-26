/** LOOP TOOLS
 */
macroscript epoly_tools_Loop_Tools
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
buttonText:	"LOOP TOOLS"
category:	"_Epoly-Loop-Tools"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do
	(
		execute EpolyLoopTool #LoopTools
	)
)

/** Center
 */
macroscript epoly_tools_Center_Loop
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
buttonText:	"Center"
category:	"_Epoly-Loop-Tools"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do
	(
		execute EpolyLoopTool "CenterLoop"
	)
)

/** Space
 */
macroscript epoly_tools_Space_Loop
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
buttonText:	"Space"
category:	"_Epoly-Loop-Tools"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do
	(
		execute EpolyLoopTool "SpaceLoop"
	)
)

/** Straigh
 */
macroscript epoly_tools_Straigh_Loop
toolTip:	"Ctrl: Autoloop \nAlt: Space vertices on loop evenly"
icon:	"MENU:true"
buttonText:	"Straigh"
category:	"_Epoly-Loop-Tools"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do
	(
		execute EpolyLoopTool "StraighLoop"
	)
)

/** Curve
 */
macroscript epoly_tools_Curve_Loop
toolTip:	"Ctrl: Autoloop \nAlt: Space vertices on loop evenly"
icon:	"MENU:true"
buttonText:	"Curve"
category:	"_Epoly-Loop-Tools"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do
	(
		execute EpolyLoopTool "CurveLoop"
	)
)

/** Circle
 */
macroscript epoly_tools_Circle_Loop
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
buttonText:	"Circle"
category:	"_Epoly-Loop-Tools"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do
	(
		execute EpolyLoopTool "CircleLoop"
	)
)

/** Relax
 */
macroscript epoly_tools_Relax_Loop
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true|#id:#Relax_loop"
buttonText:	"Relax"
category:	"_Epoly-Loop-Tools"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do
	(
		execute EpolyLoopTool "RelaxLoop"
	)
)

