/** Spin Edge
 */
macroscript epoly_tools_Spin_Edge
category:	"_Epoly-PolyTools"
icon:	"MENU:true"
buttonText:	"Spin Edge"
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
category:	"_Epoly-PolyTools"
icon:	"MENU:true"
buttonText:	"Build Loop End"
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
category:	"_Epoly-PolyTools"
icon:	"MENU:true"
buttonText:	"Build Loop Corner"
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
category:	"_Epoly-PolyTools"
icon:	"MENU:true"
buttonText:	"Build Loop End"
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
category:	"_Epoly-PolyTools"
icon:	"MENU:true"
buttonText:	"Geo Poly"
(
	on isVisible	do return isEpoly()	and	isSubObject( 4 )

	on execute do
	(
		macros.run "PolyTools" "GeoPoly"
	)
)

