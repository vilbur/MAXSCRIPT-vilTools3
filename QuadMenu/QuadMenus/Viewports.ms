/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("SWITCH VIEWPORT")

	--Fooo	= Menu_v("")

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
	QuadMenu.setTitle("L A Y O U T")

	for layout in #(#layout_restore_layout_4, #layout_restore_layout_2v, #layout_restore_layout_3vl, #layout_restore_layout_4vl  ) do
		QuadMenu.addItem ("_Viewports-Layout") ( layout as string )
)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("M A N A G E")

	LayoutsMenu 	= Menu_v("_Viewports-Manage")

	LayoutsMenu.addSeparators #( 2 )

	QuadMenu.addMenu( LayoutsMenu )	--flat:true --index:1
)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.setTitle("VISIBILITY BY TYPEv")

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