/** N O N E
 */
macroscript epoly_tools_Constraints_None
category:	"_Epoly-Constraints"
buttonText:	"N O N E"
icon:	"control:checkbutton|MENU:true|ini:false|id:set_constrain_0|MENU:false"
(
	on isChecked	do (modPanel.getCurrentObject()).constrainType == 0
	on isVisible	do return isEpoly() and isSubObject #(1,2,4)

	on execute do
	(
		toggleConstrainType 0 EventFired
	)
)

/** E D G E
 */
macroscript epoly_tools_Constraints_Edge
category:	"_Epoly-Constraints"
buttonText:	"E D G E"
icon:	"control:checkbutton|MENU:true|ini:false|id:set_constrain_1"
(
	on isChecked	do (modPanel.getCurrentObject()).constrainType == 1
	on isVisible	do return isEpoly() and isSubObject #(1,2,4)

	on execute do
	(
		toggleConstrainType 1 EventFired
	)
)

/** F A C E
 */
macroscript epoly_tools_Constraints_Face
category:	"_Epoly-Constraints"
buttonText:	"F A C E"
icon:	"control:checkbutton|MENU:true|ini:false|id:set_constrain_2"
(
	on isChecked	do (modPanel.getCurrentObject()).constrainType == 2
	on isVisible	do return isEpoly() and isSubObject #(1,2,4)

	on execute do
	(
		toggleConstrainType 2 EventFired
	)
)

/** N O R M A L
 */
macroscript epoly_tools_Constraints_Normal
category:	"_Epoly-Constraints"
buttonText:	"N O R M A L"
icon:	"control:checkbutton|MENU:true|ini:false|id:set_constrain_3"
(
	on isChecked	do (modPanel.getCurrentObject()).constrainType == 3
	on isVisible	do return isEpoly() and isSubObject #(1,2,4)

	on execute do
	(
		toggleConstrainType 3 EventFired
	)
)

