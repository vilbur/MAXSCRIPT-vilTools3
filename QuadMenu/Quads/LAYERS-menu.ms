
/**
  *
  */
function LAYERSmenu QuadMenu =
(

	QuadMenu.setTitle("LAYERS")

	LayersMenu	= Menu_v("_Layers")
	LayersVisibilityMenu	= Menu_v("_Layers Visibility")

	LayersVisibilityMenu.addSeparator index:#( 5, 3 )


	QuadMenu.addMenu(LayersVisibilityMenu)	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu(LayersMenu)	--flat:false --index:1

)
