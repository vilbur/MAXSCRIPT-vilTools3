/**
  *
  */
function EDIT3menu QuadMenu =
(
	QuadMenu.setTitle(" Edit 3")

	EpolyOptionsMenu	= Menu_v("_Epoly-Options") --flat:false
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
