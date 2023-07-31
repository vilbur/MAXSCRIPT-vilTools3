
/**
  *
  */
function LAYERSmenu QuadMenu =
(

	QuadMenu.setTitle("LAYERS")

	ManageLayersMenu	= Menu_v("_Layers")
	LayersVisibilityMenu	= Menu_v("_Layers Visibility")

	LayersVisibilityMenu.addSeparator index:#( 2, 5 )


	QuadMenu.addMenu(LayersVisibilityMenu)	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu(ManageLayersMenu)	--flat:false --index:1

)
