/**
  *
  */
function EDIT1menu QuadMenu =
(
	QuadMenu.setTitle(" Edit 1")


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