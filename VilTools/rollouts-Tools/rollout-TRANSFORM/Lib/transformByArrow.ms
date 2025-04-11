/** Transform by arrow
  * 
  * @param #LEFT|#RIGHT|#UP|#DOWN arrow
 */
function transformByArrowKey arrow =
(
	--format "\n"; print ".transformByArrow()"
	--format "\n"
	--format "arrow: %\n" arrow
	if selection.count == 0 then
		return false
	
	toolMode.commandmode = #MOVE
	
	tm = [0,0,0]
	
	increment = GetGridSpacing()
	
	view_type = viewport.getType() as string
	view_type	= substituteString view_type "view_" ""
	view_type	= substituteString view_type "_user" ""
	view_type	= view_type	as name
	
	is_ortho_view = not matchPattern ( view_type as string ) pattern:@"*user"
	
	
	if (view_type == #LEFT	and ( arrow == #RIGHT or arrow == #DOWN )) \
	or (view_type == #BACK	and ( arrow == #RIGHT or arrow == #DOWN )) \
	or (view_type == #RIGHT	and ( arrow == #LEFT  or arrow == #DOWN )) \
	or (view_type == #FRONT	and ( arrow == #LEFT  or arrow == #DOWN )) \
	or (view_type == #TOP	and ( arrow == #LEFT  or arrow == #DOWN )) \
	or (view_type == #PERSP	and ( arrow == #LEFT  or arrow == #DOWN )) \
	or (view_type == #ISO	and ( arrow == #LEFT  or arrow == #DOWN )) \
	or (view_type == #BOTTOM	and ( arrow == #LEFT  or arrow == #UP )) \
	then
		increment *= -1
		 
	axises = case view_type of
	(
		#FRONT:	"XZ"
		#BACK:	"XZ"
		
		#LEFT:	"YZ"
		#RIGHT:	"YZ"

		default: "XY"
	)
	
	axises = axises as string
	
	axis = if arrow == #LEFT or arrow == #RIGHT then axises[1] else axises[2]

	setProperty tm (axis as name ) increment
	
	in coordsys world move $ tm
	
)
