/** On mod panel sub object level changed
 */
function autoEndResult =
(
	--format "\n"; print "autoEndResult()"
	subobj_new = (callbacks.notificationParam())[1]
	--subobj_old = (callbacks.notificationParam())[2]
	
	showEndResult = not (subobj_new > 0)
)