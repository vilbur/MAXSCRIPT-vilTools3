/**
  *
  */
function MODIFIERS2menu QuadMenu =
(
	QuadMenu.setTitle("M O D I F I E R S 2")

	ModifiersMenu = Menu_v("_Modifiers-2") flat:true

	ModifiersMenu.addSeparator index:#( 3, 6 )

	QuadMenu.addMenu(ModifiersMenu)

)
