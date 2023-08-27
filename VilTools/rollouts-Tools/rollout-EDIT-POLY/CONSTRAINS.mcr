/** N O N E
 */
macroscript epoly_tools_Constraints_None
category:	"_Epoly-Constraints"
buttonText:	"N O N E"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()
	on isChecked	do (modPanel.getCurrentObject()).constrainType == 0
	on isEnabled	do (modPanel.getCurrentObject()).constrainType != 0

	on execute do (
		macros.run "Ribbon - Modeling" "ConstraintsNone"
	)
)

/** E D G E
 */
macroscript epoly_tools_Constraints_Edge
category:	"_Epoly-Constraints"
buttonText:	"E D G E"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()
	on isChecked	do (modPanel.getCurrentObject()).constrainType == 1
	on isEnabled	do (modPanel.getCurrentObject()).constrainType != 1

	on execute do (
		macros.run "Ribbon - Modeling" "ConstraintsEdge"
	)
)

/** F A C E
 */
macroscript epoly_tools_Constraints_Face
category:	"_Epoly-Constraints"
buttonText:	"F A C E"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()
	on isChecked	do (modPanel.getCurrentObject()).constrainType == 2
	on isEnabled	do (modPanel.getCurrentObject()).constrainType != 2

	on execute do (
		macros.run "Ribbon - Modeling" "ConstraintsFace"
	)
)

/** N O R M A L
 */
macroscript epoly_tools_Constraints_Normal
category:	"_Epoly-Constraints"
buttonText:	"N O R M A L"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()
	on isChecked	do (modPanel.getCurrentObject()).constrainType == 3
	on isEnabled	do (modPanel.getCurrentObject()).constrainType != 3

	on execute do (
		macros.run "Ribbon - Modeling" "ConstraintsNormal"
	)
)

