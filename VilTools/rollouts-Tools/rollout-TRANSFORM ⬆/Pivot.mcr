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

/** CENTER TO OBJECT
  */
macroscript _pivot_bottom_top
category:	"_Pivot"
buttonText:	"⬇ ⬆"
toolTip:	"Set pivot to bottom\top for each object in selection"
--icon:	"across:4"
(
	on execute do
		if( selection.count > 0 ) then
		(
			obj_first = selection[1]

			is_bottom = obj_first.min.z == obj_first.pivot.z

			for o in selection do o.pivot = [o.pivot.x, o.pivot.y, (if is_bottom then o.max.z else o.min.z)  ]

			format "PIVOT SET TO % \n" ( if is_bottom then "TOP" else "BOTTOM" )
		)
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
buttonText:	"Affect Children"
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
