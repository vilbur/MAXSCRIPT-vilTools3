
filein( getFilenamePath(getSourceFileName()) + "/../../MAXSCRIPT-UI-framework/Lib/Menus/QuadMenu/QuadMenu.ms" ) -- ../../MAXSCRIPT-UI-framework/Lib/Menus/QuadMenu/QuadMenu.ms

DeafaultQuad 	= QuadMenu_v("Default Viewport Quad")

QuadMenu1	= DeafaultQuad.Quads[1]
QuadMenu2	= DeafaultQuad.Quads[2]
QuadMenu3	= DeafaultQuad.Quads[3]
QuadMenu4	= DeafaultQuad.Quads[4]

/*------------------------------------------------------------------------------
	CLEAN DEFAULT ITEMS
--------------------------------------------------------------------------------*/

/** BOTTOM RIGHT quad menu - EDIT default items
 */
function removeItemsQuad1 =
(
	----format "\n"; print ".removeItemsQuad1()"
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

/** RIGHT TOP quad menu - EDIT default items
*/
function removeItemsQuad2 =
(
	QuadMenu2.removeItem("Viewport Lighting and Shadows")
	QuadMenu2.removeItem("Show Motion Paths")

	QuadMenu2.moveItem("Manage State Sets...") -1
	QuadMenu2.moveItem("State Sets") -1

)

/** TOP LEFT quad menu - EDIT default items

*/
function removeItemsQuad3 =
(
	QuadMenu3.removeItem("Sub-objects")
	QuadMenu3.removeSeparator(1)

	QuadMenu1.cleanSeparators()
)

/** BOTTOM LEFT quad menu - EDIT default items
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

	QuadMenu1.cleanSeparators()
)

/*------------------------------------------------------------------------------
	ADD CUSTOM ITEMS
--------------------------------------------------------------------------------*/

/** BOTTOM RIGHT quad menu - ADD default items
 */
function editQuad1 =
(
	--format "\n"; print ".editQuad1()"
	QuadMenu1.addMenu("_Modifiers")	index:1

	QuadMenu1.addSeparator index:2

	QuadMenu1.addMenu("_Tools")	flat:true

)

/** RIGHT TOP quad menu - ADD default items
*/
function editQuad2 =
(

)

/** TOP LEFT quad menu - ADD default items

*/
function editQuad3 =
(
	--format "\n"; print ".editMenuContextSplineTools1()"
	SplineToolsMenu1 = Menu_v("Context Spline Tools 1")

	/* Edit Edit/Editable Spline Menu */
	--EditSplineSubMenu = SplineToolsMenu1.getSubMenu("Edit/Editable Spline Menu")

	--EditSplineSubMenu.moveItem("Reset Tangents") 5
	--EditSplineSubMenu.removeItem("Reset Tangents")
)

/** BOTTOM LEFT quad menu - ADD default items
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
	EditPolyMenu.addItem ("_Epoly-Edit") ("epoly_remove") --index:1

	/* ADD CUSTOM MENUS */
	QuadMenu4.addSeparator()

	QuadMenu4.addMenu("_Context Spline")	index:1 flat:true

	QuadMenu4.addMenu("_Epoly-Vertex")	index:1 flat:true

	QuadMenu4.addMenu("_Epoly-Edges")	index:3 flat:true

	EpolyEdgesMenu = Menu_v("_Epoly-Edges")
	EpolyEdgesMenu.addSeparator index:1

)

/*------------------------------------------------------------------------------
	EDIT MENUS
--------------------------------------------------------------------------------*/

--clearListener()
removeItemsQuad1()
removeItemsQuad2()
removeItemsQuad3()
removeItemsQuad4()

editQuad1()
editQuad2()
editQuad3()
editQuad4()

/* Set options */
DeafaultQuad.setRightClick()

DeafaultQuad.showAllQuads()