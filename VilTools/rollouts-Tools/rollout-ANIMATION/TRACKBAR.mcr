/*
	"./../../../CallBacks/filePostOpen/checkWorldUnits.ms"
*/ 
macroscript	_animation_set_animation_range
category:	"_Animation"
buttontext:	"AUTO SET ANIMATION RANGE"
tooltip:	"ON SCENE OPEN:\n\n  Set number of animation frames by highest key used in scene"
icon:	"ACROSS:1|control:checkbox|MENU:true"
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
macroscript	_animation_range_start
category:	"_Animation"
buttontext:	"Range"
tooltip:	"Set first frame of range"
icon:	"control:spinner|type:#integer|ACROSS:2|align:#LEFT|fieldwidth:64|range:[0,1000,100]|offset:[ 0, 2 ]"
(
	on execute do
	(
		format "EventFired: %\n" EventFired	
		
		start = ROLLOUT_animation.SPIN_range.value
		end   = ROLLOUT_animation.SPIN_to.value
		
		if start >= end then
		(
			end = start + 1
			
			ROLLOUT_animation.SPIN_to.value = end
		)
		
		animationRange = Interval start end
	)
	
)
/**  SET ANIMATION COUNT OF FRAMES
 */
macroscript	_animation_range_end
category:	"_Animation"
buttontext:	"To"
tooltip:	"Set last frame of range"
icon:	"control:spinner|type:#integer|ACROSS:2|align:#LEFT|fieldwidth:64|range:[1,1000,100]|offset:[ 0, 2 ]"
(
	on execute do
	(
		format "EventFired: %\n" EventFired	
		
		start = ROLLOUT_animation.SPIN_range.value
		end   = ROLLOUT_animation.SPIN_to.value
		
		if start >= end then
		(
			start = end - 1
			
			ROLLOUT_animation.SPIN_range.value = start
		)
			
		animationRange = Interval start end
	)
	
)


