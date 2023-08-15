/**
  *
  */
function COORDSYSmenu QuadMenu =
(
	--print "COORDSYSmenu"
	QuadMenu.setTitle("C O O R D S Y S")


	--SnapSubmenu = QuadMenu.getSubMenu(1)
	--
	SnapSubmenu = menu_v("Coordinate System")


	SnapSubmenu.removeItem #(  )

	SnapSubmenu.moveItem(7)(2) -- move "World" coord sys above "Local"
	SnapSubmenu.moveItem(4)(3) -- move "Parent" coord sys


	QuadMenu.addMenu(SnapSubmenu)

)
