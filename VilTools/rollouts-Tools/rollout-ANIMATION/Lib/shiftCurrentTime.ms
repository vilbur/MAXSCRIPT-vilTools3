
/** Shift current time in loop E.g.: Last Frame >>  First Frame
 */
function shiftCurrentTime direction =
(
	--format "\n"; print ".shiftCurrentTime()"
	
	/* Is in range */
	function isInRange frame =
	(
		frame >= animationRange.start.frame and frame <= animationRange.end.frame
	)
	
	shift_to_frame = sliderTime + ( 1 * direction )
	
	
	if not isInRange shift_to_frame then
		shift_to_frame = if shift_to_frame < animationRange.start.frame then animationRange.end.frame else animationRange.start.frame
		
	
	sliderTime = shift_to_frame
	
)