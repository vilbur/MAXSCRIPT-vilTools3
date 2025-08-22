/*
    MAXSCRIPT - Align and Key Slave to Master
    
    Description:
    This script aligns a "Slave" object to a "Master" object for each frame
    of the current animation range. It sets new position and rotation keys
    for the Slave object on every frame to match the Master's transform.

    How to Use:
    1. Rename your objects to "Master" and "Slave" respectively.
       Alternatively, you can change the object names in the script below.
    2. Open the Scripting Editor in 3ds Max (Scripting > New Script).
    3. Copy and paste this code into the editor.
    4. Run the script (Ctrl+E or Tools > Evaluate All).
*/
/** Animate align
 */
function animateAlign master_obj slave_obj animation_range =
(
	--format "\n"; print ".animateAlign()"
	
	-- Check if both objects exist in the scene to avoid errors
	if master_obj != undefined and slave_obj != undefined then
	(
		-- Use 'undo' to make the entire script action undoable in one step
		undo "Align and Key Slave to Master" on
		(
			-- The 'with animate on' block automatically creates keys for any
			-- transform changes made within it.
			with animate on
			(
				-- Loop through every frame in the scene's active time segment
				for t = animation_range.start to animation_range.end do
				(
					-- The 'at time' block tells Max to perform the enclosed actions
					-- at the specified frame 't'.
					at time t
					(
						-- This is the core of the script:
						-- 1. It gets the complete transform (position, rotation, scale) of the Master object.
						-- 2. It assigns that exact transform to the Slave object.
						-- Because we are inside 'with animate on', this automatically creates
						-- position and rotation keys for the Slave object at frame 't'.
						slave_obj.transform = master_obj.transform
					)
				)
			)
			
			-- Let the user know the script has finished successfully
			format "Successfully aligned and keyed '%' to '%' from frame % to %.\n" slave_name master_name animation_range.start animation_range.end
			print "Script finished."
		)
	)
	else
	(
		-- If one or both objects aren't found, show an error message.
		messageBox ("Script cancelled: Please ensure objects named '" + master_name + "' and '" + slave_name + "' exist in the scene.")
	)

)
