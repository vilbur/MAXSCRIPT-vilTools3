/** Insert Loop
 */
macroscript epoly_tools_Insert_Loop
category:	"_Epoly-PolyTools"
buttonText:	"Insert Loop"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 1, 2 )

	on execute do (
		macros.run "PolyTools" "InsertLoop"
	)
)

/** Paint Connect
 */
macroscript epoly_tools_Paint_Connect
category:	"_Epoly-PolyTools"
buttonText:	"Paint Connect"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()

	on execute do (
		macros.run "PolyTools" "PaintConnect"
	)
)

/** Spin Edge
 */
macroscript epoly_tools_Spin_Edge
category:	"_Epoly-PolyTools"
buttonText:	"Spin Edge"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do (
		macros.run "PolyTools" "SpinEdge"
	)
)

/** Geo Poly
 */
macroscript epoly_tools_Geo_Poly
category:	"_Epoly-PolyTools"
buttonText:	"Geo Poly"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 4 )

	on execute do (
		macros.run "PolyTools" "GeoPoly"
	)
)

/** Set Flow
 */
macroscript epoly_tools_Set_Flow
category:	"_Epoly-PolyTools"
buttonText:	"Set Flow"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do (
		macros.run "PolyTools" "SetFlow"
	)
)

