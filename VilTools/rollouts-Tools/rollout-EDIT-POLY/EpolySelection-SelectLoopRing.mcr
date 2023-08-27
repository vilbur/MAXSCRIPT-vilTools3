filein( getFilenamePath(getSourceFileName()) + "/Lib/EpolySelection/EpolySelection.ms" ) -- "./Lib/EpolySelection/EpolySelection.ms"

macroscript	epolyselection_by_mouse
category:	"_Epoly-EpolySelection"
buttontext:	"SELECTION BY MOUSE"
toolTip:	"Select Loop\Ring by mouse wheele"
icon:	"control:checkbutton|across:1|width:256"
(
	--messageBox "Yupiii" title:"Title"  beep:false
	--(EpolySelection_v()).selectLoopRing #loop #forward #move
	--format "EventFired:	% \n" EventFired
	ahk_path =  case EventFired.val of
	(
		true:   ( getFilenamePath(getSourceFileName()) + "/Lib/EpolySelection/selectLoopOrRingOnMouseWheel.ahk" ) -- "./Lib/EpolySelection/selectLoopOrRingOnMouseWheel.ahk"
		false:  ( getFilenamePath(getSourceFileName()) + "/Lib/EpolySelection/mouseKill.ahk" ) -- "./Lib/EpolySelection/mouseKill.ahk"
 
	)
	format "ahk_path:	% \n" ahk_path
	--DOSCommand( "start \"\" """+ahk_path+"""")
	ShellLaunch ( "\""+ahk_path+"\"") ""
)

/*------------------------------------------------------------------------------
	LOOP
--------------------------------------------------------------------------------*/
macroscript	epolyselection_move_loop_up
category:	"_Epoly-EpolySelection"
buttontext:	"Loop move"
toolTip:	"Move loop forward"
icon:	"across:3|width:96"
(
	print "\n\nMOVE LOOP\n\n"
	(EpolySelection_v()).selectLoopRing #loop #forward #move
)
macroscript	epolyselection_move_loop_down
category:	"_Epoly-EpolySelection"
buttontext:	"Loop move"
toolTip:	"Move loop reverse"
--icon:	"#(path, index)"
(
	print "\n\nMOVE LOOP REVERSE\n\n"
	(EpolySelection_v()).selectLoopRing #loop #reverse #move
)

macroscript	epolyselection_select_loop_up
category:	"_Epoly-EpolySelection"
buttontext:	"Select forward"
toolTip:	"Select loop forward"
--icon:	"#(path, index)"
(
	print "\n\nSELECT FORWARD\n\n"
	(EpolySelection_v()).selectLoopRing #loop #forward #select
)

macroscript	epolyselection_deselect_loop_up
category:	"_Epoly-EpolySelection"
buttontext:	"Select forward"
toolTip:	"Deselect loop forward"
--icon:	"#(path, index)"
(
	print "\n\nDESELECT FORWARD\n\n"
	(EpolySelection_v()).selectLoopRing #loop #forward #deselect
)


macroscript	epolyselection_select_loop_down
category:	"_Epoly-EpolySelection"
buttontext:	"Select reverse"
toolTip:	"Select loop reverse"
--icon:	"#(path, index)"
(
	print "\n\nSELECT BACKWARD\n\n"
	(EpolySelection_v()).selectLoopRing #loop #reverse #select
)

macroscript	epolyselection_deselect_loop_down
category:	"_Epoly-EpolySelection"
buttontext:	"Select reverse"
toolTip:	"Deselect loop reverse"
--icon:	"#(path, index)"
(
	print "\n\nDESELECT BACKWARD\n\n"
	(EpolySelection_v()).selectLoopRing #loop #reverse #deselect
)


/*------------------------------------------------------------------------------
	RING
--------------------------------------------------------------------------------*/
macroscript	epolyselection_move_ring_up
category:	"_Epoly-EpolySelection"
buttontext:	"Ring move"
toolTip:	"Move ring forward"
--icon:	"#(path, index)"
(
	(EpolySelection_v()).selectLoopRing #ring #forward #move
)
macroscript	epolyselection_move_ring_down
category:	"_Epoly-EpolySelection"
buttontext:	"Ring move"
toolTip:	"Move ring reverse"
--icon:	"#(path, index)"
(
	(EpolySelection_v()).selectLoopRing #ring #reverse #move
)

macroscript	epolyselection_select_ring_up
category:	"_Epoly-EpolySelection"
buttontext:	"Ring forward"
toolTip:	"Select ring forward"
--icon:	"#(path, index)"
(
	(EpolySelection_v()).selectLoopRing #ring #forward #select
)

macroscript	epolyselection_deselect_ring_up
category:	"_Epoly-EpolySelection"
buttontext:	"Ring forward"
toolTip:	"Deselect ring forward"
--icon:	"#(path, index)"
(
	(EpolySelection_v()).selectLoopRing #ring #forward #deselect
)

macroscript	epolyselection_select_ring_down
category:	"_Epoly-EpolySelection"
buttontext:	"Ring reverse"
toolTip:	"Select ring reverse"
--icon:	"#(path, index)"
(
	(EpolySelection_v()).selectLoopRing #ring #reverse #select
)

macroscript	epolyselection_deselect_ring_down
category:	"_Epoly-EpolySelection"
buttontext:	"Ring reverse"
toolTip:	"Deselect ring reverse"
--icon:	"#(path, index)"
(
	(EpolySelection_v()).selectLoopRing #ring #reverse #deselect
)
