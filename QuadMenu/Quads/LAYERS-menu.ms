
/**
  *
  */
function LAYERSmenu QuadMenu =
(
	QuadMenu.setTitle("L A Y E R S ")

	LayersVisibilityMenu	= Menu_v("_Layers-Visibility")
	LayersVisibilityMenu.addSeparator index:#( 3, 6 )

	ManageLayersMenu	= Menu_v("_Layers-Manage")
	ManageLayersMenu.addSeparator index:#( 3 )

	LayersDialogsMenu	= Menu_v("_Layers-Dialogs")



	QuadMenu.addMenu(LayersVisibilityMenu)	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu(ManageLayersMenu)	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu(LayersDialogsMenu)	--flat:false --index:1

)
