


/**
  *
  */
function OBJECT3menu QuadMenu =
(
	QuadMenu.setTitle(" O B J E C T S 3")

	ObjectNameMenu	= Menu_v("_Object-Name")


	QuadMenu.addMenu("_Wirecolor")	--flat:false --index:1

	QuadMenu.addSeparator()

	QuadMenu.addMenu(ObjectNameMenu)	--flat:false --index:1
)
