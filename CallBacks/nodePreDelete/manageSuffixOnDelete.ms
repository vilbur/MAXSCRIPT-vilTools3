/** Manage suffix on delete
 */
function manageSuffixOnDelete =
(
	--format "\n"; print ".manageSuffixOnDelete()"
	
	obj = callbacks.notificationParam()
	
	basename = trimRight obj.name "-0123456789"
	
	same_name_objs = (execute ("$'"+ basename + "'*") as Array )

	if same_name_objs.count == 2 then
		for obj in same_name_objs do
		obj.name = basename
)
