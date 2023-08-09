/**
  *
  */
function MODIFIERS1menu QuadMenu =
(
	QuadMenu.setTitle("MODIFIERS 1")

	ModifiersMenu = Menu_v("_Modifiers-1") flat:true
	SplineModsMenu = Menu_v("_Modifiers-Spline") flat:true


	ModifiersMenu.addSeparator index: #( 5 )

	QuadMenu.addMenu(SplineModsMenu)
	QuadMenu.addSeparator index: #( 2 )
	QuadMenu.addMenu(ModifiersMenu)

)
