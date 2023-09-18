/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("M O D - S T A C K  1")

	QuadMenu.addMenu("_Modifiers-Manage")	--flat:false --index:1


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
	QuadMenu.setTitle("M O D - S T A C K  2")

	NameMenu 	= Menu_v("_Modifiers-Name")

	NameMenu.addSeparators #( 4 )

	QuadMenu.addMenu(NameMenu)	--flat:false --index:1

)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("M O D - S T A C K  3")

	QuadMenu.addMenu("_Modifiers-Remote-Stack")	--flat:false --index:1

)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.setTitle("M O D - S T A C K  4")

	QuadMenu.addMenu("_Modifiers-Gizmo")
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