filein( getFilenamePath(getSourceFileName()) + "/../rollout-SELECTION - EDIT POLY/Lib/VertSelector/VertSelector.ms" )	--"./../rollout-SELECTION - EDIT POLY/Lib/VertSelector/VertSelector.ms"


/**  Export format
  *
 */
macroscript	_print_select_vets_grid_resolution
category:	"_Print-Points-Tools"
buttonText:	"Grid"
toolTip:	"Get only signlge vertex of each face island"
icon:	"MENU:false|id:#SPIN_grid_step|control:spinner|range:[1, 100, 10]|type:#integer|across:4|height:24|offset:[ -8, 4]"
(
	on execute do
		format "EventFired	= % \n" EventFired

)

/**  Export format
  *
 */
macroscript	_print_select_lowest_verts
category:	"_Print-Points-Tools"
buttonText:	"Lowest Points"
toolTip:	"Get only signlge vertex of each face island"
icon:	"MENU:true|across:4|height:24"
(
	on execute do
	if selection.count > 0 then
	(
		--clearListener(); print("Cleared in:\n"+getSourceFileName())
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\3-1-2-POINTS TOOLS.mcr"

		obj	= selection[1]

		VertSelector 	= VertSelector_v( obj ) resolution:ROLLOUT_print_3d.SPIN_grid_step.value
		VertSelector.getLowestVerts()
		VertSelector.selectVerts()

	)
)


/**
  *
  */
macroscript	_print_select_single_vert_of_faces
category:	"_Print-Points-Tools"
buttonText:	"1 vert face"
toolTip:	"Get only signlge vertex of each face island"
icon:	"MENU:true|across:4|height:24"
(
	on execute do
	if subObjectLevel == 1 then
	undo "Filter 1 vert per face" on
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\3-1-2-POINTS TOOLS.mcr"

		VertSelector 	= VertSelector_v( selection[1] )

		VertSelector.getSingleVertPerFaceIsland()
		VertSelector.selectVerts()

	)
)

/**  Checkerboard selection
  *
 */
macroscript	_print_select_verts_checker_pattern
category:	"_Print-Points-Tools"
buttonText:	"Checkker"
toolTip:	"Get selection of selected vertices in cheker pattern"
icon:	"MENU:false|across:4|height:24"
(
	on execute do
	if selection.count > 0 then
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\3-1-2-POINTS TOOLS.mcr"

		obj	= selection[1]

		VertSelector 	= VertSelector_v( obj ) resolution:ROLLOUT_print_3d.SPIN_grid_step.value

		VertSelector.getCheckerSelection invert_sel:( keyboard.controlPressed )

		VertSelector.selectVerts()


	)
)


/**
  *
  */
macroscript	_print_select_convex_verts
category:	"_Print-Points-Tools"
buttonText:	"Convex"
toolTip:	"Select Convex Verts"
icon:	"MENU:true|across:4|height:24"
(
	on execute do
	if subObjectLevel == 1 then
	undo "Select Convex\Concave" on
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\3-1-2-POINTS TOOLS.mcr"

		--format "EventFired.val: %\n" EventFired.val
		ctrl = keyboard.controlPressed
		alt  = keyboard.altPressed
		shift  = keyboard.shiftPressed


		mode = case of
		(
			--( ctrl + shift ):	#( #FLAT, #CONCAVE)
			--( alt + shift):	#( #FLAT, #CORNER)
			( ctrl ):	#CONCAVE
			( alt ):	#FLAT
			--( shift ):	#( #FLAT, #CONVEX)

			default:	#CONVEX
		)

		VertSelector 	= VertSelector_v( selection[1] )

		VertSelector.getConvexVerts mode:mode

	)
)



