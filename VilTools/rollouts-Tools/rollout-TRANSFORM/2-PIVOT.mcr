
/** USE PIVOT CENTER
*/
macroscript _pivot_selection_center_toggle
category:	"_Pivot"
buttonText:	"Use Selection\Object"
toolTip:	"Toggle object and selection pivot"
icon:	"MENU:true|title:buttonText|across:3"
(
	on isChecked do GetCoordCenter() != #system

	on execute do
		SetCoordCenter ( if GetCoordCenter() == #local then #selection else #local  )
)


/** USE PIVOT CENTER TRANSFROM
*/
macroscript _pivot_use_transform_center
category:	"_Pivot"
buttonText:	"Use Transfrom Center"
toolTip:	"Use Transform Coordinate Center"
icon:	"MENU:true|title:buttonText"
(
	on isChecked do GetCoordCenter() == #system

	on execute do
		SetCoordCenter #system
)

/** Get selection without members of closed group
 */
function getSelectionWithouGroupMembers =
(
	mapped function getAllChildren node &children = (if isValidNode node and isKindOf children Array do join children node.children)

	children = #()

	groups_closed = for o in ( _selection = selection as Array ) where isGroupHead o and isOpenGroupHead o == false and findItem _selection o.parent == 0 collect o

	getAllChildren groups_closed &children

	for o in selection where findItem children o == 0 collect o --return
)


/*------------------------------------------------------------------------------
	CENTER PIVOT
--------------------------------------------------------------------------------*/
/** RUN MIAUU VISUAL PIVOT
  *
  * http://www.scriptspot.com/3ds-max/scripts/visual-pivot-placer
*/
macroscript _pivot_visual_pivot
category:	"_Pivot"
buttonText:	"Visual"
toolTip:	"Run visual pivot tool"
icon:	"menu:true"
(

	filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/i_pivot_v15.mse" ) -- "./../../../Lib/vendor/miauu/i_pivot_v15.mse"
)


/** CENTER TO OBJECT
  */
macroscript _pivot_center_to_objects_in_selection
category:	"_Pivot"
buttonText:	"Center"
toolTip:	"Center pivot to objects in selection"
icon:	"menu:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-TRANSFORM ⬇\Pivot.mcr"

	on execute do
		for o in ( getSelectionWithouGroupMembers()) do
			CenterPivot  o
)

/** CENTER TO OBJECT
  */
macroscript _pivot_bottom_top
category:	"_Pivot"
buttonText:	"Up\Down"
toolTip:	"Set pivot to bottom\top for each object in selection"
icon:	   "MENU:true"
(
	on execute do
    (
        --filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-TRANSFORM\Pivot.mcr"

		for o in ( _selection = getSelectionWithouGroupMembers()) do
		(
			obj_first = _selection[1]

			is_bottom = obj_first.min.z == obj_first.pivot.z

			for o in _selection do o.pivot = [o.pivot.x, o.pivot.y, (if is_bottom then o.max.z else o.min.z)  ]

			format "PIVOT SET TO % \n" ( if is_bottom then "TOP" else "BOTTOM" )
		)
	)

)


/* Round pivot position to tens
  *
  * E.G.: 123.456  >>> 120
*/
macroscript _pivot_round_position
category:	"_Pivot"
buttonText:	"Round Pivot Pos"
toolTip:	"Round Pivot Position"
icon:	"MENU:true"
(
	fn round val n = (floor ((val * (mult = 10.0 ^ n)) + 0.5)) / mult -- E.G.: round pi 0 as integer

	on execute do
		undo "Round pivot position" on
		(
			--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-TRANSFORM\Pivot.mcr"

			for obj in selection do
			(
				obj.pivot.x = round obj.pivot.x -1
				obj.pivot.y = round obj.pivot.y -1
				obj.pivot.z = round obj.pivot.z -1
			)
		)
)


--/** ALIGN TO WORLD
--*/
--macroscript _pivot_align_to_world_objects_in_selection
--category:	"_Pivot"
--buttonText:	"Center"
--toolTip:	"Align pivot to world"
----icon:	"images:#('/UI_ln/Icons/Maintoolbar_24i.bmp', 32 )"
----icon:	"images:#('$maxroot/UI_ln/Icons/Maintoolbar_24i.bmp', undefined, undefined, 31 )"
--(
--	on execute do
--		for o in selection do WorldAlignPivot o
--)






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
