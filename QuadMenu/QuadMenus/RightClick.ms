/*------------------------------------------------------------------------------
	QUAD 1
--------------------------------------------------------------------------------*/
function addQuad1 QuadMenu =
(
	QuadMenu.setTitle("Edit 1")

	--Fooo	= Menu_v("")

	--QuadMenu.addMenu("")

	--QuadMenu.addSeparator index:1
	--QuadMenu.addSeparator()
	--QuadMenu.addSeparators #()
	ConvertToMenu	= Menu_v("_Object-ConvertTo")
	--ConvertToMenu.addSeparator index:( ConvertToMenu.numItems() + 1 )
	--ConvertToMenu.addSeparator index:( 2 )

	SplineToolsMenu1	= Menu_v("Context Spline Tools 1")
	SplineToolsMenu1.addSeparator index:1
	SplineToolsMenu1.removeItem("Bind")
	SplineToolsMenu1.removeItem("Unbind")
	SplineToolsMenu1.clearSeparators()

	--ToolsOptionsMenu	= Menu_v("_Epoly-Tools-Options") --flat:false
	ConstraintsMenu	= Menu_v("_Epoly-Constraints") --flat:false
	ConstraintsMenu.addSeparator index:1



	QuadMenu.addItem ("Modifier Stack") ("Convert To Editable Polygon") group:"Main UI" --index:1

	QuadMenu.addMenu(ConvertToMenu)
	--QuadMenu.addSeparator()

	QuadMenu.addMenu(ConstraintsMenu)

	QuadMenu.addMenu(SplineToolsMenu1)	--flat:false --index:1

	QuadMenu.addMenu("_Epoly-Tools-Options")


	QuadMenu.addMenu(ConstraintsMenu)
)

/*------------------------------------------------------------------------------
	QUAD 2
--------------------------------------------------------------------------------*/
function addQuad2 QuadMenu =
(
	QuadMenu.setTitle("Edit 2")
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

/*------------------------------------------------------------------------------
	QUAD 3
--------------------------------------------------------------------------------*/
function addQuad3 QuadMenu =
(
	QuadMenu.setTitle("Edit 3")

	EpolyOptionsMenu = Menu_v("_Epoly-Options") --flat:false
	EpolyOptionsMenu.addSeparator index:#(3)
	QuadMenu.addMenu(EpolyOptionsMenu)



	EpolyObjectMenu	= Menu_v("_Epoly-Object") --flat:false
	EpolyObjectMenu.addSeparator index:#( 3 )
	QuadMenu.addMenu(EpolyObjectMenu)

	QuadMenu.addSeparator()

	EpolyExplodeMenu	= Menu_v("_Epoly-Explode") flat:false
	--EpolyExplodeMenu.addSeparator index:1
	QuadMenu.addMenu(EpolyExplodeMenu) title:"E X P L O D E"
)

/*------------------------------------------------------------------------------
	QUAD 4
--------------------------------------------------------------------------------*/
function addQuad4 QuadMenu =
(

	QuadMenu.setTitle("EDIT 4")

	EpolyToolsMainMenu = Menu_v("_Epoly-Tools-Main") --flat:false
	EpolyToolsMainMenu.addSeparator index: #( 2,  6 )
	QuadMenu.addMenu(EpolyToolsMainMenu)


	EpolyPolyToolsMenu	= Menu_v("_Epoly-PolyTools") --flat:false  -- "./../../VilTools/rollouts-Tools/rollout-EDIT-POLY/-TOOLS-POLYTOOLS.mcr.ini"
	EpolyPolyToolsMenu.addSeparator index:1
	QuadMenu.addMenu(EpolyPolyToolsMenu)


	EpolyLoopsMenu	= Menu_v("_Epoly-Loops") --flat:false
	EpolyLoopsMenu.addSeparator index: #( 1, 2 )
	QuadMenu.addMenu(EpolyLoopsMenu)

)


/** DEFIEN QUAD
  */
QUAD_MENU_INSTALL = QuadMenu_v( "_" + getFilenameFile( getSourceFileName() ) )


/** ADD QUAD MENUS
  */
addQuad1( QUAD_MENU_INSTALL.Quads[1] )
addQuad2( QUAD_MENU_INSTALL.Quads[2] )
addQuad3( QUAD_MENU_INSTALL.Quads[3] )
addQuad4( QUAD_MENU_INSTALL.Quads[4] )
