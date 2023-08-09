function MODIFIERSSTACKmenu QuadMenu =
(
	QuadMenu.setTitle("S T A C K ")

	ModifierStackMenu	= Menu_v("_Modifier Stack")

	ModifierStackMenu.addSeparator index:#( 2, 5 )

	QuadMenu.addMenu(ModifierStackMenu)	--flat:false --index:1
)
