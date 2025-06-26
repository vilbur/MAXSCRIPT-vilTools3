--/**
-- * https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_C1F6495F_5831_4FC8_A00C_667C5F2EAE36_htm
-- */
--function autoSetAnimationRangeCallback =
--(
--	print "Start: autoSetAnimationRange()"
--	try( callbacks.addScript #filePostOpen "autoSetAnimationRange()" id:#autoSetAnimationRange )catch()
--)
--
--
--/** 
-- */
--function autoSetAnimationRangeKill =
--(
--	print "Kill: autoSetAnimationRange()"
--	try( callbacks.removeScripts #filePostOpen id:#autoSetAnimationRange )catch()
--)


/** Set number of animation frames by highest key used in scene
 */
function autoSetAnimationRange =
(
	print "autoSetAnimationRange()"
	
	max_key = 0
	
	for obj_class in #( geometry, shapes ) do 
		for obj in obj_class do 
		--for obj in objects do 
			for controller_type in #( #POSITION, #ROTATION ) do 
			(
				controller	= case controller_type of
				(
					#POSITION:	obj.position.controller
					#ROTATION:	obj.rotation.controller
				)
				--format "controller: %\n" controller
				--format "numKeys controller: %\n" (numKeys controller)
				
				if (num_keys = numKeys controller ) > 0 then
				(
					anim_keys = for i = 1 to num_keys collect ((getKeyTime controller i) as string ) as integer
					
					if ( amax_key = amax anim_keys ) > max_key then
						max_key = amax_key
				)
			)
	--format "MAX_KEY: %\n" max_key
			
	if max_key > 0 then
	(
		animationRange = Interval 0 max_key
		
		sliderTime = max_key
	)
)