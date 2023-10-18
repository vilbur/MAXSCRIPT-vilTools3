/** S W I F T loop
 */
macroscript epoly_tools_Swift_Loop
category:	"_Epoly-Connect"
buttonText:	"S W I F T loop"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 0, 1, 2, 3, 4, 5 )

	on execute do (
		macros.run "PolyTools" "SwiftLoop"
	)
)

/** Set Flow
 */
macroscript epoly_tools_Set_Flow
category:	"_Epoly-Connect"
buttonText:	"Set Flow"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 1, 2 )

	on execute do (
		macros.run "PolyTools" "SetFlow"
	)
)

/** F L O W C O N N E C T
 */
macroscript epoly_tools_Flow_Connect
category:	"_Epoly-Connect"
buttonText:	"FLow Connect"
icon:	"MENU:F L O W C O N N E C T"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do (
		macros.run "Ribbon - Modeling" "ConnectEdges";PolyToolsModeling.SetFlow false
	)
)

/** C O N N E C T
 */
macroscript epoly_tools_Connect_Edges
category:	"_Epoly-Connect"
buttonText:	"Connect"
icon:	"MENU:C O N N E C T"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do (
		macros.run "Ribbon - Modeling" (if keyboard.controlPressed then "ConnectEdgesOptions" else "ConnectEdges")
	)
)

/** C O N N E C T VERTEX
 */
macroscript epoly_tools_Connect_Vertex
category:	"_Epoly-Connect"
buttonText:	"Connect Vertex"
icon:	"MENU:C O N N E C T VERTEX"
(
	on isVisible	do return isEpoly()	and	isSubObject ( 1 )

	on execute do (
		macros.run "Editable Polygon Object" "EPoly_Connect"
	)
)

/** I N S E R T Edge
 */
macroscript epoly_tools_Insert_Loop
category:	"_Epoly-Connect"
buttonText:	"Insert Loop"
icon:	"MENU:I N S E R T Loop"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 1, 2 )

	on execute do (
		macros.run "PolyTools" "InsertLoop"
	)
)

/** D I S T A N C E
 */
macroscript epoly_tools_Distance_Connect
category:	"_Epoly-Connect"
buttonText:	"Distance Connect"
icon:	"MENU:D I S T A N C E Connect"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do (
		macros.run "PolyTools" "DistanceConnect"
	)
)

/** Paint Connect
 */
macroscript epoly_tools_Paint_Connect
category:	"_Epoly-Connect"
buttonText:	"Paint Connect"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()

	on execute do (
		macros.run "PolyTools" "PaintConnect"
	)
)
