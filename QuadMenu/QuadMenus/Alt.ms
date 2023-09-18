/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.clearMenu()

	QuadMenu.setTitle("L A Y E R S 1")

	Layers1Menu	= Menu_v("_Layers-1")

	Layers1Menu.addSeparator index:#( 2 )


	QuadMenu.addMenu(Layers1Menu)	--flat:false --index:1

	--QuadMenu.addMenu("")

	--QuadMenu.addSeparator index:1
	--QuadMenu.addSeparator()
	--QuadMenu.addSeparators #()
)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.clearMenu()

	QuadMenu.setTitle("L A Y E R S 2")


	Layers2Menu	= Menu_v("_Layers-2")
	Layers2Menu.addSeparator index:#( 2, 4 )

	QuadMenu.addMenu(Layers2Menu)	--flat:false --index:1
)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.clearMenu()

	QuadMenu.setTitle("L A Y E R S 3")

	Layers3Menu	= Menu_v("_Layers-3")

	Layers3Menu.addSeparator index:#( 2,4 )

	QuadMenu.addMenu(Layers3Menu)	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Layers-Dialogs")	--flat:false --index:1
)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.clearMenu()

	QuadMenu.setTitle("L A Y E R S 4")


	Layers4Menu	= Menu_v("_Layers-4")

	QuadMenu.addMenu(Layers4Menu)	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Layers-Name")	--flat:false --index:1
)


/** DEFIEN QUAD
  */
QUAD_MENU_INSTALL = QuadMenu_v( "Animation" )
--QUAD_MENU_INSTALL = QuadMenu_v( "_" + getFilenameFile( getSourceFileName() ) )


/** ADD QUAD MENUS
  */
addQuad1( QUAD_MENU_INSTALL.Quads[1] )
addQuad2( QUAD_MENU_INSTALL.Quads[2] )
addQuad3( QUAD_MENU_INSTALL.Quads[3] )
addQuad4( QUAD_MENU_INSTALL.Quads[4] )