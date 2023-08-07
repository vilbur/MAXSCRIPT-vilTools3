/** Attach
 */
macroscript epoly_tools_Attach
category:	"_Epoly-Object"
buttonText:	"Attach"
icon:	"MENU:true"
(
	on isVisible	do isEpoly()

	on execute do (
		macros.run "Ribbon - Modeling" "AttachMode"
	)
)

/** Ignore Backfacing
 */
macroscript epoly_tools_Ignore_Backfacing
category:	"_Epoly-Object"
buttonText:	"Ignore Backfacing"
icon:	"MENU:true"
(
	on isVisible	do isEpoly()

	on execute do (
		macros.run "Ribbon - Modeling" "IgnoreBackfacing"
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

/** Dot Loop
 */
macroscript epoly_tools_Dot_Loop
category:	"_Epoly-Object"
buttonText:	"Dot Loop"
icon:	"MENU:true"
(
	on isVisible	do isEpoly()	and	isSubObject( 2 )

	on execute do (
		macros.run "Ribbon - Modeling" "DotLoop"
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
		macros.run "Ribbon - Modeling" "DotRing"
	)
)

