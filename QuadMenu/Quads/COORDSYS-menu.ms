/**
  *
  */
function COORDSYSmenu QuadMenu =
(
	--print "COORDSYSmenu"

	SnapSubmenu = QuadMenu.getSubMenu(1)

	SnapSubmenu.removeItem #(  )

	SnapSubmenu.moveItem(7)(2) -- move "World" coord sys above "Local"
	SnapSubmenu.moveItem(4)(3) -- move "Parent" coord sys



)
