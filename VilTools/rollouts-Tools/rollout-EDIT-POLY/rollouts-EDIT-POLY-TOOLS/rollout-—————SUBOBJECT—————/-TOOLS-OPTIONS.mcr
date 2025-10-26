/** Chamfer
 */
macroscript epoly_tools_Chamfer
toolTip:	"Ctrl: Open Options"
icon:	"MENU:true"
buttonText:	"Chamfer"
category:	"_Epoly-Tools-Options"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 1, 2, 3, 4 )

	on execute do
	(
		executeEpolyMacroWithOptions ("EPoly_Chamfer")
	)
)

/** Extrude
 */
macroscript epoly_tools_Extrude
toolTip:	"Ctrl: Open Options"
icon:	"MENU:true"
buttonText:	"Extrude"
category:	"_Epoly-Tools-Options"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 1, 2, 3, 4 )

	on execute do
	(
		executeEpolyMacroWithOptions ("EPoly_Extrude")
	)
)

/** Bevel
 */
macroscript epoly_tools_Bevel
toolTip:	"Ctrl: Open Options"
icon:	"MENU:true"
buttonText:	"Bevel"
category:	"_Epoly-Tools-Options"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 4 )

	on execute do
	(
		executeEpolyMacroWithOptions ("EPoly_Bevel")
	)
)

/** Bridge
 */
macroscript epoly_tools_Bridge
toolTip:	"Ctrl: Open Options"
icon:	"MENU:true"
buttonText:	"Bridge"
category:	"_Epoly-Tools-Options"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 1, 2, 3 )

	on execute do
	(
		executeEpolyMacroWithOptions ("EdgeBridge")
	)
)

/** Relax
 */
macroscript epoly_tools_Relax
toolTip:	"Ctrl: Open Options"
icon:	"MENU:true"
buttonText:	"Relax"
category:	"_Epoly-Tools-Options"
(
	on isVisible	do return isEpoly()

	on execute do
	(
		executeEpolyMacroWithOptions ("RelaxSelection")
	)
)

/** Weld
 */
macroscript epoly_tools_Weld
toolTip:	"Ctrl: Open Options"
icon:	"MENU:true|id:#epoly_weld"
buttonText:	"Weld"
category:	"_Epoly-Tools-Options"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 1, 2 )

	on execute do
	(
		executeEpolyMacroWithOptions ("EPoly_Weld")
	)
)

