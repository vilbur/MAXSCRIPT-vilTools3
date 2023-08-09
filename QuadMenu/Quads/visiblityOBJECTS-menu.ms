


/**
  *
  */
function visiblityOBJECTSmenu QuadMenu =
(

	QuadMenu.setTitle(" O B J E C T S")

	----HideMenuX	= Menu_v("Context Hide/Unhide Tools")
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

	QuadMenu.addItem("Tools")("Hide Unselected")	group:"Main UI" title:"Hide UNSELECTED"
	QuadMenu.addItem("Tools")("Hide Selection")	group:"Main UI" title:"Hide SELECTED"
	QuadMenu.addItem("Tools")("Unhide All")	group:"Main UI" title:"UNHIDE All"

	QuadMenu.addSeparator()
	QuadMenu.addItem("Tools")("Freeze Selection")	group:"Main UI"
	QuadMenu.addItem("Tools")("Unfreeze All")	group:"Main UI"

)
