
/** Test keyboard mod keys
  */
function isKeyPressed key = execute ("keyboard."+key as string +"Pressed")

/** Execute smart key
  */
function epolySmartKey direction =
(
	--format "\n"; print "Smart-UI.mcr.epolySmartKey()"

	curr_mod = modPanel.getCurrentObject()
	--
	--
	--if classOf curr_mod != Edit_Poly and classOf curr_mod != Editable_Poly  then
	--	return false

	/*------ EDGE ------*/
	if subObjectLevel == 2 then
	(
		RingLoop = EPolyRingLoop_v()

		case direction of
		(
			#UP: case of
			(
				( isKeyPressed #ALT and isKeyPressed #CONTROL ):	RingLoop.selectLoopRing #RING	#UP	#SELECT
				( isKeyPressed #ALT and isKeyPressed #SHIFT ):	RingLoop.selectLoopRing #RING	#DOWN	#DESELECT

				( isKeyPressed #CONTROL ):	RingLoop.selectLoopRing #LOOP	#UP	#SELECT
				( isKeyPressed #SHIFT ):	RingLoop.selectLoopRing #LOOP	#DOWN	#DESELECT

				( isKeyPressed #ALT ):	RingLoop.selectLoopRing #RING	#UP	#MOVE
				default:	RingLoop.selectLoopRing #LOOP	#UP	#MOVE
			)


			#DOWN: case of
			(
				( isKeyPressed #ALT and isKeyPressed #CONTROL ):	RingLoop.selectLoopRing #RING	#DOWN	#SELECT
				( isKeyPressed #ALT and isKeyPressed #SHIFT ):	RingLoop.selectLoopRing #RING	#UP	#DESELECT

				( isKeyPressed #CONTROL ):	RingLoop.selectLoopRing #LOOP	#DOWN	#SELECT
				( isKeyPressed #SHIFT ):	RingLoop.selectLoopRing #LOOP	#UP	#DESELECT

				( isKeyPressed #ALT ):	RingLoop.selectLoopRing #RING	#DOWN	#MOVE
				default:	RingLoop.selectLoopRing #LOOP	#DOWN	#MOVE
			)

		)
	)
	else
	(
		case of
		(
			--( isKeyPressed #ALT and isKeyPressed #CONTROL ):
			--( isKeyPressed #ALT and isKeyPressed #SHIFT ):
			--
			--( isKeyPressed #CONTROL ):
			--( isKeyPressed #SHIFT ):
			--
			--( isKeyPressed #ALT ):
			default:curr_mod.ButtonOp (if direction == #UP then #GrowSelection else #ShrinkSelection )
		)
	)

	--if direction == #UP then
	--(
	--
	--)
	--else if direction == #DOWN then
	--(
	--
	--
	--)
)


/** Next
 */
macroscript _smart_ui_up
category:	"_Smart-UI"
buttonText:	"Smart Up"
tooltip:	""
icon:	"MENU:true|tooltip:EPOLY EDGE:\n\nLMB:	Move Loop \nCtrl:	Grow Loop \nShift:	Shrink Loop \n\nAlt:	Move Ring \nCtrl+Alt:	Grow Ring \nCtrl+Shift:	Shrink Loop"
--autoUndoEnabled:	true

(
	on execute do
	(
		if DIALOG_elevation_slider == undefined then
		(

			--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-UI\Smart-UI.mcr"
			curr_mod = modPanel.getCurrentObject()

			if (classOf curr_mod == Edit_Poly or classOf curr_mod == Editable_Poly) and subObjectLevel > 0 then
				epolySmartKey (#UP)

			else
				macros.run "_Modifiers-Remote-Stack" "modifier_smart_remote_up"

		)
		else
			macros.run "_3D-Print" "_print_slice_increment_plus"



	)

)

/** Next
 */
macroscript _smart_ui_down
category:	"_Smart-UI"
buttonText:	"Smart Down"
--tooltip:	"Subobject of Edit Poly"
icon:	"MENU:true"
--autoUndoEnabled:	true

(
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-UI\Smart-UI.mcr"

		if DIALOG_elevation_slider == undefined then
		(

			--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-UI\Smart-UI.mcr"
			curr_mod = modPanel.getCurrentObject()

			if (classOf curr_mod == Edit_Poly or classOf curr_mod == Editable_Poly) and subObjectLevel > 0 then
				epolySmartKey (#DOWN)

			else
				macros.run "_Modifiers-Remote-Stack" "modifier_smart_remote_down"

		)
		else
			macros.run "_3D-Print" "_print_slice_increment_minus"




	)


)
