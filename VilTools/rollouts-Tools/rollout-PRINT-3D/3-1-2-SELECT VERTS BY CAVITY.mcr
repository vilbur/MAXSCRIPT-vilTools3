filein( getFilenamePath(getSourceFileName()) + "/../rollout-SELECTION - EDIT POLY/Lib/VertSelector/VertSelector.ms" )	--"./../rollout-SELECTION - EDIT POLY/Lib/VertSelector/VertSelector.ms"

/** Select verts by cavity
	All verts are used if nothing selected

  @param #CONVEX|#CONCAVE|#MIXED|#CORNER


	CTRL:  Use all verts
	SHIFT: Select convex\concave and mixed

 */
function selectVertsByCavity mode =
(
	--format "\n"; print ".selectVertsByCavity()"

		VertSelector 	= VertSelector_v( selection[1] )

		ctrl = keyboard.controlPressed
		alt = keyboard.altPressed
		shift = keyboard.shiftPressed

		--mode = case of
		--(
		--	( shift ):	#( mode,  #MIXED	)
		--	--( ctrl and shift ):	#( #CONCAVE, #MIXED	)
		--	--( alt and shift):	#( #CORNER,  #MIXED	)
		--	--( alt ):	#MIXED
		--
		--	default:	mode
		--)
		if shift then
			mode = #( mode, #MIXED  )


		verts = case of
		(
			( ctrl ):	#ALL
			default:	#ALL_OR_SELECTED
		)

		timer_CONVEX = timeStamp()
		VertSelector.getConvexVerts mode:mode verts:verts
		--format "\n CONVEX: % ms\n" (( timeStamp()) - timer_CONVEX)

)


/* CONVEX VERTS
  *
  */
macroscript	_print_select_verts_convex
category:	"_Print-Select-by-cavity"
buttonText:	"Convex"
toolTip:	"Select Convex Verts"
icon:	"MENU:true|across:4|height:24|tooltip:CTRL:  #Concave\n:ALT:   #Flat\nSHIFT: #Convex and #Flat\n\nCTRL + SHIFT: #Convex and #Flat\nALT  +  SHIFT: #Corner and #Flat\n"
(
	on execute do
		undo "Select Convex Verts" on
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\3-1-2-SELECT VERTS BY CAVITY.mcr"
			selectVertsByCavity #CONVEX

	)
)


/* CONCAVE VERTS
  *
  */
macroscript	_print_select_verts_concave
category:	"_Print-Select-by-cavity"
buttonText:	"Concave"
toolTip:	"Select Concave Verts"
icon:	"MENU:true|across:4|height:24"
(
	on execute do
		undo "Select Concave Verts" on
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\3-1-2-SELECT VERTS BY CAVITY.mcr"
			selectVertsByCavity #CONCAVE

	)
)

/* CORNER VERTS
  *
  */
macroscript	_print_select_verts_corner
category:	"_Print-Select-by-cavity"
buttonText:	"Corner"
toolTip:	"Select Corner Verts"
icon:	"MENU:true|across:4|height:24"
(
	on execute do
		undo "Select Corner Verts" on
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\3-1-2-SELECT VERTS BY CAVITY.mcr"
			selectVertsByCavity #CORNER

	)
)


/* CONCAVE VERTS
  *
  */
macroscript	_print_select_verts_mixed
category:	"_Print-Select-by-cavity"
buttonText:	"Mixed"
toolTip:	"Select Convex\Concave Verts"
icon:	"MENU:true|across:4|height:24"
(
	on execute do
		undo "Select Convex\Concave Verts" on
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\3-1-2-SELECT VERTS BY CAVITY.mcr"
			selectVertsByCavity #MIXED

	)
)
