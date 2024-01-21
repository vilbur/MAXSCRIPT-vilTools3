filein( getFilenamePath(getSourceFileName()) + "/Lib/setSlicePlaneModifier.ms" )	-- "./Lib/setSlicePlaneModifier.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/createElevationSliderDialog.ms" )	-- "./Lib/createElevationSliderDialog.ms"



/**
  *
  */
macroscript	print_create_slicerdialog
category:	"_3D-Print"
buttontext:	"Slice Object"
tooltip:	"Slice selected object"
icon:	"across:4|height:32"
(
	on execute do
		(
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\1-SLICE PLANE.mcr"

			createElevationSliderDialog()


			if  ROLLOUT_print_3d.CBX_slice_top.state then
				setSlicePlaneModifier (#TOP) (#TRUE) (DIALOG_elevation_slider.SLIDER_elevation.value) (ROLLOUT_print_3d.CBX_cap_slice.state)

			if  ROLLOUT_print_3d.CBX_slice_bottom.state then
				setSlicePlaneModifier (#BOTTOM) (#TRUE) (DIALOG_elevation_slider.SLIDER_elevation.value) (ROLLOUT_print_3d.CBX_cap_slice.state)


		)
)

/**
  *
  */
macroscript	print_remove_slice_modifiers
category:	"_3D-Print"
buttontext:	"Slice Object"
tooltip:	"Remove slice modifiers from selected objects.\nUse all objects if nothing selected."
icon:	"across:4|height:32"
(
	on execute do
		(
			--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\1-SLICE PLANE.mcr"
			_selection = if selection.count == 0 then selection else geometry

			for mod_name in #( #SLICE_PLANE_TOP, #SLICE_PLANE_BOTTOM ) do
				for obj in _selection where obj.modifiers[mod_name] != undefined do
					deleteModifier obj obj.modifiers[mod_name]
		)
)



/*------------------------------------------------------------------------------

	CHECKBOXES

--------------------------------------------------------------------------------*/

/**
  *
  */
macroscript	_print_slice_plane_top
category:	"_3D-Print"
buttontext:	"Slice Top"
tooltip:	"Slice plane top"
icon:	"control:checkbox|autorun:false|across:4|height:32|offset:[ 12, 0 ]"
(
	on execute do
		undo "Slice Plane" on
		(
			--clearListener(); print("Cleared in:\n"+getSourceFileName())
			format "EventFired:	% \n" EventFired
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\1-SLICE PLANE.mcr"

			if EventFired.val then
				setSlicePlaneModifier (#TOP) (#TRUE) (DIALOG_elevation_slider.SLIDER_elevation.value) (ROLLOUT_print_3d.CBX_cap_slice.state)

			else if  ( _modifier = $.modifiers[#TOP] ) != undefined then
				deleteModifier $ _modifier

		)
)


/**
  *
  */
macroscript	_print_slice_plane_bottom
category:	"_3D-Print"
buttontext:	"Slice Bottom"
tooltip:	"Slice plane bottom"
icon:	"control:checkbox|autorun:false|across:4|height:32"
(
	on execute do
		undo "Slice Plane" on
		(
			--clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\1-SLICE PLANE.mcr"
			--format "EventFired:	% \n" EventFired
			--setSlicePlaneModifier (#BOTTOM) (#TRUE) (ROLLOUT_print_3d.SLIDER_set_elevation.value)

			if EventFired.val then
				setSlicePlaneModifier (#BOTTOM) (#TRUE) (DIALOG_elevation_slider.SLIDER_elevation.value) (ROLLOUT_print_3d.CBX_cap_slice.state)

			else if  ( _modifier = $.modifiers[#SLICE_PLANE_BOTTOM] ) != undefined then
				deleteModifier $ _modifier

		)
)

/**
  *
  */
macroscript	_print_slice_plane_cap
category:	"_3D-Print"
buttontext:	"Cap Slice"
tooltip:	"Cap Slice plane"
icon:	"control:checkbox|autorun:false|across:4|height:32"
(
	on execute do
		undo "Slice Plane" on
		(
			--clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\1-SLICE PLANE.mcr"
			format "EventFired:	% \n" EventFired


			for obj in geometry do
				for mod_name in #( #SLICE_PLANE_TOP, #SLICE_PLANE_BOTTOM ) where ( slice_mod = obj.modifiers[mod_name] ) != undefined do
					slice_mod.cap = EventFired.val

		)
)