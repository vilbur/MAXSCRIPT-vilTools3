/**
  *
  */
function MODIFIERS2menu QuadMenu =
(
	QuadMenu.setTitle("MODIFIERS 2")

	ModifiersMenu = Menu_v("_Modifiers-2") flat:true

	ModifiersMenu.addSeparator index:#( 3, 5 )

	QuadMenu.addMenu(ModifiersMenu)

)
