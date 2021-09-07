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

macroscript	selection_select_instances
category:	"_Selection"
buttontext:	"Instances"
toolTip:	"Select instances of object"
--icon:	"#(path, index)"
(
	only_visible   = false
	global instances = #()
	
	for obj in selection do
	(	
		local obj_instance
		InstanceMgr.GetInstances obj &obj_instance
		join instances obj_instance	
	)
	
	if only_visible == 1 then
		for o in instances where  o.visibility == false do deleteitem instances (finditem instances o )
	
	select instances	
)