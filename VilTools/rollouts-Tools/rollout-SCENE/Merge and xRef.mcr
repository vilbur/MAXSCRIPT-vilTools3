/** COPY UNLINK PARENTS
 *
 */
macroscript	_scene_copy_objects_between_max_unlinked
category:	"_Scene"
buttontext:	"Copy Selection"
toolTip:	"Copy objects in selection"
--icon:	"across:5|width:72|menu:_Scene"
(

	objects_with_unselected_parent = for o in selection where o.parent != undefined and findItem ( selection as Array ) o.parent == 0 collect o -- get obejcts which parent is not selected
	format "objects_with_unselected_parent	= % \n" objects_with_unselected_parent
	parents = for o in objects_with_unselected_parent collect o.parent
	format "parents	= % \n" parents
	/* UNLINK */
	for child_obj in objects_with_unselected_parent do child_obj.parent = undefined

	saveNodes selection (((GetDir #temp) as string ) + "\copy_paste_buffer.max")  quiet:true

	/* RELINK */
	for i = 1 to objects_with_unselected_parent.count do
		 objects_with_unselected_parent[i].parent = parents[i]

)

/** COPY
 *
 */
macroscript	_scene_copy_object_between_max
category:	"_Scene"
buttontext:	"Copy Selection"
toolTip:	"Copy objects in selection with hierarchy"
--icon:	"across:5|width:72|menu:_Scene"
(
	saveNodes selection (((GetDir #temp) as string ) + "\copy_paste_buffer.max")  quiet:true
)



/** PASTE
 *
 */
macroscript	_scene_paste_object_between_max
category:	"_Scene"
buttontext:	"Paste Selection"
toolTip:	"Paste object to scene"
--icon:	"across:5|width:72|menu:_Scene"
(
	mergeMaxFile (((GetDir #temp) as string ) + "\copy_paste_buffer.max") #select

)