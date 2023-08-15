/**
  *
  */
function ViewportsLayoutMenu QuadMenu =
(
	QuadMenu.setTitle("L A Y O U T")

	--LayoutsMenu 	= Menu_v("_Viewports-Layout")

	--QuadMenu.addSeparator()


	--QuadMenu.addMenu( LayoutsMenu )	--flat:true --index:1

	--QuadMenu.addMenu(DefaulQuadMenu.menu)	--flat:true --index:1

	for layout in #(#layout_restore_layout_4, #layout_restore_layout_2v, #layout_restore_layout_3vl, #layout_restore_layout_4vl  ) do
		QuadMenu.addItem ("_Viewports-Layout") ( layout as string )

)


