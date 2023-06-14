filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/miauualignpivottodiection_10.ms" )	-- "./../../../Lib/vendor/miauu/miauualignpivottodiection_10.ms"

/**
 *
 */
macroscript	_align_pivot_to_direction
category:	"_Transform"
buttontext:	"Pivot to direction"
--toolTip:	"Open Transform Randomizer Rollout"
--icon:	"#(path, index)"
(
	macros.run "miauu" "miauuAlignPivotToVector"
)


macroscript UsePivotPointCenter
category:	"Pivot Tools"
buttonText:	"Use Pivot Point Center"
toolTip:	"Use Pivot Point Center"
--icon:	"images:#('/UI_ln/Icons/Maintoolbar_24i.bmp', 32 )"
icon:	"images:#('$maxroot/UI_ln/Icons/Maintoolbar_24i.bmp', undefined, undefined, 31 )"
(
	on execute do
	setCoordCenter #Local
)

--macroscript UseSelectionCenter
--category:	"Pivot Tools"
--buttonText:	"Use Selection Center"
--toolTip:	"Use Selection Center"
--(
--	on execute do
--	setCoordCenter #Selection
--)
--
--macroscript UseTransformCoordinateCenter
--category:	"Pivot Tools"
--buttonText:	"Use Transform Coordinate Center"
--toolTip:	"Use Transform Coordinate Center"
--(
--	on execute do
--	setCoordCenter #System
--)
