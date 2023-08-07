/** Extrude
 */
macroscript epoly_tools_Extrude
category:	"_Epoly-Tools-Options"
buttonText:	"Extrude"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 1, 2, 3, 4 )

	on execute do (
		macros.run "Ribbon - Modeling" "EPoly_Extrude"
	)

	on AltExecute type do (
		macros.run "Ribbon - Modeling" "EPoly_ExtrudeOptions"
	)
)

/** Chamfer
 */
macroscript epoly_tools_Chamfer
category:	"_Epoly-Tools-Options"
buttonText:	"Chamfer"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 1, 2, 3, 4 )

	on execute do (
		macros.run "Ribbon - Modeling" "EPoly_Chamfer"
	)

	on AltExecute type do (
		macros.run "Ribbon - Modeling" "EPoly_ChamferOptions"
	)
)

/** Bridge
 */
macroscript epoly_tools_Bridge
category:	"_Epoly-Tools-Options"
buttonText:	"Bridge"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 1, 2, 3 )

	on execute do (
		macros.run "Ribbon - Modeling" "EdgeBridge"
	)

	on AltExecute type do (
		macros.run "Ribbon - Modeling" "EdgeBridgeOptions"
	)
)

/** Relax
 */
macroscript epoly_tools_Relax
category:	"_Epoly-Tools-Options"
buttonText:	"Relax"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()

	on execute do (
		macros.run "Ribbon - Modeling" "RelaxSelection"
	)

	on AltExecute type do (
		macros.run "Ribbon - Modeling" "RelaxSelectionOptions"
	)
)

/** Connect Edges
 */
macroscript epoly_tools_Connect_Edges
category:	"_Epoly-Tools-Options"
buttonText:	"Connect Edges"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do (
		macros.run "Ribbon - Modeling" "ConnectEdges"
	)

	on AltExecute type do (
		macros.run "Ribbon - Modeling" "ConnectEdgesOptions"
	)
)

/** Connect Vertex
 */
macroscript epoly_tools_Connect_Vertex
category:	"_Epoly-Tools-Options"
buttonText:	"Connect Vertex"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do (
		macros.run "Editable Polygon Object" "EPoly_Connect"
	)
)

/** Distance Connect
 */
macroscript epoly_tools_Distance_Connect
category:	"_Epoly-Tools-Options"
buttonText:	"Distance Connect"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 1 )

	on execute do (
		macros.run "PolyTools" "DistanceConnect"
	)
)

/** Weld
 */
macroscript epoly_tools_Weld
category:	"_Epoly-Tools-Options"
buttonText:	"Weld"
icon:	"MENU:true|id:#epoly_weld"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 1, 2 )

	on execute do (
		macros.run "Ribbon - Modeling" "EPoly_Weld"
	)

	on AltExecute type do (
		macros.run "Ribbon - Modeling" "EPoly_WeldOptions"
	)
)

