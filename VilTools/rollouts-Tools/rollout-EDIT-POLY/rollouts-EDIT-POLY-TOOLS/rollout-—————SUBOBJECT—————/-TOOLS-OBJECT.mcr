/** Dot Loop
 */
macroscript epoly_tools_Dot_Loop
icon:	"MENU:true"
buttonText:	"Dot Loop"
category:	"_Epoly-Object"
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
icon:	"MENU:true"
buttonText:	"Dot Ring"
category:	"_Epoly-Object"
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
icon:	"MENU:true"
buttonText:	"Attach"
category:	"_Epoly-Object"
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
icon:	"MENU:true"
buttonText:	"Remove Isolated Verts"
category:	"_Epoly-Object"
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
icon:	"MENU:true"
buttonText:	"Random Select"
category:	"_Epoly-Object"
(
	on isVisible	do isEpoly()

	on execute do
	(
		macros.run "PolyTools" "RandomDialog"
	)
)

