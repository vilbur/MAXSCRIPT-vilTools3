
filein( getFilenamePath(getSourceFileName()) + "/../../Library/MAXSCRIPT-UI-framework/Lib/Menus/QuadMenu/QuadMenu.ms" ) -- ../../Library/MAXSCRIPT-UI-framework/Lib/Menus/QuadMenu/QuadMenu.ms

DeafaultQuad 	= QuadMenu_v("Default Viewport Quad")

QuadMenu1	= DeafaultQuad.Quads[1]
QuadMenu2	= DeafaultQuad.Quads[2]
QuadMenu3	= DeafaultQuad.Quads[3]
QuadMenu4	= DeafaultQuad.Quads[4]


/*------------------------------------------------------------------------------
	EDIT
--------------------------------------------------------------------------------*/

/** BOTTOM RIGHT quad menu - EDIT default items
 */
function editDefaultQuad1 =
(
	--format "\n"; print ".editDefaultQuad1()"
	QuadMenu1.removeItem("Move")
	QuadMenu1.removeItem("Rotate")
	QuadMenu1.removeItem("Scale")
	QuadMenu1.removeItem("Select")
	QuadMenu1.removeItem("Clone")
	QuadMenu1.removeItem("Curve Editor...")
	QuadMenu1.removeItem("Dope Sheet...")
	QuadMenu1.removeItem("Wire Parameters...")
	
	--QuadMenu1.moveItem("Convert To:") 1

)

/** RIGHT TOP quad menu - EDIT default items
*/
function editDefaultQuad2 =
(
	QuadMenu2.removeItem("Viewport Lighting and Shadows")

)

/** TOP LEFT quad menu - EDIT default items

*/
function editDefaultQuad3 =
(
	QuadMenu3.removeItem("Sub-objects")
	QuadMenu3.removeSeparator(1)

)

/** BOTTOM LEFT quad menu - EDIT default items
*/
function editDefaultQuad4 =
(
	--format "\n"; print ".editDefaultQuad4()"
	
)

/*------------------------------------------------------------------------------
	MENUS
--------------------------------------------------------------------------------*/

/** Context spline tools 2
 */
function editMenuContextSplineTools2 =
(
	--format "\n"; print ".contextSplineTools2()"
	SplineToolsMenu2 = Menu_v("Context Spline Tools 2")
	
	SplineToolsMenu2.removeItem("Connect")
	SplineToolsMenu2.removeItem("Weld Vertices")
	
	
	SplineToolsMenu2.moveItem("Break Vertices") 2
	SplineToolsMenu2.moveItem("Fuse Vertices") 3
	SplineToolsMenu2.addSeparator index:4
)

/** Edit menu context spline tools 1
 */
function editMenuContextSplineTools1 =
(
	--format "\n"; print ".editMenuContextSplineTools1()"
	SplineToolsMenu1 = Menu_v("Context Spline Tools 1")
	
	/* Edit Edit/Editable Spline Menu */ 
	EditSplineSubMenu = SplineToolsMenu1.getSubMenu("Edit/Editable Spline Menu")
	
	EditSplineSubMenu.moveItem("Reset Tangents") 5
)

/*------------------------------------------------------------------------------
	ADD ITEMS
--------------------------------------------------------------------------------*/

/** BOTTOM RIGHT quad menu - ADD default items
 */
function addDefaultQuad1 =
(
	--format "\n"; print ".addDefaultQuad1()"
	QuadMenu1.addMenu("_Tools")
)

/** RIGHT TOP quad menu - ADD default items
*/
function addDefaultQuad2 =
(

)

/** TOP LEFT quad menu - ADD default items

*/
function addDefaultQuad3 =
(

)

/** BOTTOM LEFT quad menu - ADD default items
*/
function addDefaultQuad4 =
(
	QuadMenu4.addSeparator()
	QuadMenu4.addMenu("_Context Spline") index:5 flat:true
	
)


/*------------------------------------------------------------------------------
	EDIT MENUS
--------------------------------------------------------------------------------*/
editDefaultQuad1()
editDefaultQuad2()
editDefaultQuad3()
editDefaultQuad4()

addDefaultQuad1()
addDefaultQuad2()
addDefaultQuad3()
addDefaultQuad4()


editMenuContextSplineTools1()
editMenuContextSplineTools2()

/* Set options */ 
DeafaultQuad.setRightClick()
	
DeafaultQuad.showAllQuads()