/**
  *
  */
function visiblitySUBOBJECTmenu QuadMenu =
(
	print "visiblitySUBOBJECT()"
	QuadMenu.setTitle("SUBOBJECT")

	HidePolyMenu	= Menu_v("Context Hide/Unhide Tools")
	--format "HideMenuX	= % \n" HideMenuX
	--QuadMenu.addMenu(HideMenuX)	--flat:false --index:1

	--QuadMenu.addMenu(HidePolyMenu)	--flat:false --index:1

	QuadMenu.addItem ("_Test") ("test_macroscript") --group:""  --index:1
)
