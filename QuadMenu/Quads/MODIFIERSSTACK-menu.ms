function MODIFIERSSTACKmenu QuadMenu =
(
	QuadMenu.setTitle("M O D - S T A C K ")

	RemoteStackMenu	= Menu_v("_Modifiers-Remote")
	ModifierStackMenu	= Menu_v("_Modifier-Stack")

	ModifierStackMenu.addSeparator index:#( 1, 2 )

	QuadMenu.addMenu(RemoteStackMenu)	--flat:false --index:1
	QuadMenu.addMenu(ModifierStackMenu)	--flat:false --index:1
)
