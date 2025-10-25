/** LOOP TOOLS
 */
macroscript epoly_tools_Loop_Tools
category:	"_Epoly-Loop-Tools"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
buttonText:	"LOOP TOOLS"
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
category:	"_Epoly-Loop-Tools"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
buttonText:	"Center"
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
category:	"_Epoly-Loop-Tools"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
buttonText:	"Space"
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
category:	"_Epoly-Loop-Tools"
toolTip:	"Ctrl: Autoloop \nAlt: Space vertices on loop evenly"
icon:	"MENU:true"
buttonText:	"Straigh"
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
category:	"_Epoly-Loop-Tools"
toolTip:	"Ctrl: Autoloop \nAlt: Space vertices on loop evenly"
icon:	"MENU:true"
buttonText:	"Curve"
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
category:	"_Epoly-Loop-Tools"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true"
buttonText:	"Circle"
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
category:	"_Epoly-Loop-Tools"
toolTip:	"Ctrl: Autoloop"
icon:	"MENU:true|#id:#Relax_loop"
buttonText:	"Relax"
(
	on isVisible	do isEpoly() and isSubObject( 2 )

	on execute do
	(
		execute EpolyLoopTool "RelaxLoop"
	)
)

