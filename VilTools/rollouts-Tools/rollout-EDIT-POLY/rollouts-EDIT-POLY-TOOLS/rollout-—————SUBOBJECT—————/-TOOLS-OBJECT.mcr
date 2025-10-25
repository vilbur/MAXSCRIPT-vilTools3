/** Dot Loop
 */
macroscript epoly_tools_Dot_Loop
category:	"_Epoly-Object"
icon:	"MENU:true"
buttonText:	"Dot Loop"
(
	on isVisible	do isEpoly()	and	isSubObject( 2 )

	on execute do
	(
		macros.run "PolyTools" "DotLoop"
	)
)

/** Dot Ring
 */
macroscript epoly_tools_Dot_Ring
category:	"_Epoly-Object"
icon:	"MENU:true"
buttonText:	"Dot Ring"
(
	on isVisible	do isEpoly()	and	isSubObject( 2 )

	on execute do
	(
		macros.run "PolyTools" "DotRing"
	)
)

/** Attach
 */
macroscript epoly_tools_Attach
category:	"_Epoly-Object"
icon:	"MENU:true"
buttonText:	"Attach"
(
	on isVisible	do isEpoly()

	on execute do
	(
		macros.run "Ribbon - Modeling" "AttachMode"
	)
)

/** Remove Isolated Verts
 */
macroscript epoly_tools_Remove_Isolated_Verts
category:	"_Epoly-Object"
icon:	"MENU:true"
buttonText:	"Remove Isolated Verts"
(
	on isVisible	do isEpoly()

	on execute do
	(
		macros.run "Editable Polygon Object" "EPoly_RemoveIsolatedVerts"
	)
)

/** Random Select
 */
macroscript epoly_tools_Random_Select
category:	"_Epoly-Object"
icon:	"MENU:true"
buttonText:	"Random Select"
(
	on isVisible	do isEpoly()

	on execute do
	(
		macros.run "PolyTools" "RandomDialog"
	)
)

