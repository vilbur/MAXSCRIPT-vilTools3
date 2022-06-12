/** On mod panel sub object level changed
 */
function autoEndResult =
(
	format "\n"; print "autoEndResult()"
	format "subobjs	= % \n" ()
	
	subobjects = callbacks.notificationParam()

	showEndResult = not (subobjects[1] > 0)
)