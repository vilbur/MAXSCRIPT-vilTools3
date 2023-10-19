filein( getFilenamePath(getSourceFileName()) + "/Lib/EPolyRingLoop/EPolyRingLoop.ms" )	-- "./Lib/EPolyRingLoop/EPolyRingLoop.ms"

--filein( getFilenamePath(getSourceFileName()) + "/Lib/EpolySelection/EpolySelection.ms" ) -- "./Lib/EpolySelection/EpolySelection.ms"

--macroscript	epolyselection_by_mouse
--category:	"_Epoly-EpolySelection"
--buttontext:	"SELECTION BY MOUSE"
--toolTip:	"Select Loop\Ring by mouse wheele"
--icon:	"control:checkbutton|across:1|width:256"
--(
--	--messageBox "Yupiii" title:"Title"  beep:false
--	--(EPolyRingLoop_v()).selectLoopRing #LOOP #UP #MOVE
--	--format "EventFired:	% \n" EventFired
--	ahk_path =  case EventFired.val of
--	(
--		true:   ( getFilenamePath(getSourceFileName()) + "/Lib/EpolySelection/selectLoopOrRingOnMouseWheel.ahk" ) -- "./Lib/EpolySelection/selectLoopOrRingOnMouseWheel.ahk"
--		false:  ( getFilenamePath(getSourceFileName()) + "/Lib/EpolySelection/mouseKill.ahk" ) -- "./Lib/EpolySelection/mouseKill.ahk"
--
--	)
--	format "ahk_path:	% \n" ahk_path
--	--DOSCommand( "start \"\" """+ahk_path+"""")
--	ShellLaunch ( "\""+ahk_path+"\"") ""
--)

/*==============================================================================
	LOOP
================================================================================*/

/*------ MOVE ------*/
macroscript	epolyselection_move_loop_up
category:	"_Epoly-EpolySelection"
buttontext:	"Loop move"
toolTip:	"Move loop up"
icon:	"across:3|width:96"
(
	--print "\n\nMOVE LOOP\n\n"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-EDIT-POLY\Lib\EPolyRingLoop\EPolyRingLoop.ms"
	(EPolyRingLoop_v()).selectLoopRing #LOOP #UP #MOVE
)

macroscript	epolyselection_move_loop_down
category:	"_Epoly-EpolySelection"
buttontext:	"Loop move"
toolTip:	"Move loop down"
--icon:	"#(path, index)"
(
	--print "\n\nMOVE LOOP UP\n\n"
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-EDIT-POLY\Lib\EPolyRingLoop\EPolyRingLoop.ms"

	(EPolyRingLoop_v()).selectLoopRing #LOOP #DOWN #MOVE
)




/*------ SELECT UP ------*/
macroscript	epolyselection_select_loop_up
category:	"_Epoly-EpolySelection"
buttontext:	"Select up"
toolTip:	"Select loop up"
--icon:	"#(path, index)"
(
	--print "\n\nSELECT UP\n\n"
	(EPolyRingLoop_v()).selectLoopRing #LOOP #UP #SELECT
)

/*------ DESELECT DOWN ------*/
macroscript	epolyselection_deselect_loop_up
category:	"_Epoly-EpolySelection"
buttontext:	"Select up"
toolTip:	"Deselect loop up"
--icon:	"#(path, index)"
(
	--print "\n\nDESELECT UP\n\n"
	(EPolyRingLoop_v()).selectLoopRing #LOOP #DOWN #DESELECT
)




/*------ SELECT DOWN ------*/
macroscript	epolyselection_select_loop_down
category:	"_Epoly-EpolySelection"
buttontext:	"Select down"
toolTip:	"Select loop down"
--icon:	"#(path, index)"
(
	--print "\n\nSELECT DOWN\n\n"
	(EPolyRingLoop_v()).selectLoopRing #LOOP #DOWN #SELECT
)

/*------ DESELECT UP ------*/
macroscript	epolyselection_deselect_loop_down
category:	"_Epoly-EpolySelection"
buttontext:	"Select down"
toolTip:	"Deselect loop down"
--icon:	"#(path, index)"
(
	--print "\n\nDESELECT DOWN\n\n"
	(EPolyRingLoop_v()).selectLoopRing #LOOP #UP #DESELECT
)



/*==============================================================================
	RING
================================================================================*/

/*------ MOVE ------*/
macroscript	epolyselection_move_ring_up
category:	"_Epoly-EpolySelection"
buttontext:	"Ring move"
toolTip:	"Move ring up"
--icon:	"#(path, index)"
(
	(EPolyRingLoop_v()).selectLoopRing #ring #UP #MOVE
)

macroscript	epolyselection_move_ring_down
category:	"_Epoly-EpolySelection"
buttontext:	"Ring move"
toolTip:	"Move ring down"
--icon:	"#(path, index)"
(
	(EPolyRingLoop_v()).selectLoopRing #ring #DOWN #MOVE
)




/*------ SELECT UP ------*/
macroscript	epolyselection_select_ring_up
category:	"_Epoly-EpolySelection"
buttontext:	"Ring up"
toolTip:	"Select ring up"
--icon:	"#(path, index)"
(
	(EPolyRingLoop_v()).selectLoopRing #ring #UP #SELECT
)

/*------ DESELECT UP ------*/
macroscript	epolyselection_deselect_ring_up
category:	"_Epoly-EpolySelection"
buttontext:	"Ring up"
toolTip:	"Deselect ring up"
--icon:	"#(path, index)"
(
	(EPolyRingLoop_v()).selectLoopRing #ring #DOWN #DESELECT
)




/*------ SELECT DOWN ------*/
macroscript	epolyselection_select_ring_down
category:	"_Epoly-EpolySelection"
buttontext:	"Ring down"
toolTip:	"Select ring down"
--icon:	"#(path, index)"
(
	(EPolyRingLoop_v()).selectLoopRing #ring #DOWN #SELECT
)

/*------ DESELECT DOWN ------*/
macroscript	epolyselection_deselect_ring_down
category:	"_Epoly-EpolySelection"
buttontext:	"Ring down"
toolTip:	"Deselect ring down"
--icon:	"#(path, index)"
(
	(EPolyRingLoop_v()).selectLoopRing #ring #UP #DESELECT
)
