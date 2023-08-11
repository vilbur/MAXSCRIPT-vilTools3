
/**
  *
  */
function LAYERSmenu QuadMenu =
(

	QuadMenu.setTitle("L A Y E R S ")

	ManageLayersMenu	= Menu_v("_Layers")
	LayersVisibilityMenu	= Menu_v("_Layers Visibility")

	ManageLayersMenu.addSeparator index:3
	LayersVisibilityMenu.addSeparator index:#( 2, 4, 6 )


	QuadMenu.addMenu(LayersVisibilityMenu)	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu(ManageLayersMenu)	--flat:false --index:1

)
