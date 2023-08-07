/** Execute Epoly Macro With Options Extrude|Chamfer|Bridge|Relax|Weld
  *
  * If Ctrl pressed, then run with options
  */
function executeEpolyMacroWithOptions macro =
(
	--format "\n"; print "executeEpolyOperation.ms.executeEpolyOperation()"

	if keyboard.controlPressed then
		 macro += "Options"

	macros.run "Ribbon - Modeling" macro
)