/*
  Function to delete animation keys to the right of current frame on selection
*/
function trimKeysRightFromCurrentFrame includeCurrentFrame =
(
	current_time = currentTime
	
	start_time = if includeCurrentFrame then current_time else (current_time + 1)
	format "start_time: %\n" start_time
	
	-- helper to safely delete keys from any controller
	function deleteKeysAfterTime ctrl start_time =
	(
		
		format "deleteKeysAfterTime: %\n" ctrl
		
		--if isProperty ctrl #numKeys then
		--FORMAT "% : %\n" ctrl ( numKeys ctrl)

		--if isController ctrl and isProperty ctrl #numKeys and ctrl.numKeys > 0 then
		if isController ctrl and ( numKeys ctrl ) > 0 then
		(
			--for k = ( numKeys ctrl ) - 1 to 1 by -1 do
			for k = ( numKeys ctrl )  to 1 by -1 do
			(
				
				key_time = getKeyTime ctrl k
				
				format "key_time: %\n" key_time
				
				if key_time >= start_time then deleteKey ctrl k
			)
		)
	)

	for obj in selection where isValidNode obj do
	(
		-- transform controllers: position, rotation, scale
		track_list = #(obj.position.controller, obj.rotation.controller, obj.scale.controller)

		for ctrl in track_list do
		(
			if isController ctrl then
			(
				format "\n"
				format "isProperty ctrl #numSubs: %\n" (isProperty ctrl #numSubs)
				format "ctrl.numSubs: %\n" ctrl.numSubs
				
				if isProperty ctrl #numSubs and ctrl.numSubs > 0 then
				(
					for i = 1 to ctrl.numSubs do
					(
						sub_ctrl = getSubAnim ctrl i
						format "sub_ctrl: %\n" sub_ctrl
						deleteKeysAfterTime sub_ctrl start_time
					)
				)
				else
				(
					deleteKeysAfterTime ctrl start_time
				)
				deleteKeysAfterTime ctrl start_time
			)
		)

		-- optional: other animatable subAnims (modifiers, custom attributes)
		--if isProperty obj #numSubs and obj.numSubs > 0 then
		--(
		--	for i = 1 to obj.numSubs do
		--	(
		--		sub_anim = getSubAnim obj i
		--		
		--		format "\n"
		--		format "% isController : %\n" sub_anim (isController sub_anim)
		--		
		--		if isController sub_anim then
		--		(
		--			if isProperty sub_anim #numSubs and sub_anim.numSubs > 0 then
		--			(
		--				for j = 1 to sub_anim.numSubs do
		--				(
		--					sub_ctrl = getSubAnim sub_anim j
		--					deleteKeysAfterTime sub_ctrl start_time
		--				)
		--			)
		--			else
		--			(
		--				deleteKeysAfterTime sub_anim start_time
		--			)
		--		)
		--	)
		--)
	)
) -- return


/**  SET ANIMATION COUNT OF FRAMES
 */
macroscript	_animation_remove_all_frames_after_currenttime
category:	"_Animation"
buttontext:	"Remove from Current Frame"
tooltip:	"REMOVE ANIMIMATION KEYS CURRENT TIME TO RIGHT"
icon:	"ACROSS:2|width:128"
(
	on execute do
	(
			trimKeysRightFromCurrentFrame true   -- delete keys at and after current frame

		---- First, ensure at least one object is selected to avoid errors.
		--if selection.count > 0 then
		--(
		--	-- Create a message that includes the exact current frame number.
		--	local prompt_message = "REMOVE KEYS\n\nFROM: " + (currentTime as string) + " TO RIGHT ?"
		--
		--	-- Show the confirmation dialog. The script only proceeds if you click "Yes".
		--	if queryBox prompt_message title:"Confirm Keyframe Deletion" then
		--	(
		--		-- THIS IS THE CRUCIAL PART:
		--		-- We define a time range. It starts at the frame IMMEDIATELY AFTER
		--		-- the current one (currentTime + 1f) and ends at a very high frame
		--		-- number to include all future keys.
		--		local time_range_to_delete = interval (currentTime + 1f) 999999
		--
		--		-- The 'in time' expression forces the 'deleteKeys' command to ONLY
		--		-- operate within the 'time_range_to_delete' defined above.
		--		-- It will NOT touch any keys at or before the current time.
		--		--deleteKeys selection #allKeys in time time_range_to_delete 
		--		deleteKeys selection #allKeys #leftToRight
		--
		--		-- Let the user know the operation is complete.
		--		print "Future keyframes have been deleted."
		--	)
		--	else
		--	(
		--		print "Operation cancelled."
		--	)
		--)
		--else
		--(
		--	-- If nothing is selected, show this message.
		--	messageBox "Please select one or more objects first." title:"No Selection"
		--)
		
	)
)



/**  SET ANIMATION COUNT OF FRAMES
 */
macroscript	_animation_remove_all_frames
category:	"_Animation"
buttontext:	"Remove All Frames"
tooltip:	"REMOVE ANIMIMATION KEYS ALL FRAMES"
icon:	"ACROSS:2"
(
	on execute do
	(
				
		-- Check if any objects are selected
		if selection.count > 0 then
		(
			-- Format  directionthe confirmation message with the current time
			local prompt_message = "DELETE ALL KEYFRAMES ?"
		
			-- Display a yes/no confirmation box to the user
			if queryBox prompt_message title:"Confirm Keyframe Deletion" then
			(
				with redraw off
				(
					deleteKeys selection #allKeys 
				)
		
				-- Print a confirmation message to the MAXScript Listener
				print "Future keyframes deleted for selected objects."
				ok -- Return 'ok' to the listener
			)
			else
			(
				-- If user clicks 'No', print a cancellation message
				print "Operation cancelled by user."
			)
		)
		else
		(
			-- If no objects are selected, show an alert message
			messageBox "Please select one or more objects first." title:"No Selection"
		)

		
	)
)



/**  SET ANIMATION COUNT OF FRAMES
 */
macroscript	_animation_set_frame_next
category:	"_Animation"
buttontext:	"Shift Frame"
tooltip:	"Set Next Anim Frame"
icon:	"ACROSS:2"
(
	on execute do
		shiftCurrentTime 1

)

/**  SET ANIMATION COUNT OF FRAMES
 */
macroscript	_animation_set_frame_prev
category:	"_Animation"
buttontext:	"Shift Frame"
tooltip:	"Set Previous Anim Frame"
icon:	"ACROSS:2"
(
	on execute do
		shiftCurrentTime -1

)

