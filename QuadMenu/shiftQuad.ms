

ShiftQuad 	= QuadMenu_v("_Shift Quad")

QuadMenu1	= ShiftQuad.Quads[1]
QuadMenu2	= ShiftQuad.Quads[2]
QuadMenu3	= ShiftQuad.Quads[3]
QuadMenu4	= ShiftQuad.Quads[4]

/*
   DOCUMENTATION: "./readme.md"
*/

/*==============================================================================

	QUAD 1 - BOTTOM - RIGHT

================================================================================*/
function editQuad1 =
(
	QuadMenu1.setTitle("Selection            ")

	--SnapToMenu 	= (QuadMenu_v("Snap")).Quads[1].menu

	QuadMenu1.addMenu("_Selection") --flat:false --index:1

	--QuadMenu1.addSeparator()

	--QuadMenu1.addMenu(SnapToMenu) --flat:false --index:1
)

/*==============================================================================

	QUAD 2 - TOP - RIGHT

================================================================================*/
function editQuad2 =
(
	QuadMenu2.setTitle("Modifiers            ")

	QuadMenu2.addMenu("_Modifiers") --flat:false --index:1
)

/*==============================================================================

	QUAD 3 - TOP - LEFT

================================================================================*/
function editQuad3 =
(
	QuadMenu3.setTitle("               Layers")

	QuadMenu3.addMenu("_Layers") --flat:false --index:1

)

/*==============================================================================

	QUAD 4 - BOTTOM - LEFT

================================================================================*/
function editQuad4 =
(
	QuadMenu4.setTitle("              Group")


	GroupMenu	= Menu_v("_Group")
	GroupMenu.addSeparator index:#( 8, 6, 3)


	QuadMenu4.addMenu(GroupMenu) --flat:false --index:1

)


/*==============================================================================

	RUN EDIT FUNCTIONS

================================================================================*/



--editQuad1()
--editQuad2()
--editQuad3()
--editQuad4()

/* Set options */
ShiftQuad.setRightClick which:#shiftPressed --which:#nonePressed #shiftPressed #altPressed #controlPressed #shiftAndAltPressed #shiftAndControlPressed #controlAndAltPressed #shiftAndAltAndControlPressed

--ShiftQuad.showAllQuads()
