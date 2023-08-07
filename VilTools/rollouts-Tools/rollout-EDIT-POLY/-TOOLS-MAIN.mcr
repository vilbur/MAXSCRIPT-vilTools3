/** Remove
 */
macroscript epoly_tools_Remove
category:	"_Epoly-Tools-Main"
buttonText:	"Remove"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 1, 2 )

	on execute do (
		macros.run "Ribbon - Modeling" EdgeRemove
	)
)

/** Split
 */
macroscript epoly_tools_Split
category:	"_Epoly-Tools-Main"
buttonText:	"Split"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do (
		macros.run "Ribbon - Modeling" EdgeSplit
	)
)

/** Vertex Break
 */
macroscript epoly_tools_Vertex_Break
category:	"_Epoly-Tools-Main"
buttonText:	"Vertex Break"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 1 )

	on execute do (
		macros.run "Ribbon - Modeling" VertexBreak
	)
)

/** Cut
 */
macroscript epoly_tools_Cut
category:	"_Epoly-Tools-Main"
buttonText:	"Cut"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()

	on execute do (
		macros.run "Ribbon - Modeling" CutsCut
	)
)

/** Quick Slice
 */
macroscript epoly_tools_Quick_Slice
category:	"_Epoly-Tools-Main"
buttonText:	"Quick Slice"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()

	on execute do (
		macros.run "Ribbon - Modeling" CutsQuickSlice
	)
)

/** Collapse
 */
macroscript epoly_tools_Collapse
category:	"_Epoly-Tools-Main"
buttonText:	"Collapse"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 1, 2, 3, 4 )

	on execute do (
		macros.run "Ribbon - Modeling" GeometryCollapse
	)
)

/** Cap
 */
macroscript epoly_tools_Cap
category:	"_Epoly-Tools-Main"
buttonText:	"Cap"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 3 )

	on execute do (
		macros.run "Ribbon - Modeling" Cap
	)
)

/** Cap Poly
 */
macroscript epoly_tools_Cap_Poly
category:	"_Epoly-Tools-Main"
buttonText:	"Cap Poly"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 1 )

	on execute do (
		macros.run "PolyTools" "CreatePolygon"
	)
)

/** Create Polygon
 */
macroscript epoly_tools_Create_Polygon
category:	"_Epoly-Tools-Main"
buttonText:	"Create Polygon"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 1 )

	on execute do (
		macros.run "Ribbon - Modeling" CreatePolygon
	)
)

/** Target Weld
 */
macroscript epoly_tools_Target_Weld
category:	"_Epoly-Tools-Main"
buttonText:	"Target Weld"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 1 )

	on execute do (
		macros.run "Editable Polygon Object" "EPoly_TargetWeld"
	)
)

/** Edit Triangulation
 */
macroscript epoly_tools_Edit_Triangulation
category:	"_Epoly-Tools-Main"
buttonText:	"Edit Triangulation"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do (
		macros.run "Ribbon - Modeling" EditTriangulation
	)
)

/** Turn Edge
 */
macroscript epoly_tools_Turn_Edge
category:	"_Epoly-Tools-Main"
buttonText:	"Turn Edge"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do (
		macros.run "Ribbon - Modeling" TurnEdge
	)
)

