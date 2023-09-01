/**
  *
  */
function TRANSFORMmenu QuadMenu =
(
	QuadMenu.setTitle("T R A N S F O R M")

	SnapOptionsMenu	= (QuadMenu_v("Snap")).getMenu(#TOP_LEFT)

	(SnapOptionsMenu.getItem 1).setTitle ("AXIS Snap")
	(SnapOptionsMenu.getItem 2).setTitle ("Snap To Frozen")
	--QuadMenu.addSeparator  index:2

	--DefaulQuadMenu 	= (QuadMenu_v("Title")).Quads[1]

	QuadMenu.addMenu("_Transform")	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu( SnapOptionsMenu )	 index:3 --flat:true
	--QuadMenu.addMenu("MenuName")	--flat:true --index:1
	--QuadMenu.addMenu(DefaulQuadMenu.menu)	--flat:true --index:1
	--QuadMenu.addItem ("Category") ("macroscript_nmae") index:1

	--QuadMenu.addItem ("Snaps") ("Enable Axis Constraints in Snaps Toggle") 	group:"Main UI" --title:"Axis Snap"
	--QuadMenu.addItem ("Snaps") ("Snaps To Frozen Objects Toggle") 	group:"Main UI" --title:"Snap To Frozen Objects"

)