filein( getFilenamePath(getSourceFileName()) + "/Lib/Transform.ms" )	--"./Lib/Transform.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/SnapManager/SnapManager.ms" )	-- "./Lib/SnapManager/SnapManager.ms"


/**
 */
macroscript	_transform_set_angle_snap_value
category:	"_Transform"
buttontext:	"Angle Snap 1|5|45°"
toolTip:	"Toggle snap between 1°, 5° and 45°"
icon:	"MENU:true|across:3"
(
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-TRANSFORM\Transform.mcr"

		SnapManager = SnapManager_v()

		angles = #( 1, 5, 45 )

		next_angle = if (index = findItem angles (SnapManager.getAngle())) == 0 or index == angles.count then angles[1] else angles[index +1]

		if not SnapManager.getState() then
			SnapManager.setState(true)

		SnapManager.setAngle( next_angle  )

        format "ANGLE SNAP:	% \n" next_angle

	)

	on altExecute type do
	(
		actionMan.executeAction 0 "40024"  -- Snaps: Grid and Snap Settings Toggle
	)
)

/**
 */
macroscript	_transform_reset_xform
category:	"_Transform"
buttontext:	"Reset xForm"
toolTip:	"Reset xForm of selected objects"
--icon:	"MENU:true"
(
	on execute do
		for obj in selection where superClassOf obj == GeometryClass do
		(
			ResetXForm obj

			modPanel.addModToSelection (XForm ()) ui:on

			convertTo obj Editable_Poly
		)
)

/*
*/
macroscript	rotate_toos_rotate
category:	"_Transform"
buttontext:	"Rotate"
toolTip:	"Rotate selection active axis of angle snap value"
--icon:	"MENU:true"
(
	on execute do
		(Transform_v()).rotateSelection( (SnapManager_v()).getAngle() )
)

/*
*/
macroscript	rotate_toos_rotate_reverse
category:	"_Transform"
buttontext:	"Rotate"
--toolTip:	"Rotate about active axis"
--icon:	"MENU:true"
(
	on execute do
		(Transform_v()).rotateSelection( (SnapManager_v()).getAngle() * -1 )
)


/**
 */
macroscript	_transform_type_in
category:	"_Transform"
buttontext:	"Type in"
toolTip:	"Mini Transform Type In\n\nDOUBLECLICK: Change window Postion"
--icon:	"MENU:true"
(
	on execute do
		filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/Mini-Transform-Type-In.ms" )
)

/**
 */
macroscript	_transform_type_in_close
category:	"_Transform"
buttontext:	"Type in"
toolTip:	"Close dialog"
--icon:	"MENU:true"
(
	on execute do
	(

		hwndMove = windows.getChildHWND 0 "Move Transform Type-In"
		UIAccessor.CloseDialog hwndMove[1]
	)

)
/*------------------------------------------------------------------------------
	DONT AFFECT CHILDREN
--------------------------------------------------------------------------------*/

/** ALIGN TO WORLD
*/
macroscript _transfrom_dont_affect_children
category:	"_Transform"
buttonText:	"Not Affect Children"
--toolTip:	"Not afffect children"
icon:	"control:checkbox|MENU:true|across:1|align:#CENTER"
(
	on isChecked do not maxOps.affectChildren

	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-TRANSFORM\Transform.mcr"

		maxOps.affectChildren = not maxOps.affectChildren

		if EventFired != undefined then
			EventFired.control.state = not maxOps.affectChildren

	)
)

/**
 */
macroscript	_transform_randomizer
category:	"_Transform"
buttontext:	"Randomizer"
toolTip:	"Open Transform Randomizer Rollout"
--icon:	"MENU:true"
(
	on execute do
		filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/Random-Transform/random_transform_v1.ms" )
)
F