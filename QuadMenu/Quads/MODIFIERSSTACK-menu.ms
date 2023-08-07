function MODIFIERSSTACKmenu QuadMenu =
(
	QuadMenu.setTitle("MODIFIERS STACK")

	ModifierStackMenu	= Menu_v("_Modifier Stack")

	ModifierStackMenu.addSeparator index:#( 2, 5 )

	QuadMenu.addMenu(ModifierStackMenu)	--flat:false --index:1
)
