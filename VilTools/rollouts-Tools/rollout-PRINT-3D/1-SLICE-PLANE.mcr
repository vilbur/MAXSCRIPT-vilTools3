filein( getFilenamePath(getSourceFileName()) + "/Lib/setSlicePlaneModifier.ms" )	-- "./Lib/setSlicePlaneModifier.ms"




/**
  *
  */
macroscript	_print_slice_plane_top
category:	"_3D-Print"
buttontext:	"Slice Top"
tooltip:	"Slice plane top"
icon:	"control:checkbox|across:3|height:32"
(
	on execute do
		undo "Slice Plane" on
		(
			--clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\1-SLICE-PLANE.mcr"

			if EventFired.val then
				setSlicePlaneModifier (#TOP) (#TRUE) (ROLLOUT_print_3d.SLIDER_set_elevation.value) (ROLLOUT_print_3d.CBX_cap_slice.state)

			else if  ( _modifier = $.modifiers[#SLICE_PLANE_TOP] ) != undefined then
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
icon:	"control:checkbox|across:3|height:32"
(
	on execute do
		undo "Slice Plane" on
		(
			--clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\1-SLICE-PLANE.mcr"
			--format "EventFired:	% \n" EventFired
			--setSlicePlaneModifier (#BOTTOM) (#TRUE) (ROLLOUT_print_3d.SLIDER_set_elevation.value)

			if EventFired.val then
				setSlicePlaneModifier (#BOTTOM) (#TRUE) (ROLLOUT_print_3d.SLIDER_set_elevation.value - 1 ) (ROLLOUT_print_3d.CBX_cap_slice.state)

			else if  ( _modifier = $.modifiers[#SLICE_PLANE_BOTTOM] ) != undefined then
				deleteModifier $ _modifier

			--setSlicePlaneModifier (#BOTTOM) (#TRUE) (ROLLOUT_print_3d.SLIDER_set_elevation.value -1)
		)
)

/**
  *
  */
macroscript	_print_slice_plane_cap
category:	"_3D-Print"
buttontext:	"Cap Slice"
tooltip:	"Cap Slice plane"
icon:	"control:checkbox|across:3|height:32"
(
	on execute do
		undo "Slice Plane" on
		(
			--clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-PRINT-3D\1-SLICE-PLANE.mcr"
			format "EventFired:	% \n" EventFired


			for obj in geometry do
				for mod_name in #( #SLICE_PLANE_TOP, #SLICE_PLANE_BOTTOM ) where ( slice_mod = obj.modifiers[mod_name] ) != undefined do
					slice_mod.cap = EventFired.val

		)
)