
/**
  *
  */
function LAYERS3menu QuadMenu =
(
	QuadMenu.setTitle("M A N A G E")


	Layers3Menu	= Menu_v("_Layers-3")
	Layers3Menu.addSeparator index:#( 2,4 )

	QuadMenu.addMenu(Layers3Menu)	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu("_Layers-Dialogs")	--flat:false --index:1

)
