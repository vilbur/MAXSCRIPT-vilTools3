clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../TransformLocker.ms" )	-- "./../TransformLocker.ms"


delete objects

max hierarchy mode

_Sphere = Sphere isSelected:on


/*------------------------------------------------------------------------------
	DEFINE STRUCT
--------------------------------------------------------------------------------*/
TransformLocker = TransformLocker_v( objects )

/*------------------------------------------------------------------------------
	TEST
--------------------------------------------------------------------------------*/


TransformLocker.toggle (true) type:#MOVE_X

TransformLocker.toggle (true)  type:#MOVE

format "CURRENT STATE:	% \n" ( TransformLocker.getState ( objects[1] ) )

TransformLocker.toggle (true)  type:#ROTATE

TransformLocker.toggle (true)  type:#SCALE

TransformLocker.toggle (false) -- UNLOCK ALL




/*------------------------------------------------------------------------------
	TOGGLE
--------------------------------------------------------------------------------*/

current_state = TransformLocker.getState ( objects[1] )
format "current_state:	% \n" current_state
new_sate = not (current_state[#MOVE_X] and current_state[#MOVE_Y] and current_state[#MOVE_Z])

(TransformLocker_v( objects[1] ) ).toggle (new_sate) type:#MOVE
