/** S W I F T loop
 */
macroscript epoly_tools_Swift_Loop
category:	"_Epoly-Connect"
icon:	"MENU:true"
buttonText:	"S W I F T loop"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 0, 1, 2, 3, 4, 5 )

	on execute do
	(
		macros.run "PolyTools" "SwiftLoop"
	)
)

/** C O N N E C T
 */
macroscript epoly_tools_Connect_Edges
category:	"_Epoly-Connect"
icon:	"MENU:true"
buttonText:	"C O N N E C T"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do
	(
		macros.run "Ribbon - Modeling" (if keyboard.controlPressed then "ConnectEdgesOptions" else "ConnectEdges")
	)
)

/** D I S T A N C E Connect
 */
macroscript epoly_tools_Distance_Connect
category:	"_Epoly-Connect"
icon:	"MENU:true"
buttonText:	"D I S T A N C E Connect"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do
	(
		macros.run "PolyTools" "DistanceConnect"
	)
)

/** C O N N E C T VERTEX
 */
macroscript epoly_tools_Connect_Vertex
category:	"_Epoly-Connect"
icon:	"MENU:true"
buttonText:	"C O N N E C T VERTEX"
(
	on isVisible	do return isEpoly()	and	isSubObject ( 1 )

	on execute do
	(
		macros.run "Editable Polygon Object" "EPoly_Connect"
	)
)

/** F L O W Connect
 */
macroscript epoly_tools_Flow_Connect
category:	"_Epoly-Connect"
icon:	"MENU:true"
buttonText:	"F L O W Connect"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do
	(
		macros.run "Ribbon - Modeling" "ConnectEdges";PolyToolsModeling.SetFlow false
	)
)

/** Set Flow
 */
macroscript epoly_tools_Set_Flow
category:	"_Epoly-Connect"
icon:	"MENU:true"
buttonText:	"Set Flow"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 1, 2 )

	on execute do
	(
		macros.run "PolyTools" "SetFlow"
	)
)

/** PAINT Connect
 */
macroscript epoly_tools_Paint_Connect
category:	"_Epoly-Connect"
icon:	"MENU:true"
buttonText:	"PAINT Connect"
(
	on isVisible	do return isEpoly()

	on execute do
	(
		macros.run "PolyTools" "PaintConnect"
	)
)

/** I N S E R T Edge
 */
macroscript epoly_tools_Insert_Loop
category:	"_Epoly-Connect"
icon:	"MENU:true"
buttonText:	"I N S E R T Edge"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 1, 2 )

	on execute do
	(
		macros.run "PolyTools" "InsertLoop"
	)
)

