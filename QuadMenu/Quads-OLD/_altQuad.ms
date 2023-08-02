/*
   DOCUMENTATION: "./readme.md"

   IMPORTANT:
	SOME HOW IT IS NOT POSSIBLE TO REMAP "Animation" Quad Menu

	WORKAROUND:
		DEFAULT "Animation" QUAD MENU MUST BE MODIFIED
*/

--global MainQuad = QuadMenu_v("_" + (getFilenameFile(getSourceFileName())))
global MainQuad = QuadMenu_v("Animation")

/*==============================================================================

	QUAD 1 - BOTTOM - RIGHT

================================================================================*/
function editQuad1 QuadMenu =
(
	--QuadMenu.setTitle("Viewports            ")

	--DefaulQuadtMenu 	= (QuadMenuv("Title")).Quads[1]


	--QuadMenu.addMenu("MenuName")	--flat:false --index:1
	--QuadMenu.addMenu(DefaulQuadtMenu.menu)	--flat:false --index:1
	QuadMenu.addItem ("_Animation") ("_options_toggle_keyframe_0_1") index:1
	QuadMenu.addItem ("_Animation") ("_options_trackbar_show") index:2
	--QuadMenu.addSeparator index:2
	QuadMenu.addSeparator index:#(2,3)
)

/*==============================================================================

	QUAD 2 - TOP - RIGHT

================================================================================*/
function editQuad2 QuadMenu =
(
	QuadMenu.setTitle("Visibility        ")

	QuadMenu.addItem ("_Animation") ("_options_trackbar_show") index:2

	--QuadMenu.addMenu("MenuName")	--flat:false --index:1
)

/*==============================================================================

	QUAD 3 - TOP - LEFT

================================================================================*/
function editQuad3 QuadMenu =
(
	--QuadMenu.setTitle("_Animation            ")

	--QuadMenu.addMenu("_Animation")	--flat:false --index:1

)

/*==============================================================================

	QUAD 4 - BOTTOM - LEFT

================================================================================*/
function editQuad4 QuadMenu =
(
	--QuadMenu.setTitle("               Title")

	--QuadMenu.addMenu("MenuName")	--flat:false --index:1
)


/*==============================================================================

	RUN EDIT FUNCTIONS

================================================================================*/


editQuad1(MainQuad.Quads[1])
editQuad2(MainQuad.Quads[2])
editQuad3(MainQuad.Quads[3])
editQuad4(MainQuad.Quads[4])


/* Set options */
--MainQuad.setRightClick which:#altPressed  --which:#nonePressed #shiftPressed #altPressed #controlPressed #shiftAndAltPressed #shiftAndControlPressed #controlAndAltPressed #shiftAndAltAndControlPressed

--MainQuad.showAllQuads()

MainQuad = undefined