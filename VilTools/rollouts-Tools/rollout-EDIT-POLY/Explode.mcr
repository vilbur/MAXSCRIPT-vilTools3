filein( getFilenamePath(getSourceFileName()) + "/Lib/EditPolyExplode/EditPolyExplode.ms" )

macroscript	epoly_explode_by_element
category:	"_Epoly-Explode"
buttonText:	"Elements"
toolTip:	"Explode by Elements"
icon:	"across:5|width:80"
(
	--clearListener()
	undo "explodeByElement" on
	(
		final_sel = (EditPolyExplode_v( selection )).explodeByElement()

		select final_sel

	)
	--macros.run "_Material" "materialByObject"
)

macroscript	epoly_explode_by_material
category:	"_Epoly-Explode"
buttontext:	"Material"
toolTip:	"Explode by Material"
(
	undo "explodeByMaterialId" on
	(
		final_sel = (EditPolyExplode_v( selection )).explodeByMaterialId()

		select final_sel
	)
)

macroscript	epoly_explode_by_sg
category:	"_Epoly-Explode"
buttonText:	"Smooth Group"
toolTip:	"Explode by SmoothGroups"
(
	undo "explodeBySG" on
	(
		final_sel = (EditPolyExplode_v( selection )).explodeBySG()

		select final_sel
	)
)


macroscript	epoly_explode_by_selected_edge
category:	"_Epoly-Explode"
buttontext:	"Edges"
toolTip:	"Explode by selected edges"
(
	undo "explode By Edges" on
	(
		final_sel = (EditPolyExplode_v( selection )).explodeByElement()

		select final_sel
	)
)


macroscript	epoly_explode_by_hard_edge
category:	"_Epoly-Explode"
buttontext:	"Hard Edges"
toolTip:	"Explode by  HARD edges"
(
	undo "explodeByHardEdges" on
	(

		final_sel = (EditPolyExplode_v( selection )).explodeByHardEdges()

		select final_sel
	)
)