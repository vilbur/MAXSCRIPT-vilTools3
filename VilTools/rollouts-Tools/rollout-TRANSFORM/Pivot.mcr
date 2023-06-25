filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/miauualignpivottodiection_10.ms" )	-- "./../../../Lib/vendor/miauu/miauualignpivottodiection_10.ms"


/*------------------------------------------------------------------------------
	CENTER PIVOT
--------------------------------------------------------------------------------*/

/** CENTER TO OBJECT
  */
macroscript _pivot_center_to_objects_in_selection
category:	"_Pivot"
buttonText:	"Center"
toolTip:	"Center pivot to objects in selection"
icon:	"across:4"
(
	on execute do
		for o in selection do CenterPivot  o
)


/** ALIGN TO WORLD
*/
macroscript _pivot_align_to_world_objects_in_selection
category:	"_Pivot"
buttonText:	"Center"
toolTip:	"Align pivot to world"
--icon:	"images:#('/UI_ln/Icons/Maintoolbar_24i.bmp', 32 )"
--icon:	"images:#('$maxroot/UI_ln/Icons/Maintoolbar_24i.bmp', undefined, undefined, 31 )"
(
	on execute do
		for o in selection do WorldAlignPivot o
)

/*------------------------------------------------------------------------------
	DONT AFFECT CHILDREN
--------------------------------------------------------------------------------*/

/** ALIGN TO WORLD
*/
macroscript _transfrom_dont_affect_children
category:	"_Transfrom"
buttonText:	"Not Affect Children"
toolTip:	"Don`t afffect children toggle"
icon:	"control:checkbutton"
--icon:	"images:#('$maxroot/UI_ln/Icons/Maintoolbar_24i.bmp', undefined, undefined, 31 )"
(
	--format "EventFired	= % \n" EventFired

	maxOps.affectChildren  = not EventFired.val

)


/*------------------------------------------------------------------------------
	ALIGN PIVOT TO DIRECTION
--------------------------------------------------------------------------------*/

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




--macroscript UsePivotPointCenter
--category:	"Pivot Tools"
--buttonText:	"Use Pivot Point Center"
--toolTip:	"Use Pivot Point Center"
----icon:	"images:#('/UI_ln/Icons/Maintoolbar_24i.bmp', 32 )"
--icon:	"images:#('$maxroot/UI_ln/Icons/Maintoolbar_24i.bmp', undefined, undefined, 31 )"
--(
--	on execute do
--	setCoordCenter #Local
--)

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
