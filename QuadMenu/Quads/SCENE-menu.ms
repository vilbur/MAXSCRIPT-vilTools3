/**
  *
  */
function sceneMenu QuadMenu =
(
	print "sceneMenu()"

	QuadMenu.setTitle(" SCENE")

	_SceneMenu	= Menu_v("_Scene")
	--DefaulQuadtMenu 	= (QuadMenuv("Title")).Quads[1]

	--_SceneMenu.addSeparator()
	_SceneMenu.addSeparator index:#( 3, 5, 6)
	----_SceneMenu.addSeparator index:#( 3, 6 )
	----_SceneMenu.addSeparator index:8
	--
	QuadMenu.addMenu(_SceneMenu)	--flat:false --index:1


	--QuadMenu.addMenu("MenuName")	--flat:false --index:1
	--QuadMenu.addMenu(DefaulQuadtMenu.menu)	--flat:false --index:1
	--QuadMenu.addItem ("Category") ("macroscript_nmae") index:1
)
