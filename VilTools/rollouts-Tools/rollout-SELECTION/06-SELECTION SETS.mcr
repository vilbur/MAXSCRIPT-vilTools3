
/**
  */
macroscript	selection_sets_save
category:	"_Selection-Sets"
buttontext:	"Save Selection Sets"
toolTip:	"Save Named Selection Sets to ini"
icon:	"across:2|width:128|height:28"
(
	on execute do
	(
		ini = getDir #TEMP + "\\selectionSets-copy.ini"
	
		nsm = NamedSelectionSetManager -- get the interface
		setsData = #()
		numSets = nsm.GetNumNamedSelSets()    -- correct method
	
		for s = 1 to numSets do
		(
			setName = nsm.GetNamedSelSetName s
			--nodes = nsm.GetSelNodesFromSet s
			
			 objs = for n = 0 to nsm.GetNamedSelSetItemCount s collect
				nsm.GetNamedSelSetItem s n 
	
			append setsData #(setName, objs)
		)
	
		for setInfo in setsData do
		(
			setName = setInfo[1]
			
			objs = setInfo[2]

			for obj in objs where obj != undefined do
				setINISetting ini setName obj.name ""
			
		)
		
		messageBox "Named Selection Sets\n\nHas been saved to file" title:"SAVE SETS" 
	)
)


/**
  */
macroscript	selection_sets_laod
category:	"_Selection-Sets"
buttontext:	"Load Selection Sets"
toolTip:	"Load Named Selection Sets from ini"
icon:	""
(
	on execute do
	(
		ini = getDir #TEMP + "\\selectionSets-copy.ini"
		
		if doesFileExist ini then
		(
			nsm = NamedSelectionSetManager
			
			for s = 1 to nsm.GetNumNamedSelSets() do
				RemoveNamedSelSetByIndex s
			
			for set_name in getINISetting ini do
				(
					objs = for obj_name in getINISetting ini set_name collect getNodeByName obj_name
			
					nsm.AddNewNamedSelSet objs set_name
				)
		
			messageBox "Named Selection Sets\n\nhas been saved to file" title:"LOAD SETS" 
			
		)
		else
			messageBox "Ini file does not exists.\n\nNamed Selection Sets\n\nMust be saved before" title:"LOAD SETS" 

	)
)