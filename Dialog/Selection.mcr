macroscript selectionSave_selectionLoad
category:"_Selection"
buttonText:"Selection save"
tooltip: "Save selection|Load Selection"
(
	messageBox "Yupiii" beep:false
	--filein ( getFilenamePath(getSourceFileName()) + "/Selection.ms" )
	
	--_Selection	= Selection_v
	
	--global _GLOBAL_Selection_v_selection = for o in selection where superclassof o == GeometryClass collect o
)

macroscript SelectionLoad
category:"_Selection"
buttonText:"Selection load"  
(
	messageBox "Yupiii" beep:false
	--messagebox "Selection.mcr";
	--filein ( getFilenamePath(getSourceFileName()) + "/Selection.ms" )
	--rollout_selection.selection_test_.text = "XXX"
	
	--_Selection	= Selection_v
	--fn Kboard_pick =

	--select _GLOBAL_Selection_v_selection
)

