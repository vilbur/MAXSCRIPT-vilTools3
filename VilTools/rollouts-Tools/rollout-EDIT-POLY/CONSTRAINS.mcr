/** None Constraints
 */
macroscript epoly_tools_Constraints_None
category:	"_Epoly-Constraints"
buttonText:	"None Constraints"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()
	on isChecked	do (modPanel.getCurrentObject()).constrainType == 0

	on execute do (
		macros.run "Ribbon - Modeling" "ConstraintsNone"
	)
)

/** Edge
 */
macroscript epoly_tools_ConstraintsEdge
category:	"_Epoly-Constraints"
buttonText:	"Edge"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()
	on isChecked	do (modPanel.getCurrentObject()).constrainType == 1

	on execute do (
		macros.run "Ribbon - Modeling" "ConstraintsEdge"
	)
)

/** Face
 */
macroscript epoly_tools_ConstraintsFace
category:	"_Epoly-Constraints"
buttonText:	"Face"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()
	on isChecked	do (modPanel.getCurrentObject()).constrainType == 2

	on execute do (
		macros.run "Ribbon - Modeling" "ConstraintsFace"
	)
)

/** Normal
 */
macroscript epoly_tools_ConstraintsNormal
category:	"_Epoly-Constraints"
buttonText:	"Normal"
icon:	"MENU:true"
(
	on isVisible	do return isEpoly()
	on isChecked	do (modPanel.getCurrentObject()).constrainType == 3

	on execute do (
		macros.run "Ribbon - Modeling" "ConstraintsNormal"
	)
)

