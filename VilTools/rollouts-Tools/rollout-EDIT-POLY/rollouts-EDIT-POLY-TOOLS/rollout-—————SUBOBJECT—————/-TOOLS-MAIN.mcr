/** Remove
 */
macroscript epoly_tools_Remove
icon:	"MENU:true"
buttonText:	"Remove"
category:	"_Epoly-Tools-Main"
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
icon:	"MENU:true"
buttonText:	"Split"
category:	"_Epoly-Tools-Main"
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
icon:	"MENU:true"
buttonText:	"Vertex Break"
category:	"_Epoly-Tools-Main"
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
icon:	"MENU:true"
buttonText:	"Cut"
category:	"_Epoly-Tools-Main"
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
icon:	"MENU:true"
buttonText:	"Quick Slice"
category:	"_Epoly-Tools-Main"
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
icon:	"MENU:true"
buttonText:	"Collapse"
category:	"_Epoly-Tools-Main"
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
icon:	"MENU:true"
buttonText:	"Cap"
category:	"_Epoly-Tools-Main"
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
icon:	"MENU:true"
buttonText:	"Cap Poly"
category:	"_Epoly-Tools-Main"
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
icon:	"MENU:true"
buttonText:	"Create Polygon"
category:	"_Epoly-Tools-Main"
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
icon:	"MENU:true"
buttonText:	"Target Weld"
category:	"_Epoly-Tools-Main"
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
icon:	"MENU:true"
buttonText:	"Edit Triangulation"
category:	"_Epoly-Tools-Main"
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
icon:	"MENU:true"
buttonText:	"Turn Edge"
category:	"_Epoly-Tools-Main"
(
	on isVisible	do return isEpoly()	and	isSubObject( 2 )

	on execute do
	(
		macros.run "Ribbon - Modeling" "TurnEdge"
	)
)

