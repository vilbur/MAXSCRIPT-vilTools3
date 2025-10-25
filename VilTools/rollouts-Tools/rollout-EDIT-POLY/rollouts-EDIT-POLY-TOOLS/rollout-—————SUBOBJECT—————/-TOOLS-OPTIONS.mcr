/** Chamfer
 */
macroscript epoly_tools_Chamfer
category:	"_Epoly-Tools-Options"
toolTip:	"Ctrl: Open Options"
icon:	"MENU:true"
buttonText:	"Chamfer"
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
category:	"_Epoly-Tools-Options"
toolTip:	"Ctrl: Open Options"
icon:	"MENU:true"
buttonText:	"Extrude"
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
category:	"_Epoly-Tools-Options"
toolTip:	"Ctrl: Open Options"
icon:	"MENU:true"
buttonText:	"Bevel"
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
category:	"_Epoly-Tools-Options"
toolTip:	"Ctrl: Open Options"
icon:	"MENU:true"
buttonText:	"Bridge"
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
category:	"_Epoly-Tools-Options"
toolTip:	"Ctrl: Open Options"
icon:	"MENU:true"
buttonText:	"Relax"
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
category:	"_Epoly-Tools-Options"
toolTip:	"Ctrl: Open Options"
icon:	"MENU:true|id:#epoly_weld"
buttonText:	"Weld"
(
	on isVisible	do return isEpoly()	and	isSubObject #( 1, 2 )

	on execute do
	(
		executeEpolyMacroWithOptions ("EPoly_Weld")
	)
)

