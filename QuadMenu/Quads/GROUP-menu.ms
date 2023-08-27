/**
  *
  */
function GROUPmenu QuadMenu =
(
	--format "\n"; print "GROUPmenu()"

	QuadMenu.setTitle("G R O U P")
	QuadMenu.clearMenu()

	GroupMenu	= Menu_v("_Group")
	GroupMenu.addSeparator index:#( 3, 5, 7 )


	QuadMenu.addMenu(GroupMenu)	--flat:true --index:1

)