/**
  *
  */
function EDIT1menu QuadMenu =
(
	QuadMenu.setTitle(" Edit 1")

	QuadMenu.addItem ("Modifier Stack") ("Convert To Editable Polygon") group:"Main UI" --index:1

	EditPolyMenu1	= Menu_v("Context Edit Poly Tools 1")

	--QuadMenu.addMenu("MenuName")	--flat:false --index:1

	QuadMenu.addMenu(EditPolyMenu1)	--flat:false --index:1

)
