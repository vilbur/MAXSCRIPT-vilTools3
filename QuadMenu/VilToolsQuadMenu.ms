
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
	--QuadMenu1.removeSeparator(9)
	
	QuadMenu1.moveItem("Convert To:") 1

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
	SplineToolsMenu = Menu_v("Context Spline Tools 2")
	--format "Spline_ools	Menu= % \n" SplineToolsMenu
	
	SplineToolsMenu.removeItem("Connect")
	
	SplineToolsMenu.moveItem("Weld Vertices") 1
	SplineToolsMenu.moveItem("Break Vertices") 2
	SplineToolsMenu.moveItem("Fuse Vertices") 3
	SplineToolsMenu.addSeparator index:4

	
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


editDefaultQuad1()
editDefaultQuad2()
editDefaultQuad3()
editDefaultQuad4()


editMenuContextSplineTools2()

addDefaultQuad1()
addDefaultQuad2()
addDefaultQuad3()
addDefaultQuad4()



DeafaultQuad.setRightClick()
	
DeafaultQuad.showAllQuads()