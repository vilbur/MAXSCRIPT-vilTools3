/**
  *
  */
function ViewportsManageMenu QuadMenu =
(
	QuadMenu.setTitle("M A N A G E")

	LayoutsMenu 	= Menu_v("_Viewports-Manage")

	--QuadMenu.addSeparator()

	QuadMenu.addMenu( LayoutsMenu )	--flat:true --index:1

	--QuadMenu.addMenu(DefaulQuadMenu.menu)	--flat:true --index:1
	--QuadMenu.addItem ("Category") ("macroscript_nmae") index:1

)
