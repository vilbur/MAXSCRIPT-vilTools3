/*
   DOCUMENTATION: "./readme.md"
*/

global MainQuad = QuadMenu_v("_" + (getFilenameFile(getSourceFileName())))

/*==============================================================================

	QUAD 1 - BOTTOM - RIGHT

================================================================================*/
function editQuad1 QuadMenu =
(
	QuadMenu.setTitle("Modifiers            ")

	ModifierStackMenu	= Menu_v("_Modifier Stack")

	--LayersVisibilityMenu.addSeparator index:#( 5, 3 )

	QuadMenu.addMenu(ModifierStackMenu)	--flat:false --index:1

	--DefaulQuadtMenu 	= (QuadMenuv("Title")).Quads[1]

	--QuadMenu.addSeparator()

	--QuadMenu.addMenu("MenuName")	--flat:false --index:1
	--QuadMenu.addMenu(DefaulQuadtMenu.menu)	--flat:false --index:1
	--QuadMenu.addItem ("Category") ("macroscript_nmae") index:1
)

/*==============================================================================

	QUAD 2 - TOP - RIGHT

================================================================================*/
function editQuad2 QuadMenu =
(
	QuadMenu.setTitle("Instances            ")

	--QuadMenu.addMenu("MenuName")	--flat:false --index:1
)

/*==============================================================================

	QUAD 3 - TOP - LEFT

================================================================================*/
function editQuad3 QuadMenu =
(

	QuadMenu.setTitle("               Layers")

	LayersMenu	= Menu_v("_Layers")
	LayersVisibilityMenu	= Menu_v("_Layers Visibility")

	LayersVisibilityMenu.addSeparator index:#( 5, 3 )


	QuadMenu.addMenu(LayersVisibilityMenu)	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu(LayersMenu)	--flat:false --index:1

)

/*==============================================================================

	QUAD 4 - BOTTOM - LEFT

================================================================================*/
function editQuad4 QuadMenu =
(
	QuadMenu.setTitle("               Group")

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
MainQuad.setRightClick which:#shiftPressed  --which:#nonePressed #shiftPressed #altPressed #controlPressed #shiftAndAltPressed #shiftAndControlPressed #controlAndAltPressed #shiftAndAltAndControlPressed

--MainQuad.showAllQuads()

MainQuad = undefined