/*
   DOCUMENTATION: "./readme.md"
*/

global MainQuad = QuadMenu_v("_" + (getFilenameFile(getSourceFileName())))


/*==============================================================================

	QUAD 1 - BOTTOM - RIGHT

================================================================================*/
function editQuad1 QuadMenu =
(
	EditPolyMenu2	= Menu_v("Context Edit Poly Tools 2")
	SplineToolsMenu2	= Menu_v("Context Spline Tools 2")


	QuadMenu.setTitle("Edit            ")

	QuadMenu.addItem ("Modifier Stack") ("Convert_to_Poly") index:1

	QuadMenu.addSeparator()


	--QuadMenu.addMenu("_Epoly-Edit") --flat:false --index:1

	QuadMenu.addMenu(EditPolyMenu2) --flat:false --index:1


	--QuadMenu.addMenu(SnapToMenu) --flat:false --index:1

)

/*==============================================================================

	QUAD 2 - TOP - RIGHT

================================================================================*/
function editQuad2 QuadMenu =
(
	QuadMenu.setTitle("Transform            ")

	--QuadMenu.addMenu("MenuName") --flat:false --index:1
)

/*==============================================================================

	QUAD 3 - TOP - LEFT

================================================================================*/
function editQuad3 QuadMenu =
(
	QuadMenu.setTitle("               Snap")


	SnapMenu 	= (QuadMenu_v("Snap")).Quads[1]

	SnapMenu.moveItem ("Pivot") 4

	QuadMenu.addMenu(SnapMenu.menu) --flat:false --index:1



	--QuadMenu.addMenu("MenuName") --flat:false --index:1
)

/*==============================================================================

	QUAD 4 - BOTTOM - LEFT

================================================================================*/
function editQuad4 QuadMenu =
(
	QuadMenu.setTitle("               Selection")

	--QuadMenu.addMenu("MenuName") --flat:false --index:1

	QuadMenu.addMenu("_Wirecolor") --flat:false --index:1
)


/*==============================================================================

	RUN EDIT FUNCTIONS

================================================================================*/



editQuad1(MainQuad.Quads[1])
editQuad2(MainQuad.Quads[2])
editQuad3(MainQuad.Quads[3])
editQuad4(MainQuad.Quads[4])


/* Set options */
MainQuad.setRightClick() --which:#nonePressed #shiftPressed #altPressed #controlPressed #shiftAndAltPressed #shiftAndControlPressed #controlAndAltPressed #shiftAndAltAndControlPressed

--QuadMenu.showAllQuads()

MainQuad = undefined