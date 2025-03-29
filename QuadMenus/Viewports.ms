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
	QuadMenu.setTitle("L A Y O U T   L O A D" )
	
	LayoutsMenu 	= QuadMenu.addMenu("_Viewports-Layout")
	--LayoutsMenu 	= Menu_v("_Viewports-Layout")

	LayoutsMenu.addSeparator()
	
	--LayoutsPresetMenu 	= QuadMenu.addMenu("_Viewports-Layout-Preset")
	
	for layout in #(#layout_restore_layout_4, #layout_restore_layout_2v, #layout_restore_layout_2h, #layout_restore_layout_3vl, #layout_restore_layout_3ht, #layout_restore_layout_4vl  ) do
		LayoutsMenu.addItem ("_Viewports-Layout-Preset") ( layout as string )
		
	--LayoutsMenu.moveItem ("QUICK Layout") 1

	--LayoutsMenu.addSeparator index:2
)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("M A N A G E")

	LayoutsMenu 	= Menu_v("_Viewports-Manage")

	LayoutsMenu.addSeparators #( 3 )

	QuadMenu.addMenu( LayoutsMenu )	--flat:true --index:1
)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.setTitle("VISIBILITY BY TYPE")

)



/** DEFIEN QUAD
  */
QuadMenuNew = QuadMenu_v( getFilenameFile( getSourceFileName() ) )


/** ADD QUAD MENUS
  */
addQuad1( QuadMenuNew.Quads[1] )
addQuad2( QuadMenuNew.Quads[2] )
addQuad3( QuadMenuNew.Quads[3] )
addQuad4( QuadMenuNew.Quads[4] )