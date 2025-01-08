/** Manage suffix on create
 */
function manageSuffixOnCreate =
(
	--format "\n"; print ".manageSuffixOnCreate()"
	
	obj = callbacks.notificationParam()
	
	obj.name = trimRight obj.name "-0123456789"
)
