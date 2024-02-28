/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle(" O B J E C T S 1")

	----format "HideMenuX	= % \n" HideMenuX
	----QuadMenu.addMenu(HideMenuX)	--flat:false --index:1
	--
	----QuadMenu.addMenu("Context Hide/Unhide Tools")	--flat:false --index:1
	----QuadMenu.addItem("Tools")("Hide_Selection")	--flat:false --index:1
	--
	----DefaultViewportQuad 	= QuadMenu_v("Default Viewport Quad")
	----
	----HideSelection = DefaultViewportQuad.Quads[2].getItem ("Hide Selection")
	----
	----format "HideSelection	= % \n" HideSelection


	QuadMenu.addItem("Tools")("Hide Selection")	group:"Main UI" title:"Hide SELECTED"
	QuadMenu.addItem("Tools")("Hide Unselected")	group:"Main UI" title:"Hide UNSELECTED"

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Visibility-Hide")	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Selection-Visibility")	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addItem("Tools")("Freeze Selection")	group:"Main UI"
	QuadMenu.addItem("Tools")("Unfreeze All")	group:"Main UI"

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Selection-Object")	--flat:false --index:1
)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle("S E L E C T I O N " )

	SelFilterMenu	= Menu_v("_Selection-Filter")

	SelFilterMenu.addSeparators #( 4 )

	QuadMenu.addMenu( SelFilterMenu )	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Selection-Copy")	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Selection-Instance")	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Selection-Edit")	--flat:false --index:1
)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle(" O B J E C T S 3")

	ObjectNameMenu	= Menu_v("_Object-Name")


	QuadMenu.addMenu("_Wirecolor")	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu(ObjectNameMenu)	--flat:false --index:1
)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.setTitle("O B J E C T S 4")

	QuadMenu.addItem("Tools")("Unhide All")	group:"Main UI" title:"UNHIDE ALL"

	QuadMenu.addMenu("_Visibility-Unhide")	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Selection-Hierarchy")	--flat:false --index:1
)


/** DEFIEN QUAD
  */
QUAD_MENU_INSTALL = QuadMenu_v( "_" + getFilenameFile( getSourceFileName() ) )


/** ADD QUAD MENUS
  */
addQuad1( QUAD_MENU_INSTALL.Quads[1] )
addQuad2( QUAD_MENU_INSTALL.Quads[2] )
addQuad3( QUAD_MENU_INSTALL.Quads[3] )
addQuad4( QUAD_MENU_INSTALL.Quads[4] )