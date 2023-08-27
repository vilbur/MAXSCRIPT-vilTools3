/** Edit Spline
 */
macroscript epoly_tools_Edit_Spline
category:	"_Modifiers-Spline"
buttonText:	"Edit Spline"
icon:	"MENU:true"
(
	on isVisible	do mcrUtils.ValidMod Edit_Spline

	on execute do (
		macros.run "Modifiers" "Edit_Spline"
	)
)

/** Normalize Spline
 */
macroscript epoly_tools_Normalize_Spline
category:	"_Modifiers-Spline"
buttonText:	"Normalize Spline"
icon:	"MENU:true"
(
	on isVisible	do mcrUtils.ValidMod Normalize_Spline

	on execute do (
		macros.run "Modifiers" "Normalize_Spline"
	)
)

/** Lathe
 */
macroscript epoly_tools_Lathe
category:	"_Modifiers-Spline"
buttonText:	"Lathe"
icon:	"MENU:true"
(
	on isVisible	do mcrUtils.ValidMod Lathe

	on execute do (
		macros.run "Modifiers" "Lathe"
	)
)

/** Extrude
 */
macroscript epoly_tools_Extrude
category:	"_Modifiers-Spline"
buttonText:	"Extrude"
icon:	"MENU:true"
(
	on isVisible	do mcrUtils.ValidMod Extrude

	on execute do (
		macros.run "Modifiers" "Extrude"
	)
)

/** Bevel
 */
macroscript epoly_tools_Bevel
category:	"_Modifiers-Spline"
buttonText:	"Bevel"
icon:	"MENU:true"
(
	on isVisible	do mcrUtils.ValidMod Bevel

	on execute do (
		macros.run "Modifiers" "Bevel"
	)
)

