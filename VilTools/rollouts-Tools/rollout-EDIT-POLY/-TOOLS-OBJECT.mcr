/** Repeat Last
 */
macroscript epoly_tools_Repeat_Last
category:	"_Epoly-Object"
buttonText:	"Repeat Last"
icon:	"MENU:true"
(
	on isVisible	do isEpoly()

	on execute do (
		macros.run "Editable Polygon Object" "EPoly_Repeat_Last"
	)
)

/** Attach
 */
macroscript epoly_tools_Attach
category:	"_Epoly-Object"
buttonText:	"Attach"
icon:	"MENU:true"
(
	on isVisible	do isEpoly()

	on execute do (
		macros.run "Ribbon - Modeling" AttachMode
	)
)

/** Dot Loop
 */
macroscript epoly_tools_Dot_Loop
category:	"_Epoly-Object"
buttonText:	"Dot Loop"
icon:	"MENU:true"
(
	on isVisible	do isEpoly()	and	isSubObject( 2 )

	on execute do (
		macros.run "PolyTools" "DotLoop"
	)
)

/** Dot Ring
 */
macroscript epoly_tools_Dot_Ring
category:	"_Epoly-Object"
buttonText:	"Dot Ring"
icon:	"MENU:true"
(
	on isVisible	do isEpoly()	and	isSubObject( 2 )

	on execute do (
		macros.run "PolyTools" "DotRing"
	)
)

/** Remove Isolated Verts
 */
macroscript epoly_tools_Remove_Isolated_Verts
category:	"_Epoly-Object"
buttonText:	"Remove Isolated Verts"
icon:	"MENU:true"
(
	on isVisible	do isEpoly()

	on execute do (
		macros.run "Editable Polygon Object" "EPoly_RemoveIsolatedVerts"
	)
)

/** Loop Tools
 */
macroscript epoly_tools_Loop_Tools
category:	"_Epoly-Object"
buttonText:	"Loop Tools"
icon:	"MENU:true"
(
	on isVisible	do isEpoly()

	on execute do (
		macros.run "PolyTools" "LoopTools"
	)
)

/** Random Select
 */
macroscript epoly_tools_Random_Select
category:	"_Epoly-Object"
buttonText:	"Random Select"
icon:	"MENU:true"
(
	on isVisible	do isEpoly()

	on execute do (
		macros.run "PolyTools" "RandomDialog"
	)
)

