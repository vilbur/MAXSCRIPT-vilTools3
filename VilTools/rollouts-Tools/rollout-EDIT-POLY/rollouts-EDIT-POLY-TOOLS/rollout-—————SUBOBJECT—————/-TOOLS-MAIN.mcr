/** Remove
 */
macroscript epoly_tools_Remove
category:	"_Epoly-Tools-Main"
icon:	"MENU:true"
buttonText:	"Remove"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 1, 2 )

	on execute do
	(
		macros.run "Ribbon - Modeling" "EdgeRemove"
	)
)

/** Split
 */
macroscript epoly_tools_Split
category:	"_Epoly-Tools-Main"
icon:	"MENU:true"
buttonText:	"Split"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do
	(
		macros.run "Ribbon - Modeling" "EdgeSplit"; print"SPLITX"
	)
)

/** Vertex Break
 */
macroscript epoly_tools_Vertex_Break
category:	"_Epoly-Tools-Main"
icon:	"MENU:true"
buttonText:	"Vertex Break"
(
	on isVisible	do return isEpoly()	and	isSubObject( 1 )

	on execute do
	(
		macros.run "Ribbon - Modeling" "VertexBreak"
	)
)

/** Cut
 */
macroscript epoly_tools_Cut
category:	"_Epoly-Tools-Main"
icon:	"MENU:true"
buttonText:	"Cut"
(
	on isVisible	do return isEpoly()

	on execute do
	(
		macros.run "Ribbon - Modeling" "CutsCut"
	)
)

/** Quick Slice
 */
macroscript epoly_tools_Quick_Slice
category:	"_Epoly-Tools-Main"
icon:	"MENU:true"
buttonText:	"Quick Slice"
(
	on isVisible	do return isEpoly()

	on execute do
	(
		macros.run "Ribbon - Modeling" "CutsQuickSlice"
	)
)

/** Collapse
 */
macroscript epoly_tools_Collapse
category:	"_Epoly-Tools-Main"
icon:	"MENU:true"
buttonText:	"Collapse"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 1, 2, 3, 4 )

	on execute do
	(
		macros.run "Ribbon - Modeling" "GeometryCollapse"
	)
)

/** Cap
 */
macroscript epoly_tools_Cap
category:	"_Epoly-Tools-Main"
icon:	"MENU:true"
buttonText:	"Cap"
(
	on isVisible	do return isEpoly()	and	isSubObject( 3 )

	on execute do
	(
		macros.run "Ribbon - Modeling" "Cap"
	)
)

/** Cap Poly
 */
macroscript epoly_tools_Cap_Poly
category:	"_Epoly-Tools-Main"
icon:	"MENU:true"
buttonText:	"Cap Poly"
(
	on isVisible	do return isEpoly()	and	isSubObject( 1 )

	on execute do
	(
		macros.run "PolyTools" "CreatePolygon"
	)
)

/** Create Polygon
 */
macroscript epoly_tools_Create_Polygon
category:	"_Epoly-Tools-Main"
icon:	"MENU:true"
buttonText:	"Create Polygon"
(
	on isVisible	do return isEpoly()	and	isSubObject( 1 )

	on execute do
	(
		macros.run "Ribbon - Modeling" "CreatePolygon"
	)
)

/** Target Weld
 */
macroscript epoly_tools_Target_Weld
category:	"_Epoly-Tools-Main"
icon:	"MENU:true"
buttonText:	"Target Weld"
(
	on isVisible	do return isEpoly()	and	isSubObject( 1 )

	on execute do
	(
		macros.run "Editable Polygon Object" "EPoly_TargetWeld"
	)
)

/** Edit Triangulation
 */
macroscript epoly_tools_Edit_Triangulation
category:	"_Epoly-Tools-Main"
icon:	"MENU:true"
buttonText:	"Edit Triangulation"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do
	(
		macros.run "Ribbon - Modeling" "EditTriangulation"
	)
)

/** Turn Edge
 */
macroscript epoly_tools_Turn_Edge
category:	"_Epoly-Tools-Main"
icon:	"MENU:true"
buttonText:	"Turn Edge"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do
	(
		macros.run "Ribbon - Modeling" "TurnEdge"
	)
)

