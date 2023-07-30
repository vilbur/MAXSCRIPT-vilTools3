function MODIFIERSmenu QuadMenu =
(
	QuadMenu.setTitle("Modifiers")

	ModifierStackMenu	= Menu_v("_Modifier Stack")

	--LayersVisibilityMenu.addSeparator index:#( 5, 3 )

	QuadMenu.addMenu(ModifierStackMenu)	--flat:false --index:1

	--DefaulQuadtMenu 	= (QuadMenuv("Title")).Quads[1]

	--QuadMenu.addSeparator()

	--QuadMenu.addMenu("MenuName")	--flat:false --index:1
	--QuadMenu.addMenu(DefaulQuadtMenu.menu)	--flat:false --index:1
	--QuadMenu.addItem ("Category") ("macroscript_nmae") index:1
)
