/**
  *
  */
function EDIT4menu QuadMenu =
(
	QuadMenu.setTitle(" EDIT 4")


	EpolyToolsMainMenu	= Menu_v("_Epoly-Tools-Main") --flat:false
	EpolyToolsMainMenu.addSeparator index: #( 2,  6 )
	QuadMenu.addMenu(EpolyToolsMainMenu)


	EpolyPolyToolsMenu	= Menu_v("_Epoly-PolyTools") --flat:false  -- "./../../VilTools/rollouts-Tools/rollout-EDIT-POLY/-TOOLS-POLYTOOLS.mcr.ini"
	EpolyPolyToolsMenu.addSeparator index:1
	QuadMenu.addMenu(EpolyPolyToolsMenu)


	EpolyLoopsMenu	= Menu_v("_Epoly-Loops") --flat:false
	EpolyLoopsMenu.addSeparator index: #( 1, 2 )
	QuadMenu.addMenu(EpolyLoopsMenu)



)
