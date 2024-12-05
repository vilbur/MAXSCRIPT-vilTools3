
/**
  */
macroscript	selection_select_all
category:	"_Selection-Edit"
buttontext:	"Select All"
toolTip:	"Select All - CLOSE LAYER MANAGER IF OPENED"
icon:	"across:3"
(
	on execute do
	(
		is_manager_open
		max_visible_objects = 20
		
		/* IF NOT SUBOBJECT ACTIVE */ 
		if not ( subObjectLevel != undefined and subObjectLevel > 0 ) then
		(
			visible_objects = (for obj in objects where not obj.isHidden collect obj).count
			format "visible_objects: %\n" visible_objects
			/* CLOSE LAYER MANAGER BEFORE SELECTION */
			if visible_objects > max_visible_objects and LayerManager.isDialogOpen() then
				is_manager_open = LayerManager.closeDialog()

			actionMan.executeAction 0 "40021"  -- Selection: Select All
			format "is_manager_open: %\n" is_manager_open
			/* REOPEN LAYER MANAGER */
			if is_manager_open != undefined then
				LayerManager.editLayerByName ""

		)
		else /* SUBOBJECT LEVEL */ 
			actionMan.executeAction 0 "40021"  -- Selection: Select All

	)
)



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
icon:	"MENU:true|across:2"
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
