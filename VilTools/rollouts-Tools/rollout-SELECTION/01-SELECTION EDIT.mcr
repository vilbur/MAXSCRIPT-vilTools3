
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

			if visible_objects.count == 0 then
				return false
			
			/* GET LAYER MANAGER AUTO EXPAND STATE */
			if visible_objects > max_visible_objects and ( layer_manager_dialog = SceneExplorerManager.GetActiveExplorer() ) != undefined and ( auto_expand = layer_manager_dialog.AutoExpand ) then
				layer_manager_dialog.AutoExpand = false
			
			actionMan.executeAction 0 "40021"  -- Selection: Select All

			
			/* RESET AUTO EXPAND */
			if layer_manager_dialog != undefined and auto_expand then
				layer_manager_dialog.AutoExpand = true
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
	on execute do
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
	on execute do
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

/**
  */
macroscript	selection_select_same_suffix
category:	"_Selection-Edit"
buttontext:	"Select by suffix"
toolTip:	"Select by suffix"
icon:	"MENU:true|across:1|width:96"
(
	on execute do
	(
		
		/** Get suffix
		 */
		function getSuffix obj_name =
		(
			--format "\n"; print ".getSuffix()"
			string_split	= filterString obj_name "-_ "
			
			 string_split[string_split.count] --return
		)
		
		selected_names = #()
	
		for obj in selection do
			appendIfUnique selected_names (getSuffix obj.name)
			
		same_name_objs = for obj in objects where not obj.isHidden and findItem selected_names (getSuffix obj.name) > 0 collect obj
	
		if same_name_objs.count > 0 then
			select same_name_objs
	
	) -- return
)