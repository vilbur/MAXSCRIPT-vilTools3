/** Transform by arrow
  * 
  * @param #LEFT|#RIGHT|#UP|#DOWN arrow
 */
function transformByArrowKey arrow =
(
	--format "\n\n"; print ".transformByArrow()"
	/** Z axis is actove
	 */
	function zAxisIsActive = matchPattern ( toolMode.axisConstraints as string ) pattern:("*Z*")
	
	/** View_name
	 */
	function view_name =
	(
		view_type = viewport.getType() as string
		view_type	= substituteString view_type "view_" ""
		view_type	= substituteString view_type "_user" ""
		view_type	as name
	)()
	
	if selection.count == 0 then
		return false
	
	toolMode.commandmode = #MOVE
	
	tm = [0,0,0]
	
	increment = GetGridSpacing()
	
	is_perspective = view_type == #PERSP or view_type == #ISO
	
	/* SET NEGATIVE DIRECTION BY COMBINATION OF VIEW AND DIRECTION */ 
	if  ( arrow == #LEFT  or arrow == #UP   ) and view_type == #BOTTOM                                           \
	or ( arrow == #RIGHT or arrow == #DOWN ) and findItem #( #LEFT,  #BACK                      ) view_type > 0 \
	or ( arrow == #LEFT  or arrow == #DOWN ) and findItem #( #RIGHT, #FRONT, #TOP, #PERSP, #ISO ) view_type > 0 \
	then
		increment *= -1
	
	/* GET AXISES BY VIEW */ 	
	axises = case view_type of
	(
		#FRONT:	"XZ"
		#BACK:	"XZ"
		
		#LEFT:	"YZ"
		#RIGHT:	"YZ"

		default: "XY"
	)

	/* GET AXIS BY DIRECTIONS LEFT|RIGHT OR UP|DOWN */ 
	axis = if arrow == #LEFT or arrow == #RIGHT then axises[1] else axises[2]
	
	
	/* SWITCH ON UP|DOWN KEY TO Z AXIS  IF IT`S ACTIVE IN PERPESTIVE AND ISO VIEW */ 
	if is_perspective and zAxisIsActive() then
	(
		axis = if (arrow == #UP or arrow == #DOWN) then "Z" else substituteString ( toolMode.axisConstraints as string ) "Z" ""
		
		if axis == "Y" then increment *= -1
	)
	
	/* SET VALUE TO MATRIX */ 
	setProperty tm (axis as name ) increment
	
	/* MOVE SELECTION */ 
	in coordsys world move $ tm
)
