/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle(" S N A P")

	SnapQuadMenu 	= QuadMenu_v("Snap") -- Get Quad Menu "Snap"

	SnapMenu	= SnapQuadMenu.getMenu(#BOTTOM_RIGHT)
	SnapOptionsMenu	= (QuadMenu_v("Snap")).getMenu(#TOP_LEFT)


	(SnapOptionsMenu.getItem 1).setTitle ("AXIS Snap")
	(SnapOptionsMenu.getItem 2).setTitle ("Snap To Frozen")
	SnapOptionsMenu.removeItem 4

	/* REORDER ITEMS */
	SnapMenu.moveItem ("Pivot") 4


	/* ADD MENUS */
	QuadMenu.addMenu( SnapOptionsMenu )	-- index:3 --flat:true

	QuadMenu.addSeparator()

	QuadMenu.addMenu( SnapMenu )	 --index:1 --flat:true
)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle("C O O R D S Y S")


	--SnapSubmenu = QuadMenu.getSubMenu(1)
	--
	SnapSubmenu = menu_v("Coordinate System")


	SnapSubmenu.removeItem #(  )

	SnapSubmenu.moveItem(7)(2) -- move "World" coord sys above "Local"
	SnapSubmenu.moveItem(4)(3) -- move "Parent" coord sys


	QuadMenu.addMenu(SnapSubmenu)

)

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("P I V O T")

	PivotMenu = menu_v("_Pivot")

	PivotMenu.addSeparators #(3)


	QuadMenu.addMenu(PivotMenu)	--flat:true --index:1

)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(
	QuadMenu.setTitle("T R A N S F O R M")

	TransformMenu = menu_v("_Transform")

	TransformMenu.addSeparators #(3)

	QuadMenu.addMenu(TransformMenu)	--flat:false --index:1


	--QuadMenu.addMenu("MenuName")	--flat:true --index:1
	--QuadMenu.addMenu(DefaulQuadMenu.menu)	--flat:true --index:1
	--QuadMenu.addItem ("Category") ("macroscript_nmae") index:1

	--QuadMenu.addItem ("Snaps") ("Enable Axis Constraints in Snaps Toggle") 	group:"Main UI" --title:"Axis Snap"
	--QuadMenu.addItem ("Snaps") ("Snaps To Frozen Objects Toggle") 	group:"Main UI" --title:"Snap To Frozen Objects"
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