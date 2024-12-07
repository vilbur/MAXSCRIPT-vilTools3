

/** 3rd Party Script
 *
 *  DOCUMENTATION: https://www.scriptspot.com/3ds-max/scripts/extend-borders
 */
macroscript	edges_extend_border
category:	"_Epoly-Edges"
buttontext:	"Extend Borders"
tooltip:	"Extend Borders"
icon:	"Menu:true"
(
	on isVisible do isEpoly() and isSubObject #( 2, 3 )

	on execute do
	(
		filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/Edit-Poly/Extend_Borders_v1.2.mcr" )	-- "./../../../Lib/vendor/Edit-Poly/Extend_Borders_v1.2.mcr"

		macros.run "RacoonScripts" "ExtendBorders"
	)

)
