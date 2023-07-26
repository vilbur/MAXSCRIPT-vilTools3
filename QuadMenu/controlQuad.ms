/*
   DOCUMENTATION: "./readme.md"
*/

global MainQuad = QuadMenu_v("_" + (getFilenameFile(getSourceFileName())))

/*==============================================================================

	QUAD 1 - BOTTOM - RIGHT

================================================================================*/
function editQuad1 QuadMenu =
(
	QuadMenu.setTitle("Transform            ")

	--DefaulQuadMenu 	= (QuadMenuv("Title")).Quads[1]

	--QuadMenu.addSeparator()

	--QuadMenu.addMenu("MenuName")	--flat:true --index:1
	--QuadMenu.addMenu(DefaulQuadMenu.menu)	--flat:true --index:1
	--QuadMenu.addItem ("Category") ("macroscript_nmae") index:1
)

/*==============================================================================

	QUAD 2 - TOP - RIGHT

================================================================================*/
function editQuad2 QuadMenu =
(
	QuadMenu.setTitle("Create            ")

	standard_primitives_plugin = #(
		#hexasphere,
		#quadsphere
	)

	compound_primitives = #(
		#Loft,
		#Boolean,
		#ProBoolean,
		#Procutter,
		#Scatter,
		#ShapeMerge
	)

	helpers_primitives = #(
		#point,
		#tape,
		#protractor
	)

	shapes_primitives = #(
		#lines,
		#rectangle,
		#Text,
		#circle,
		#Ellipse,
		#ShapeMerge
	)

	CompoundsMenu	= (Menu_v("_Compound Primitives")).addItems("Objects Compounds")(compound_primitives)
	HelpersMenu	= (Menu_v("_Helpers Primitives")).addItems("Objects Helpers")(helpers_primitives)
	StandardPrimitiveMenu	= (Menu_v("Create - Standard.Primitives")).addItems("Objects Helpers")(standard_primitives_plugin)
	ShapesMenu	= (Menu_v("_Shapes Primitives")).addItems("Objects Shapes")(shapes_primitives)

	format "CompoundsMenu = % \n" CompoundsMenu
	format "StandardPrimitiveMenu = % \n" StandardPrimitiveMenu
	format "HelpersMenu = % \n" HelpersMenu


	QuadMenu.addMenu(StandardPrimitiveMenu)	flat:false --index:1

	QuadMenu.addSeparator()
	QuadMenu.addMenu(ShapesMenu)	flat:false --index:1

	QuadMenu.addSeparator()
	QuadMenu.addMenu(HelpersMenu)	flat:false --index:1

	QuadMenu.addSeparator()
	QuadMenu.addMenu(CompoundsMenu)	flat:false --index:1


	--QuadMenu.addSeparator()
	--QuadMenu.addMenu("Create - Shapes")	--flat:true --index:1

	--QuadMenu.addSeparator()
	--QuadMenu.addMenu("Create - Helpers")	--flat:true --index:1


)

/*==============================================================================

	QUAD 3 - TOP - LEFT

================================================================================*/
function editQuad3 QuadMenu =
(
	--format "\n"; print "controlQuad.editQuad3()"
	QuadMenu.setTitle("               Pivot")



	--QuadMenu.addItem ("Category") ("macroscript_nmae") index:1


)

/*==============================================================================

	QUAD 4 - BOTTOM - LEFT

================================================================================*/
function editQuad4 QuadMenu =
(
	QuadMenu.setTitle(" Snap           ")

	SnapMenu 	= (QuadMenu_v("Snap")).Quads[1]

	SnapMenu.moveItem ("Pivot") 4

	QuadMenu.addMenu(SnapMenu.menu)	--flat:true --index:1

	--QuadMenu.addMenu("MenuName")	--flat:true --index:1
)


/*==============================================================================

	RUN EDIT FUNCTIONS

================================================================================*/


--editQuad1(MainQuad.Quads[1])
editQuad2(MainQuad.Quads[2])
--editQuad3(MainQuad.Quads[3])
--editQuad4(MainQuad.Quads[4])


/* Set options */
MainQuad.setRightClick which:#controlPressed  --which:#nonePressed #shiftPressed #altPressed #controlPressed #shiftAndAltPressed #shiftAndControlPressed #controlAndAltPressed #shiftAndAltAndControlPressed

--MainQuad.showAllQuads()

MainQuad = undefined