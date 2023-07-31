/**
  *
  */
function EDIT3menu QuadMenu =
(
	QuadMenu.setTitle(" Edit 3")

	EditPolyMenu3	= Menu_v("Context Edit Poly Tools 3")
	EpolyDialogs	= Menu_v("_Epoly-Dialogs")

	EpolyDialogs.addSeparator index:1
	
	--EditPolyMenu3.addItem ("") ("Bridge") group:"Edit Poly" --index:1


	--EditPolyMenu3.addItem ("Ribbon - Modeling") ("Edge Bridge") group:"Main UI" --index:1
	--EditPolyMenu3.addItem ("") ("Bridge") group:"Editable Poly" --index:1
	EditPolyMenu3.addItem "Ribbon - Modeling" "EdgeBridge"
	EditPolyMenu3.addItem "Ribbon - Modeling" "RelaxSelection"


	--EditPolyMenu3.addItem "_Epoly-Dialogs" "epoly_open_mat_id_dialog"
	--EditPolyMenu3.addItem "_Epoly-Dialogs" "epoly_open_smoothgroups_dialog"


	--QuadMenu.addMenu(EditPolyMenu2)	--flat:false --index:1
	QuadMenu.addMenu(EditPolyMenu3)	--flat:false --index:1
	QuadMenu.addMenu(EpolyDialogs)	--flat:false --index:1

	--QuadMenu.addItem ("PolyTools") ("SwiftLoop") --index:1
)
