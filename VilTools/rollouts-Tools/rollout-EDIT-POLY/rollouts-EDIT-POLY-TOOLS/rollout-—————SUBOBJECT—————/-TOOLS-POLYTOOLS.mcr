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

/** Build Loop End
 */
macroscript epoly_tools_Build_Loop_End
category:	"_Epoly-PolyTools"
buttonText:	"Build Loop End"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do (
		macros.run "PolyTools" "BuildLoopEnd"
	)
)

/** Build Loop Corner
 */
macroscript epoly_tools_Build_Loop_Corner
category:	"_Epoly-PolyTools"
buttonText:	"Build Loop Corner"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do (
		macros.run "PolyTools" "BuildLoopCorner"
	)
)

/** Build Loop End
 */
macroscript epoly_tools_Build_Loop_End
category:	"_Epoly-PolyTools"
buttonText:	"Build Loop End"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do (
		macros.run "PolyTools" "BuildLoopEnd"
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

