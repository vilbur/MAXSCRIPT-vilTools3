
/*------------------------------------------------------------------------------
	ALIGN SLICE GIZMO
--------------------------------------------------------------------------------*/

--******************************************************************************************************
-- Created: 		26-06-2015
-- Last Updated:	--	"23.2.2020 ?. 22:49:19"
-- Version:			1.10
--
-- Author :  Kostadin Kotev / miau_u@yahoo.com / http://miauumaxscript.blogspot.com/
-- Version:  3ds max 2009 (10) (should work in older versions too!)
--
-- Discription: Align Slice Plane(Gizmo) of Slice Modifier to 3 points picked in the scene
--	If Shift key is pressed the Slice Plane will be aligned to the currently active grid(home grid if no custom atcive grid is used)
-- Usage: RUN IT
--
-- Requested here: http://www.scriptspot.com/forums/3ds-max/scripts-wanted/align-slice-modifier-gizmo-to-3points
--
--******************************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK

macroscript	modifier_align_gizmo
category:	"_Modifiers-Gizmo"
buttonText:	"Align Slice"
tooltip:	"Align Slice Gizmo to 3 pts. \nShift: Hold to align to Active Grid"
icon:	"MENU:true"
autoUndoEnabled: true
(
	--clearListener()
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIERS\Gizmo.mcr"

	on isVIsible return selection.count > 0 and classof ( modPanel.getCurrentObject()) == SliceModifier

	on execute do  with undo off
	(
		obj = selection[1]

		curr_mod = modPanel.getCurrentObject()

		if classOf curr_mod == SliceModifier do
		(
			local pos01 = undefined
			local pos02 = undefined
			local pos03 = undefined

			local curSnapMode = snapMode.active
			local curSnapType = snapMode.type

			if keyboard.shiftPressed then
			(
				actGrid = activeGrid
				if actGrid != undefined and isValidNode actGrid then
				(
					pos01 = [50,0,0] * actGrid.transform
					pos02 = [-50,0,0] * actGrid.transform
					pos03 = [0,50,0] * actGrid.transform
				)
				else
				(
					pos01 = [50,0,0]
					pos02 = [-50,0,0]
					pos03 = [0,50,0]
				)
			)
			else
			(
				snapMode.active = true
				snapMode.type = #3D

				pos01 = pickPoint snap:#3d
				if classof pos01 == point3 do
					pos02 = pickPoint snap:#3d rubberBand:pos01
				if classof pos02 == point3 do
					pos03 = pickPoint snap:#3d rubberBand:pos02

				snapMode.active = curSnapMode

				try( snapMode.type = curSnapType )catch()
			)

			if classof pos01 == point3 and classof pos02 == point3 and classof pos03 == point3 do
			(
				local vect1 = normalize (pos02 - pos01)
				local vect2 = normalize (pos03 - pos02)
				local vect3 = normalize (cross vect2 vect1)
				vect2 = cross vect3 vect1


				objTM = obj.objectTransform
				modTM = getModContextTM obj curr_mod
				tempMatrix = ((matrix3 vect1 vect2 vect3 ((pos01 + pos02 + pos03) / 3) )) * modTM * (inverse objTM)

				curr_mod.slice_plane.transform = tempMatrix
			)
		)
	)
)


/*------------------------------------------------------------------------------
	ALIGN SLICE GIZMO
--------------------------------------------------------------------------------*/


/** Edit ffd spinner callback
  *
  */
function editFFDcallback val inpsin =
(
	--format "\n"; print "GIZMO.mcr.editFFDcallback()"
	format "EventFired:	% \n" EventFired

	if classOf (curr_mod = modPanel.getCurrentObject()) == FFDBox then
	(
		max modify mode

		setDimensions curr_mod [ DIALOG_editffd.SPIN_length.value, DIALOG_editffd.SPIN_width.value, DIALOG_editffd.SPIN_height.value]
	)
	else
		messageBox "FFD Box is not active" title:"EDIT FFD BOX"

)

macroscript	modifier_set_ffd
category:	"_Modifiers-Gizmo"
buttonText:	"Set FFDxBox"
tooltip:	"Set points of current active FFDxBox"
icon:	"MENU:true"
autoUndoEnabled: true
(
	--clearListener(); print("Cleared in:"+getSourceFileName())
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIERS\Gizmo.mcr"

	on isVIsible return selection.count > 0 and classof ( modPanel.getCurrentObject()) == FFDBox


	on execute do
	(
		max modify mode

		if classOf (curr_mod = modPanel.getCurrentObject()) == FFDBox then
		(
			global DIALOG_editffd

			ffd_current = getDimensions curr_mod

			/* DIALOG */
			_Dialog = Dialog_v ("EditFFD") --ini:(getSourceFileName())

			/* CONTROLS */
			_Controls   = _Dialog.Controls() --group:"Controls"

			/* CONTROLS */
			dimensions = #( #Length, #Width, #Height )
			for i = 1 to dimensions.count do
			(
				_Control = _Controls.control #spinner ( toUpper ( dimensions[i]  as string ) ) across:1 offset:[0,16] range:[2, 1000, ffd_current[i] ] params: #(#type, #integer)

				_Control.Event #changed "editFFDcallback"
			)

			/* DIALOG CREATE */
			_Dialog.create width:128

		)
		else
			messageBox "FFD Box is not active" title:"EDIT FFD BOX"
	)
)
