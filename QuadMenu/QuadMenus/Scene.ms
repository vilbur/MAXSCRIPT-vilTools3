/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("S A V E")

	QuadMenu.addItem "File" "Save File" title:"&Save File" group:"Main UI"

	QuadMenu.addSeparator()

	_SceneMenu = QuadMenu.addMenu("_Scene")	separators:#( 3, 5 ) --flat:false --index:1

	--format "_SceneMenu: %\n" _SceneMenu
	--QuadMenu.addSeparator index:1
	--QuadMenu.addSeparator()
	--QuadMenu.addSeparators #()
)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle(" X-R E F")

	QuadMenu.addMenu("_Scene-Xref")	separators:#( 3 ) --flat:false --index:1
)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("QUAD 3")


	QuadMenu.addMenu("_Scene-Reset")	--flat:false --index:1

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