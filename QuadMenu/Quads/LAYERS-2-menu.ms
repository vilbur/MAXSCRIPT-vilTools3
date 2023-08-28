
/**
  *
  */
function LAYERS2menu QuadMenu =
(
	QuadMenu.clearMenu()

	QuadMenu.setTitle("H A N D L E")


	Layers2Menu	= Menu_v("_Layers-2")
	Layers2Menu.addSeparator index:#( 2, 4 )

	QuadMenu.addMenu(Layers2Menu)	--flat:false --index:1

)
