/*
	"./../../../CallBacks/filePostOpen/checkWorldUnits.ms"
*/ 
macroscript	_animation_set_animation_range
category:	"_Animation"
buttontext:	"AUTO SET ANIMATION RANGE"
tooltip:	"ON SCENE OPEN:\n\n  Set number of animation frames by highest key used in scene"
icon:	"ACROSS:2|control:checkbox|MENU:true"
(
	/* https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-5A4580C6-B5CF-12104-898B-9313D1AAECD4 */
	--on isEnabled return selection.count > 0

	on execute do
	(
		--format "EventFired: %\n" EventFired
		try(
			
			if EventFired == undefined or ( EventFired != undefined and EventFired.val ) then
			(
				autoSetAnimationRange()
				
				CALLBACKMANAGER.start "autoSetAnimationRange"
				
				cbx_state = true
			)
			else
			(
				CALLBACKMANAGER.kill "autoSetAnimationRange"
				
				cbx_state = false
			)
			
		/* UPDATE UI */ 
		if ROLLOUT_animation != undefined then 
			ROLLOUT_animation.CBX_auto_set_animation_range.state = cbx_state
			
		)catch()
	)
	
)


/**  SET ANIMATION COUNT OF FRAMES
 */
macroscript	_animation_toggle_trackbar
category:	"_Animation"
buttontext:	"SliderTime"
tooltip:	"Set number of frames of timeslider"
icon:	"control:spinner|type:#integer|ACROSS:2|fieldwidth:64|range:[2,1000,100]|offset:[ 0, 2 ]"
(
	animationRange = Interval 0 (EventFired.val as integer )
)
