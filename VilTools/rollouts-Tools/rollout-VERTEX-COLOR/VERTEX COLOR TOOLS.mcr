
/**
  *
  */
macroscript	epoly_vertex_color_select_lovest_vert_and_set_vertex_color
category:	"_Epoly-Vertex-Color-Tools"
buttonText:	"Color to LOWEST"
toolTip:	"Vertex color to lowest vert.\n\nSelect bunnch of Edit\Etitable poly vertices.\nThis function will select lowest on Z axis and set vertex color to it\n\n"
icon:	"MENU:true|tooltip:\n\n----------------------\n\nFIX IF NOT WORK PROPERLY:\\n1) Try clean mesh, weld verts and close borders"
(
	on execute do undo "Color to lowest vert" on
	(

		macros.run "_Epoly-Selection" "epoly_select_lowest_point"

		macros.run "_Epoly-Vertex-Color" "epoly_vertex_color_set_to_baseobject"


	)

)