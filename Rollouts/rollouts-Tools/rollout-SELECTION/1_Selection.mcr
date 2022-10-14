macroscript SelectionTest
category:"_Selection"
buttonText:"Test"
(
	--messageBox "Test" beep:false
	--messagebox "Selection.mcr";
	--filein ( getFilenamePath(getSourceFileName()) + "/Selection.ms" )
	--rollout_selection.selection_test_.text = "XXX"
	
	--_Selection	= Selection_v
	--fn Kboard_pick =

	--select _GLOBAL_Selection_v_selection
	
	--Selection 	= Selection_v()
	--Selection.name "file"
	
	--Selection.collapse()
	
)

macroscript selectionSave_selectionLoad
category:"_Selection"
buttonText:"Save"
tooltip: "Save selection"
--tooltip: "Save selection|Load Selection"
(
	messageBox "Yupiii" beep:false
	--filein ( getFilenamePath(getSourceFileName()) + "/Selection.ms" )
	
	--_Selection	= Selection_v
	
	--global _GLOBAL_Selection_v_selection = for o in selection where superclassof o == GeometryClass collect o
)

macroscript SelectionLoad
category:"_Selection"
buttonText:"Load"
tooltip: "Load Selection"

(
	messageBox "Yupiii" beep:false
	--messagebox "Selection.mcr";
	--filein ( getFilenamePath(getSourceFileName()) + "/Selection.ms" )
	--rollout_selection.selection_test_.text = "XXX"
	
	--_Selection	= Selection_v
	--fn Kboard_pick =

	--select _GLOBAL_Selection_v_selection
)



macroscript	selection_random
category:	"_Selection"
buttontext:	"Random"
toolTip:	"Random"
--icon:	"#(path, index)"
(
	step = 2
	
	select (for obj in selection where random 1 step == step collect obj)
)




/** COPY PASTE OBEJcTS 
  *	
  */
macroscript	selection_object_temp_copy
category:	"_Selection"
buttontext:	"Copy\Paste"
toolTip:	"Save selection to temp file"
--icon:	"#(path, index)"
(
	if $ != undefined then
	(
		temp_dir	= (GetDir #temp) as string
		
		deleteFile ( temp_dir + "\copy_paste_buffer_backup.max")
		
		renameFile ( temp_dir + "\copy_paste_buffer.max") ( temp_dir + "\copy_paste_buffer_backup.max")
			
		saveNodes $ ( temp_dir + "\copy_paste_buffer.max")
	)
)

macroscript	selection_object_temp_paste
category:	"_Selection"
buttontext:	"Copy\Paste"
toolTip:	"Merge objects from temp file"
--icon:	"#(path, index)"
(
	mergeMaxFile (((GetDir #temp) as string ) + "\copy_paste_buffer.max") #mergeDups #select
)




