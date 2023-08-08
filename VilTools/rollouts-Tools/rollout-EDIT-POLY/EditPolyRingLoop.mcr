macroscript	epolyselection_select_loop_ring_te
category:	"_Epoly-Test"
buttontext:	"selectLoopRing"
toolTip:	"selectLoopRing Test"
--icon:	"#(path, index)"
(
	filein( getFilenamePath(getSourceFileName()) + "/Lib/EpolySelection/EpolySelection.ms" ) -- "./Lib/EpolySelection/EpolySelection.ms"

	(EpolySelection_v()).selectLoopRing #loop #forward #move
)