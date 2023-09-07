


/**
  *
  */
function OBJECT1menu QuadMenu =
(

	QuadMenu.setTitle(" O B J E C T S 1")

	ObjectMenu	= Menu_v("_Selection-Object")
	ObjectsVisibilityMenu	= Menu_v("_Selection-Visibility")

	----format "HideMenuX	= % \n" HideMenuX
	----QuadMenu.addMenu(HideMenuX)	--flat:false --index:1
	--
	----QuadMenu.addMenu("Context Hide/Unhide Tools")	--flat:false --index:1
	----QuadMenu.addItem("Tools")("Hide_Selection")	--flat:false --index:1
	--
	----DefaultViewportQuad 	= QuadMenu_v("Default Viewport Quad")
	----
	----HideSelection = DefaultViewportQuad.Quads[2].getItem ("Hide Selection")
	----
	----format "HideSelection	= % \n" HideSelection
	QuadMenu.addMenu("_Visibility-Hide")	--flat:false --index:1


	-- QuadMenu.addItem("Tools")("Hide Selection")	group:"Main UI" title:"Hide SELECTED"
	QuadMenu.addItem("Tools")("Hide Unselected")	group:"Main UI" title:"Hide UNSELECTED"

	QuadMenu.addSeparator()

	QuadMenu.addMenu(ObjectsVisibilityMenu)	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addItem("Tools")("Freeze Selection")	group:"Main UI"
	QuadMenu.addItem("Tools")("Unfreeze All")	group:"Main UI"

	QuadMenu.addSeparator()

	QuadMenu.addMenu(ObjectMenu)	--flat:false --index:1
)
