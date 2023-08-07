/**
  *
  */
function EDIT3menu QuadMenu =
(
	QuadMenu.setTitle(" Edit 3")


	--EpolyToolsMainMenu	= Menu_v("_Epoly-Tools-Main") --flat:false
	--EpolyToolsMainMenu.addSeparator index:1
	--QuadMenu.addMenu(EpolyToolsMainMenu)
	--
	--ToolsOptionsMenu	= Menu_v("_Epoly-Tools-Options") --flat:false
	--ToolsOptionsMenu.addSeparator index:1
	--QuadMenu.addMenu(ToolsOptionsMenu)


	EpolyObjectMenu	= Menu_v("_Epoly-Object") --flat:false
	EpolyObjectMenu.addSeparator index:2
	QuadMenu.addMenu(EpolyObjectMenu)


	--EpolyPolyToolsMenu	= Menu_v("_Epoly-PolyTools") --flat:false
	--EpolyPolyToolsMenu.addSeparator index:1
	--QuadMenu.addMenu(EpolyPolyToolsMenu)
	--
	--
	--EpolyEditMenu	= Menu_v("_Epoly-Edit") --flat:false
	--EpolyEditMenu.addSeparator index:1
	--QuadMenu.addMenu(EpolyEditMenu)
	--
	--
	--EpolyHardEdgesMenu	= Menu_v("_Epoly-Hard-Edges") --flat:false
	--EpolyHardEdgesMenu.addSeparator index:1
	--QuadMenu.addMenu(EpolyHardEdgesMenu)


	EpolyExplodeMenu	= Menu_v("_Epoly-Explode") flat:false
	EpolyExplodeMenu.addSeparator index:1
	QuadMenu.addMenu(EpolyExplodeMenu) title:"Explode"
)
