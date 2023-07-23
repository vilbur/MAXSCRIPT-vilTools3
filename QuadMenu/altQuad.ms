/*
   DOCUMENTATION: "./readme.md"
*/

AltQuad 	= QuadMenu_v("_Alt Quad")

QuadMenu1	= AltQuad.Quads[1]
QuadMenu2	= AltQuad.Quads[2]
QuadMenu3	= AltQuad.Quads[3]
QuadMenu4	= AltQuad.Quads[4]



/*==============================================================================

	QUAD 1 - BOTTOM - RIGHT

================================================================================*/
function editQuad1 =
(
	QuadMenu1.setTitle("Title            ")

	--DefaultMenu 	= (QuadMenu_v("Title")).Quads[1].menu

	--QuadMenu1.addSeparator()

	--QuadMenu2.addMenu("MenuName") --flat:false --index:1
	--QuadMenu1.addMenu(DefaultMenu) --flat:false --index:1
)

/*==============================================================================

	QUAD 2 - TOP - RIGHT

================================================================================*/
function editQuad2 =
(
	--QuadMenu2.setTitle("Title            ")

	--QuadMenu2.addMenu("MenuName") --flat:false --index:1
)

/*==============================================================================

	QUAD 3 - TOP - LEFT

================================================================================*/
function editQuad3 =
(
	--QuadMenu3.setTitle("               Title")

	--QuadMenu3.addMenu("MenuName") --flat:false --index:1
)

/*==============================================================================

	QUAD 4 - BOTTOM - LEFT

================================================================================*/
function editQuad4 =
(
	--QuadMenu4.setTitle("               Title")

	--QuadMenu4.addMenu("MenuName") --flat:false --index:1
)


/*==============================================================================

	RUN EDIT FUNCTIONS

================================================================================*/
editQuad1()
editQuad2()
editQuad3()
editQuad4()


/* Set options */
AltQuad.setRightClick which:#altPressed --which:#nonePressed #shiftPressed #altPressed #controlPressed #shiftAndAltPressed #shiftAndControlPressed #controlAndAltPressed #shiftAndAltAndControlPressed

--AltQuad.showAllQuads()
