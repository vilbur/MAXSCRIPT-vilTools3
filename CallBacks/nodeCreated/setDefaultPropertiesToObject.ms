/**
 */
function setDefaultPropertiesToObject =
(
	--print "setDefaultPropertiesToObject()"

	if  isCreatingObject() then -- avoid execute on node cloned or created by script
		(ModStackPreset_v(callbacks.notificationParam())).loadPreset()
)