
/**
  *
  */
function LAYERS1menu QuadMenu =
(
	QuadMenu.clearMenu()

	QuadMenu.setTitle("H I D E")

	Layers1Menu	= Menu_v("_Layers-1")

	Layers1Menu.addSeparator index:#( 2 )


	QuadMenu.addMenu(Layers1Menu)	--flat:false --index:1



)
