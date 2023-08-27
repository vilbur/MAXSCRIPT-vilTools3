/**
  *
  */
function TRANSFORMmenu QuadMenu =
(
	QuadMenu.setTitle("T R A N S F O R M")

	--DefaulQuadMenu 	= (QuadMenu_v("Title")).Quads[1]

	--QuadMenu.addSeparator()
	QuadMenu.addMenu("_Transform")	--flat:false --index:1

	--QuadMenu.addMenu("MenuName")	--flat:true --index:1
	--QuadMenu.addMenu(DefaulQuadMenu.menu)	--flat:true --index:1
	--QuadMenu.addItem ("Category") ("macroscript_nmae") index:1

	QuadMenu.addItem ("Snaps") ("Enable Axis Constraints in Snaps") title:"Axis Snap"
	QuadMenu.addItem ("Snaps") ("Snaps To Frozen Objects") title:"Snap To Frozen Objects"

)