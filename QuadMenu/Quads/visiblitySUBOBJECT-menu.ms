/**
  *
  */
function visiblitySUBOBJECTmenu QuadMenu =
(
	print "visiblitySUBOBJECT()"
	QuadMenu.setTitle("SUBOBJECT")

	HidePolyMenu	= Menu_v("Context Hide/Unhide Tools")

	HidePolyMenu.addItem ("Editable Polygon Object") ("Hide Unselected (Poly)") group:"Main UI"  index:1

	QuadMenu.addMenu(HidePolyMenu)	--flat:false --index:1

	--QuadMenu.addItem ("_Test") ("test_macroscript") --group:""  --index:1
)
