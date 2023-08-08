/** Swift Loop
 */
macroscript epoly_tools_Swift_Loop
category:	"_Epoly-Connect"
buttonText:	"Swift Loop"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

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

/** Flow Connect
 */
macroscript epoly_tools_Flow_Connect
category:	"_Epoly-Connect"
buttonText:	"Flow Connect"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do (
		macros.run "Ribbon - Modeling" "ConnectEdges";PolyToolsModeling.SetFlow false
	)
)

/** Connect Edges
 */
macroscript epoly_tools_Connect_Edges
category:	"_Epoly-Connect"
buttonText:	"Connect Edges"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do (
		macros.run "Ribbon - Modeling" (if keyboard.controlPressed then "ConnectEdgesOptions" else "ConnectEdges")
	)
)

/** Connect Vertex
 */
macroscript epoly_tools_Connect_Vertex
category:	"_Epoly-Connect"
buttonText:	"Connect Vertex"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 1 )

	on execute do (
		macros.run "Editable Polygon Object" "EPoly_Connect"
	)
)

/** Insert Loop
 */
macroscript epoly_tools_Insert_Loop
category:	"_Epoly-Connect"
buttonText:	"Insert Loop"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 1, 2 )

	on execute do (
		macros.run "PolyTools" "InsertLoop"
	)
)

/** Distance Connect
 */
macroscript epoly_tools_Distance_Connect
category:	"_Epoly-Connect"
buttonText:	"Distance Connect"
icon:	"MENU:true"
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

