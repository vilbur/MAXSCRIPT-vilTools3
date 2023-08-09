/**
  *
  */
function EDIT1menu QuadMenu =
(
	QuadMenu.setTitle(" Edit 1")


	SplineToolsMenu1	= Menu_v("Context Spline Tools 1")

	QuadMenu.addItem ("Modifier Stack") ("Convert To Editable Polygon") group:"Main UI" --index:1

	ToolsOptionsMenu	= Menu_v("_Epoly-Tools-Options") --flat:false
	--ToolsOptionsMenu.addSeparator index:1
	QuadMenu.addMenu(ToolsOptionsMenu)


	ConstraintsMenu	= Menu_v("_Epoly-Constraints") --flat:false
	ConstraintsMenu.addSeparator index:1
	QuadMenu.addMenu(ConstraintsMenu)


	QuadMenu.addMenu(SplineToolsMenu1)	--flat:false --index:1

)