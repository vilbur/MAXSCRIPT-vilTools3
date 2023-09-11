/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle(" SCENE")

	_SceneMenu	= Menu_v("_Scene")
	--DefaulQuadtMenu 	= (QuadMenuv("Title")).Quads[1]

	--_SceneMenu.addSeparator()
	_SceneMenu.addSeparator index:#( 3, 5, 6, 8 )
	----_SceneMenu.addSeparator index:#( 3, 6 )
	----_SceneMenu.addSeparator index:8
	--
	QuadMenu.addMenu(_SceneMenu)	--flat:false --index:1

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
	QuadMenu.setTitle("QUAD 2")

)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("QUAD 3")

)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.setTitle("QUAD 4")

)



/** DEFIEN QUAD
  */
QUAD_MENU_INSTALL = QuadMenu_v( getFilenameFile( getSourceFileName() ) )


/** ADD QUAD MENUS
  */
addQuad1( QUAD_MENU_INSTALL.Quads[1] )
addQuad2( QUAD_MENU_INSTALL.Quads[2] )
addQuad3( QUAD_MENU_INSTALL.Quads[3] )
addQuad4( QUAD_MENU_INSTALL.Quads[4] )