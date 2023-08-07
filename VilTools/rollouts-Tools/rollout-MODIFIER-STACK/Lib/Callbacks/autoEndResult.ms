/** On mod panel sub object level changed
 */
function autoEndResult =
(
	format "\n"; print "autoEndResult()"

	subobj_old = (callbacks.notificationParam())[1]
	subobj_new = (callbacks.notificationParam())[2]

	--subobjects = callbacks.notificationParam()
	format "subobj_new:	% \n" subobj_new
	showEndResult = not ( subobj_new > 0 )
)