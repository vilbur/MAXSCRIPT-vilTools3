

/**
  */
macroscript	selection_sort_by_name
category:	"_Selection-Edit"
buttontext:	"Sort By Name"
toolTip:	"Sort By Name"
--icon:	"#(path, index)"
(
	fn compareNames obj_1 obj_2 = stricmp obj_1.name obj_2.name

	on execute do
	(
		_selection = for obj in selection collect obj

		qsort _selection compareNames

		select _selection
	)
)


/**
  */
macroscript	selection_random
category:	"_Selection-Edit"
buttontext:	"Random"
toolTip:	"Random"
--icon:	"#(path, index)"
(
	step = 2

	select (for obj in selection where random 1 step == step collect obj)
)


/** COPY
 *
 */
macroscript	_selection_copy_object_between_max
category:	"_Selection-Edit"
buttontext:	"Copy Selection"
toolTip:	"Copy objects in selection with hierarchy"
icon:	"MENU:true"
(
	saveNodes selection (((GetDir #temp) as string ) + "\copy_paste_buffer.max")  quiet:true
)

/** COPY UNLINK PARENTS
 *
 */
macroscript	_scene_copy_objects_between_max_unlinked
category:	"_Selection-Edit"
buttontext:	"Copy Selection"
toolTip:	"Copy objects in selection"
icon:	"across:5|width:72|MENU:true"
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


/** PASTE
 *
 */
macroscript	_selection_paste_object_between_max
category:	"_Selection-Edit"
buttontext:	"Paste Selection"
toolTip:	"Paste object to scene"
icon:	"MENU:true"
(
	mergeMaxFile (((GetDir #temp) as string ) + "\copy_paste_buffer.max") #select
)
