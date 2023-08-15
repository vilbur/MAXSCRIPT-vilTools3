/**
  *
  */
function ANIMATIONmenu QuadMenu =
(
	QuadMenu.setTitle("A N I M A T I O N")

	--QuadMenu.addMenu("MenuName")	--flat:false --index:1
	--QuadMenu.addMenu(DefaulQuadtMenu.menu)	--flat:false --index:1
	QuadMenu.addItem ("_Animation") ("_options_toggle_keyframe_0_1") index:1
	QuadMenu.addItem ("_Animation") ("_options_trackbar_show") index:2
	--QuadMenu.addSeparator index:2
	QuadMenu.addSeparator index:#(2,3)

)
