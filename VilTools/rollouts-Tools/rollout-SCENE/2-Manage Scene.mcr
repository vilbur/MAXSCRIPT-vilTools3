/** COPY UNLINK PARENTS
 *
 */
macroscript	_scene_copy_objects_between_max_unlinked
category:	"_Scene"
buttontext:	"Copy Selection"
toolTip:	"Copy objects in selection"
--icon:	"across:5|width:72|MENU:_Scene"
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
icon:	"MENU:true"
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
icon:	"MENU:true"
(
	mergeMaxFile (((GetDir #temp) as string ) + "\copy_paste_buffer.max") #select

)

/*------------------------------------------------------------------------------

	 FETCH \ HLOD

--------------------------------------------------------------------------------*/


/**
 *
 */
macroscript	_scene_hold
category:	"_Scene"
buttontext:	"Hold\Fetch"
toolTip:	"Hold scene"
--icon:	"#(path, index)"
(
	if queryBox "Hold scene ?" title:"Hold scene"  beep:false then
		holdMaxFile()
)

/**
 *
 */
macroscript	_scene_fetch
category:	"_Scene"
buttontext:	"Hold\Fetch"
toolTip:	"Fetch scene"
--icon:	"#(path, index)"
(
	if queryBox "Fetch scene ?" title:"Fetch scene"  beep:false then
	(
		fetchMaxFile quiet:true
		print "SCENE FETCHED"
	)
)

/*------------------------------------------------------------------------------

	RELOAD

--------------------------------------------------------------------------------*/

/**
 */
macroscript	_scene_relaod
category:	"_Scene"
buttontext:	"Reload"
toolTip:	"Reload current file"
icon:	"MENU:tooltip"
(
	if queryBox ("Reload "+ maxFileName +" ?") title:"Hold scene"  beep:false then
		loadMaxFile ( maxFilePath + maxFileName ) quiet:true

)
/*------------------------------------------------------------------------------

	RESET

--------------------------------------------------------------------------------*/

macroscript	_scene_reset
category:	"_Scene"
buttontext:	"Reset SCene"

icon:	"MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SCENE\Scene.mcr"
	on execute do
	(
		resetMaxFile()
	)
)