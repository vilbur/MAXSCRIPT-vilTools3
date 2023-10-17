filein( getFilenamePath(getSourceFileName()) + "/Lib/Transform.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Lib/SnapManager/SnapManager.ms" )	-- "./Lib/SnapManager/SnapManager.ms"


/**
 */
macroscript	_transform_set_angle_snap_value
category:	"_Transform"
buttontext:	"Angle Snap 1|5|45°"
toolTip:	"Toggle snap between 1°, 5° and 45°"
icon:	"MENU:true"
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

/*------------------------------------------------------------------------------
	DONT AFFECT CHILDREN
--------------------------------------------------------------------------------*/

/** ALIGN TO WORLD
*/
macroscript _transfrom_dont_affect_children
category:	"_Transform"
buttonText:	"Not Affect Children"
--toolTip:	"Not afffect children"
icon:	"control:checkbutton|MENU:true"
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




/*------------------------------------------------------------------------------
	LOCK TRANSFORMS
--------------------------------------------------------------------------------*/
macroscript _transfrom_lock_toggle_all
category:	"_Transform"
buttonText:	"Lock\Unlock"
toolTip:		"Lock and save transforms of selection"
icon:		"MENU:true"
(

	on isChecked do selection.count == 1 and ((getTransformLockFlags  selection[1]) as Array ).count == 9 -- checked if single selected object is locked

	on execute do
		undo "Lock transforms" on
		(
			--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-TRANSFORM\Transform.mcr"

			lock_keys = #( #POS_X, #POS_Y, #POS_Z, #ROT_X, #ROT_Y, #ROT_Z, #SCALE_X, #SCALE_Y, #SCALE_Z )


			for obj in selection do
			(
				lock_states = (getTransformLockFlags obj) as Array

				state = if  lock_states.count == lock_keys.count then #none else #all

				setTransformLockFlags obj state

				if state == #all then
					setUserProp obj "lock_transform" ( obj.transform as string )

			)

			--maxOps.affectChildren = not maxOps.affectChildren
			--
			--if EventFired != undefined then
			--	EventFired.control.state = not maxOps.affectChildren

		)

)
/* Restore saved transforms
*/
macroscript _transfrom_restore_all
category:	"_Transform"
buttonText:	"Restore"
toolTip:	"Restore saved transforms"
icon:	"MENU:true"
(
	on execute do
		undo "Restore transforms" on
		(
			--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-TRANSFORM\Transform.mcr"

			for obj in selection where ( saved_transform = getUserProp obj "lock_transform" ) != undefined do
				obj.transform = execute saved_transform

		)
)



/*------------------------------------------------------------------------------
	ALIGN PIVOT TO DIRECTION
--------------------------------------------------------------------------------*/

/**
 *
 */
macroscript	_align_pivot_to_direction
category:	"_Transform"
buttontext:	"To Direction"
--toolTip:	"Open Transform Randomizer Rollout"
--icon: "#(path, index)"
(
    filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/vendor/miauu/miauualignpivottodiection_10.ms" )	-- "./../../../Lib/vendor/miauu/miauualignpivottodiection_10.ms"

	macros.run "miauu" "miauuAlignPivotToVector"
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
