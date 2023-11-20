/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("S A V E")

	QuadMenu.addItem "File" "Save File" title:"&Save File" group:"Main UI"

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
	QuadMenu.setTitle(" S C E N E")

	_SceneMenu	= Menu_v("_Scene")
	--DefaulQuadtMenu 	= (QuadMenuv("Title")).Quads[1]

	--_SceneMenu.addSeparator()
	_SceneMenu.addSeparator index:#( 3, 5, 6, 8 )
	----_SceneMenu.addSeparator index:#( 3, 6 )
	----_SceneMenu.addSeparator index:8
	--
	QuadMenu.addMenu(_SceneMenu)	--flat:false --index:1

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
	QuadMenu.setTitle("O P T I O N S")

	QuadMenu.addMenu("_Options")	--flat:false --index:1
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