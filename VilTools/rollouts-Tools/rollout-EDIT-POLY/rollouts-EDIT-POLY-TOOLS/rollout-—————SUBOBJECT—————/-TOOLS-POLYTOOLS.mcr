/** Spin Edge
 */
macroscript epoly_tools_Spin_Edge
icon:	"MENU:true"
buttonText:	"Spin Edge"
category:	"_Epoly-PolyTools"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do
	(
		macros.run "PolyTools" "SpinEdge"
	)
)

/** Build Loop End
 */
macroscript epoly_tools_Build_Loop_End
icon:	"MENU:true"
buttonText:	"Build Loop End"
category:	"_Epoly-PolyTools"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do
	(
		macros.run "PolyTools" "BuildLoopEnd"
	)
)

/** Build Loop Corner
 */
macroscript epoly_tools_Build_Loop_Corner
icon:	"MENU:true"
buttonText:	"Build Loop Corner"
category:	"_Epoly-PolyTools"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do
	(
		macros.run "PolyTools" "BuildLoopCorner"
	)
)

/** Build Loop End
 */
macroscript epoly_tools_Build_Loop_End
icon:	"MENU:true"
buttonText:	"Build Loop End"
category:	"_Epoly-PolyTools"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do
	(
		macros.run "PolyTools" "BuildLoopEnd"
	)
)

/** Geo Poly
 */
macroscript epoly_tools_Geo_Poly
icon:	"MENU:true"
buttonText:	"Geo Poly"
category:	"_Epoly-PolyTools"
(
	on isVisible	do return isEpoly()	and	isSubObject( 4 )

	on execute do
	(
		macros.run "PolyTools" "GeoPoly"
	)
)

