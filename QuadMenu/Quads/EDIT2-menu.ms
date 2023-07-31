/**
  *
  */
function EDIT2menu QuadMenu =
(
	QuadMenu.setTitle(" Edit 2")
	SplineToolsMenu2	= Menu_v("Context Spline Tools 2")
	EditPolyMenu2	= Menu_v("Context Edit Poly Tools 2")

	EditPolyMenu2.addItem ("PolyTools") ("Flow Connect") group:"Main UI" index:6

	QuadMenu.addMenu(EditPolyMenu2)	--flat:false --index:1
	QuadMenu.addMenu(SplineToolsMenu2)	--flat:false --index:1

	--QuadMenu.addItem ("PolyTools") ("SwiftLoop") --index:1
)
