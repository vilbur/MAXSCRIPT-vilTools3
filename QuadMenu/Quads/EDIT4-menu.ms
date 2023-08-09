/**
  *
  */
function EDIT4menu QuadMenu =
(
	QuadMenu.setTitle(" EDIT 4")


	EpolyToolsMainMenu	= Menu_v("_Epoly-Tools-Main") --flat:false
	EpolyToolsMainMenu.addSeparator index:1
	QuadMenu.addMenu(EpolyToolsMainMenu)



	EpolyLoopsMenu	= Menu_v("_Epoly-Loops") --flat:false
	EpolyLoopsMenu.addSeparator index:1
	QuadMenu.addMenu(EpolyLoopsMenu)


	EpolyPolyToolsMenu	= Menu_v("_Epoly-PolyTools") --flat:false
	EpolyPolyToolsMenu.addSeparator index:1
	QuadMenu.addMenu(EpolyPolyToolsMenu)


)
