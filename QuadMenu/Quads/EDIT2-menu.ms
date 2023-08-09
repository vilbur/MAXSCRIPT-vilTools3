/**
  *
  */
function EDIT2menu QuadMenu =
(
	QuadMenu.setTitle(" Edit 2")
	SplineToolsMenu2	= Menu_v("Context Spline Tools 2")


	ConnectMenu	= Menu_v("_Epoly-Connect") --flat:false
	ConnectMenu.addSeparator index:#( 2, 3)
	QuadMenu.addMenu(ConnectMenu)


	EpolyEditMenu	= Menu_v("_Epoly-Edit") --flat:false
	EpolyEditMenu.addSeparator index:#(1,3)
	QuadMenu.addMenu(EpolyEditMenu)

	EpolyEdgesMenu	= Menu_v("_Epoly-Edges") --flat:false
	--EpolyEdgesMenu.addSeparator index:1
	QuadMenu.addMenu(EpolyEdgesMenu) title:"Edges"

	QuadMenu.addSeparator()


	EpolyHardEdgesMenu	= Menu_v("_Epoly-Hard-Edges") flat:false
	--EpolyHardEdgesMenu.addSeparator index:1
	QuadMenu.addMenu(EpolyHardEdgesMenu) title:"H A R D - E D G E S"
	--QuadMenu.addMenu(EpolyHardEdgesMenu) title:"𝗛 𝗔 𝗥 𝗗 - 𝗘 𝗗 𝗚 𝗘 𝗦"
	--QuadMenu.addMenu(EpolyHardEdgesMenu) title:"Ｈ Ａ Ｒ Ｄ － Ｅ Ｄ Ｇ Ｅ Ｓ"
	--QuadMenu.addMenu(EpolyHardEdgesMenu) title:""


)
