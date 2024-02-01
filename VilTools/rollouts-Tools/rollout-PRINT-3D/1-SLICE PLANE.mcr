global ROLLOUT_print_3d
global DIALOG_elevation_slider

filein( getFilenamePath(getSourceFileName()) + "/Lib/getPlaneZpozition.ms" )	--"./Lib/getPlaneZpozition.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/setSlicePlaneModifier.ms" )	--"./Lib/setSlicePlaneModifier.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/setSelectPlaneModifier.ms" )	-- "./Lib/setSelectPlaneModifier.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/updateSlicePlaneSystem.ms" )	-- "./Lib/updateSlicePlaneSystem.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/createElevationSliderDialog.ms" )	-- "./Lib/createElevationSliderDialog.ms"


/**
  *
  */
macroscript	print_create_slicerdialog
category:	"_3D-Print"
buttontext:	"Slice Object"
tooltip:	"Slice selected object"
icon:	"across:5|height:32"
(
	on execute do
		(
			clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\1-SLICE PLANE.mcr"

			createElevationSliderDialog()


			--if  ROLLOUT_print_3d.CBX_slice_top.state then
			--	setSlicePlaneModifier (#TOP) (#TRUE) (DIALOG_elevation_slider.SLIDER_elevation.value) (ROLLOUT_print_3d.CBX_cap_slice.state)
			--
			--if  ROLLOUT_print_3d.CBX_slice_bottom.state then
			--	setSlicePlaneModifier (#BOTTOM) (#TRUE) (DIALOG_elevation_slider.SLIDER_elevation.value) (ROLLOUT_print_3d.CBX_cap_slice.state)


		)
)

/**
  *
  */
macroscript	print_remove_slice_modifiers
category:	"_3D-Print"
buttontext:	"Slice Object"
tooltip:	"Remove slice modifiers from selected objects.\nUse all objects if nothing selected."
icon:	"across:5|height:32"
(
	on execute do
		(
			--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\1-SLICE PLANE.mcr"
			try(
				cui.UnRegisterDialogBar DIALOG_elevation_slider

				destroyDialog DIALOG_elevation_slider
			)catch()

			_selection = if selection.count == 0 then selection else geometry

			for mod_name in #( #SLICE_PLANE_TOP, #SLICE_PLANE_BOTTOM, #SELECT_BY_PRINT_LAYER ) do
				for obj in objects where obj.modifiers[mod_name] != undefined do
					deleteModifier obj obj.modifiers[mod_name]

		)
)



/*------------------------------------------------------------------------------

	CHECKBOXES

--------------------------------------------------------------------------------*/
/**
  *
  */
macroscript	_print_slice_select_volume
category:	"_3D-Print"
buttontext:	"Select"
tooltip:	"Select verts in sliced layer"
icon:	"control:checkbox|id:#CBX_slice_select_plane|autorun:false|across:5|height:32|offset:[ 26, 0 ]"
(
	on execute do
		(
			format "EventFired	= % \n" EventFired
			if EventFired.val then
				updateSlicePlaneSystem(undefined)

			else
				for obj in objects where ( _modifier = obj.modifiers[#SELECT_BY_PRINT_LAYER] ) != undefined do
					deleteModifier obj _modifier
		)
)

/**
  *
  */
macroscript	_print_slice_plane_top
category:	"_3D-Print"
buttontext:	"Slice Top"
tooltip:	"Slice plane top"
icon:	"control:checkbox|autorun:false|across:5|height:32|offset:[ 10, 0 ]"
(
	on execute do
	(
		format "EventFired	= % \n" EventFired

		if EventFired.val then
		updateSlicePlaneSystem(undefined)

		else
			for obj in objects where ( _modifier = obj.modifiers[#SLICE_PLANE_TOP] ) != undefined do
				deleteModifier obj _modifier
	)
)


/**
  *
  */
macroscript	_print_slice_plane_bottom
category:	"_3D-Print"
buttontext:	"Slice Bottom"
tooltip:	"Slice plane bottom"
icon:	"control:checkbox|autorun:false|across:5|height:32|offset:[ 4, 0 ]"
(
	on execute do
	(
		format "EventFired	= % \n" EventFired

		if EventFired.val then
		updateSlicePlaneSystem(undefined)

		else
			for obj in objects where ( _modifier = obj.modifiers[#SLICE_PLANE_BOTTOM] ) != undefined do
				deleteModifier obj _modifier
	)
)

/**
  *
  */
macroscript	_print_slice_plane_cap
category:	"_3D-Print"
buttontext:	"Cap Slice"
tooltip:	"Cap Slice plane"
icon:	"control:checkbox|autorun:false|across:5|height:32|offset:[ 12, 0 ]"
(
	on execute do
		updateSlicePlaneSystem(undefined)
)