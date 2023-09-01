function SNAPmenu QuadMenu =
(
	QuadMenu.setTitle(" S N A P")

	SnapQuadMenu 	= QuadMenu_v("Snap") -- Get Quad Menu "Snap"

	SnapMenu	= SnapQuadMenu.getMenu(#BOTTOM_RIGHT)
	--SnapOptionsMenu	= SnapQuadMenu.getMenu(#TOP_LEFT)

	SnapMenu.moveItem ("Pivot") 4


	QuadMenu.addMenu( SnapMenu )	 index:1 --flat:true
	--QuadMenu.addSeparator  index:2
	--QuadMenu.addMenu( SnapOptionsMenu )	 index:3 --flat:true

)
