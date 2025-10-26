/** N O N E
 */
macroscript epoly_tools_Constraints_None
icon:	"control:checkbutton|MENU:true|ini:false|id:set_constrain_0|MENU:false"
buttonText:	"N O N E"
category:	"_Epoly-Constraints"
(
	on isVisible	do return isEpoly() and isSubObject #(1,2,4)
	on isChecked	do (modPanel.getCurrentObject()).constrainType == 0

	on execute do
	(
		toggleConstrainType 0 EventFired
	)
)

/** E D G E
 */
macroscript epoly_tools_Constraints_Edge
icon:	"control:checkbutton|MENU:true|ini:false|id:set_constrain_1"
buttonText:	"E D G E"
category:	"_Epoly-Constraints"
(
	on isVisible	do return isEpoly() and isSubObject #(1,2,4)
	on isChecked	do (modPanel.getCurrentObject()).constrainType == 1

	on execute do
	(
		toggleConstrainType 1 EventFired
	)
)

/** F A C E
 */
macroscript epoly_tools_Constraints_Face
icon:	"control:checkbutton|MENU:true|ini:false|id:set_constrain_2"
buttonText:	"F A C E"
category:	"_Epoly-Constraints"
(
	on isVisible	do return isEpoly() and isSubObject #(1,2,4)
	on isChecked	do (modPanel.getCurrentObject()).constrainType == 2

	on execute do
	(
		toggleConstrainType 2 EventFired
	)
)

/** N O R M A L
 */
macroscript epoly_tools_Constraints_Normal
icon:	"control:checkbutton|MENU:true|ini:false|id:set_constrain_3"
buttonText:	"N O R M A L"
category:	"_Epoly-Constraints"
(
	on isVisible	do return isEpoly() and isSubObject #(1,2,4)
	on isChecked	do (modPanel.getCurrentObject()).constrainType == 3

	on execute do
	(
		toggleConstrainType 3 EventFired
	)
)

