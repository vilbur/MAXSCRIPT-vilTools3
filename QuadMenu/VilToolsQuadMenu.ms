
MainQuad 	= QuadMenu_v("Default Viewport Quad")

QuadMenu1	= MainQuad.Quads[1]
QuadMenu2	= MainQuad.Quads[2]
QuadMenu3	= MainQuad.Quads[3]
QuadMenu4	= MainQuad.Quads[4]


/*==============================================================================


	REMOVE DEFAULT ITEMS


================================================================================*/

/**
		BOTTOM RIGHT quad menu - EDIT default items
 */
function removeItemsQuad1 =
(
	----format "\n"; print "VilToolsQuadMenu.removeItemsQuad1()"
	QuadMenu1.removeItem("Move")
	QuadMenu1.removeItem("Rotate")
	QuadMenu1.removeItem("Scale")
	QuadMenu1.removeItem("Select")
	QuadMenu1.removeItem("Clone")
	QuadMenu1.removeItem("Curve Editor...")
	QuadMenu1.removeItem("Dope Sheet...")
	QuadMenu1.removeItem("Wire Parameters...")
	QuadMenu1.removeItem("Select &Similar")

	--QuadMenu1.moveItem("Convert To:") 1

	QuadMenu1.cleanSeparators()
)

/**
		RIGHT TOP quad menu - EDIT default items
*/
function removeItemsQuad2 =
(
	QuadMenu2.removeItem("Viewport Lighting and Shadows")
	QuadMenu2.removeItem("Show Motion Paths")

	QuadMenu2.moveItem("Manage State Sets...") -1
	QuadMenu2.moveItem("State Sets") -1

)

/**
		TOP LEFT quad menu - EDIT default items
*/
function removeItemsQuad3 =
(
	QuadMenu3.removeItem("Sub-objects")
	--QuadMenu3.removeSeparator(1)

	EditPolyToolsMenu1 = Menu_v("Context Edit Poly Tools 1")
	EditPolyToolsMenu1.removeItem("Convert to Vertex")
	EditPolyToolsMenu1.removeItem("Convert to Edge")
	EditPolyToolsMenu1.removeItem("Convert to Face")


	QuadMenu3.cleanSeparators()

)

/**
		BOTTOM LEFT quad menu - EDIT default items
*/
function removeItemsQuad4 =
(
	--format "\n"; print ".removeItemsQuad4()"

	/** CONTEXT SPLINE TOOLS 2 */
	SplineToolsMenu2 = Menu_v("Context Spline Tools 2")

	SplineToolsMenu2.removeItem("Connect")
	SplineToolsMenu2.removeItem("Weld Vertices")

	/* CONTEXT EDIT POLY TOOLS 2 */
	EditPolyMenu2 = Menu_v("Context Edit Poly Tools 2")

	EditPolyMenu2.removeItem("Create")
	EditPolyMenu2.removeItem("Remove")
	EditPolyMenu2.removeItem("Weld")
	EditPolyMenu2.cleanSeparators()

	QuadMenu1.cleanSeparators()
)

/*==============================================================================


	ADD CUSTOM ITEMS


================================================================================*/

/**
		BOTTOM RIGHT quad menu - ADD default items
 */
function editQuad1 =
(
	--format "\n"; print ".editQuad1()"
	--QuadMenu1.addMenu("_Modifiers")	index:1

	--QuadMenu1.addSeparator index:2

	--QuadMenu1.addMenu("_Tools")	flat:true

	QuadMenu1.addItem ("_Modifiers") ("modifier_add_editpoly") index:1
	QuadMenu1.addSeparator index:2


)

/**
		RIGHT TOP quad menu - ADD default items
*/
function editQuad2 =
(

)

/**
		TOP LEFT quad menu - ADD default items
*/
function editQuad3 =
(
	--format "\n"; print "VilToolsQuadMenu.editQuad3()"

	/* CONTEXT SPLINE TOOLS 2 */
	SplineToolsMenu1 = Menu_v("Context Spline Tools 1")


	/* CONTEXT EDIT POLY TOOLS 1 */
	EditPolyMenu1 = Menu_v("Context Edit Poly Tools 1")


	/* HARD EDGES MENU */
	HardEdgesMenu = Menu_v("_Epoly-Hard-Edges")
	HardEdgesMenu.addSeparator index:1

	QuadMenu3.addMenu("_Epoly-Hard-Edges")	 flat:false --index:2

)

/**
		BOTTOM LEFT quad menu - ADD default items
*/
function editQuad4 =
(
	/* CONTEXT SPLINE TOOLS 2 */
	SplineToolsMenu2 = Menu_v("Context Spline Tools 2")

	SplineToolsMenu2.moveItem("Fuse Vertices") 1
	SplineToolsMenu2.moveItem("Break Vertices") 2
	SplineToolsMenu2.moveItem("Cycle Vertices") 3
	SplineToolsMenu2.addSeparator index:4


	/* CONTEXT EDIT POLY TOOLS 2 */
	EditPolyMenu = Menu_v("Context Edit Poly Tools 2")


	/* ADD CUSTOM MENUS */
	QuadMenu4.addSeparator()

	QuadMenu4.addMenu("_Context Spline")	index:1 flat:true

	QuadMenu4.addMenu("_Epoly-Vertex")	index:1 flat:true

	QuadMenu4.addMenu("_Epoly-Edit")	index:1 flat:true

	QuadMenu4.addMenu("_Epoly-Edges")	index:1 flat:true


	EpolyEdgesMenu = Menu_v("_Epoly-Edges")
	--EpolyEdgesMenu.addSeparator index:1
)


/*==============================================================================

	RUN EDIT FUNCTIONS

================================================================================*/

----clearListener()
removeItemsQuad1()
removeItemsQuad2()
removeItemsQuad3()
removeItemsQuad4()

editQuad1()
editQuad2()
editQuad3()
editQuad4()

--/* Set options */
--MainQuad.setRightClick()
--
--MainQuad.showAllQuads()
