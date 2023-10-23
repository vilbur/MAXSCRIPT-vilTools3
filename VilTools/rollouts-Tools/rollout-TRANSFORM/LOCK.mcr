filein	( getFilenamePath(getSourceFileName()) + "/Lib/TransformLocker/TransformLocker.ms" )	-- "./Lib/TransformLocker/TransformLocker.ms"


/*------------------------------------------------------------------------------
	LOCK TRANSFORMS
--------------------------------------------------------------------------------*/
macroscript _transfrom_lock_toggle_all
category:	"_Transform-Lock"
buttonText:	"Lock\Unlock All"
toolTip:	"Lock and save transforms of selection"
icon:	"MENU:true"
(
	on isChecked do selection.count == 1 and ((getTransformLockFlags  selection[1]) as Array ).count == 9 -- checked if single selected object is locked

	on execute do
		undo "Lock transforms" on
		(
			--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-TRANSFORM\Transform.mcr"
			lock_state = ((getTransformLockFlags selection[1]) as Array ).count != 9

			(TransformLocker_v( selection ) ).toggle (lock_state)

			/* SAVE CURRENT TRANSFORM TO OBJECT PROPERTIES  */
			if lock_state then
				for obj in selection do
					setUserProp obj "lock_transform" ( obj.transform as string )
		)
)

/** TOGGLE POSITION
  *
  */
macroscript _transfrom_lock_toggle_position
category:	"_Transform-Lock"
buttonText:	"Lock\Unlock Postion"
toolTip:	"Lock Postion of selection"
icon:	"MENU:true"
(
	--on isChecked do selection.count == 1 and ((getTransformLockFlags  selection[1]) as Array ).count == 9 -- checked if single selected object is locked

	on execute do
		undo "Lock transforms" on
		(
			current_state = TransformLocker.getState ( objects[1] )

			new_sate = not (current_state[#MOVE_X] and current_state[#MOVE_Y] and current_state[#MOVE_Z])

			(TransformLocker_v( selection ) ).toggle (new_sate) type:#MOVE
		)
)

/** TOGGLE Rotation
  *
  */
macroscript _transfrom_lock_toggle_rotation
category:	"_Transform-Lock"
buttonText:	"Lock\Unlock Rotation"
toolTip:	"Lock Postion of Rotation"
icon:	"MENU:true"
(
	--on isChecked do selection.count == 1 and ((getTransformLockFlags  selection[1]) as Array ).count == 9 -- checked if single selected object is locked

	on execute do
		undo "Lock transforms" on
		(
			current_state = TransformLocker.getState ( objects[1] )

			new_sate = not (current_state[#MOVE_X] and current_state[#MOVE_Y] and current_state[#MOVE_Z])

			(TransformLocker_v( selection ) ).toggle (new_sate) type:#MOVE
		)
)


/* Restore saved transforms
*/
macroscript _transfrom_restore_all
category:	"_Transform-Lock"
buttonText:	"Restore Transforms"
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
