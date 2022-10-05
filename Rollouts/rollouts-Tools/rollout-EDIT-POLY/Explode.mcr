macroscript	epoly_explode_by_element
category:	"_Epoly-Explode"  
buttonText:	"Elements"
toolTip:	"Explode by Elements"
(
	--clearListener()
	undo "explodeByElement" on
	(
		/* hotfix */
		macros.run "Modifier Stack" "Convert_to_Poly"
		
		final_sel = (Epoly_v()).explodeByElement()
	
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
		--/* hotfix */
		--macros.run "Modifier Stack" "Convert_to_Poly"
		--
		--final_sel = (Epoly_v()).explodeByMaterialId()
		--select final_sel
	)
)

macroscript	epoly_explode_by_sg
category:	"_Epoly-Explode"  
buttonText:	"Smooth Groups"
toolTip:	"Explode by SmoothGroups"
(
	undo "explodeBySG" on
	(
		--/* hotfix */
		--macros.run "Modifier Stack" "Convert_to_Poly"
		--
		--final_sel = (Epoly_v()).explodeBySG()
		--select final_sel
	)
)

macroscript	epoly_explode_by_hard_edge
category:	"_Epoly-Explode"
buttontext:	"By Hard edges"
toolTip:	"Explode by  HARD edges"
(
	undo "explodeByHardEdges" on
	(
		--/* hotfix */
		--macros.run "Modifier Stack" "Convert_to_Poly"
		--final_sel = (Epoly_v()).explodeByHardEdges()
		--select final_sel
	)
)


macroscript	epoly_explode_by_selected_edge
category:	"_Epoly-Explode"
buttontext:	"By edges"
toolTip:	"Explode by selected edges"
(
	undo "explode By Edges" on
	(
		--macros.run "Editable Polygon Object" "EPoly_Split"
		--
		--final_sel = (Epoly_v()).explodeByElement()
		--
		--select final_sel
	)
)


















