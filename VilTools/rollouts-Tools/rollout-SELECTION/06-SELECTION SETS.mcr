
/**
  */
macroscript	selection_sets_save
category:	"_Selection-Sets"
buttontext:	"SAVE"
toolTip:	"Save Named Selection Sets to ini"
icon:	"across:3|width:96|height:28"
(
	on execute do
	(
		ini = getDir #TEMP + "\\selectionSets-copy.ini"

		if queryBox ("SAVE SELECTION SETS ?") title:"SAVE SETS" then
		(
			if doesFileExist ini then
				deleteFile ini
		
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
		
			for setInfo in setsData where (setName = setInfo[1]) != undefined do
			(
				
				--format "setName: %\n" setName
				objs = setInfo[2]
	
				for obj in objs where obj != undefined do
					setINISetting ini setName obj.name ""
	
				--format "obj.name: %\n" obj.name
	
					--setINISetting ini "setName" "X" "X"
	
				
			)
			msg = "Named Selection Sets\n\nHas been saved"
			
			format "%:\n%\n" msg ini
			
		)
	)
)


/**
  */
macroscript	selection_sets_laod
category:	"_Selection-Sets"
buttontext:	"LOAD"
toolTip:	"Load Named Selection Sets from ini"
icon:	""
(
	on execute do
	(
		ini = getDir #TEMP + "\\selectionSets-copy.ini"
		
		if queryBox ("LOAD SELECTION SETS ?") title:"LOAD SETS" then
				
			if doesFileExist ini then
			(
				nsm = NamedSelectionSetManager
				
				/* DELETE OLD SETS */ 
				for s = nsm.GetNumNamedSelSets() - 1 to 0 by -1 do 
					nsm.RemoveNamedSelSetByIndex s
				
				
				/* LOAD FROM FILE */ 
				for set_name in getINISetting ini do
				(
					objs = for obj_name in getINISetting ini set_name collect getNodeByName obj_name
			
					nsm.AddNewNamedSelSet objs set_name
				)
			
				messageBox "Named Selection Sets\n\nhas been loaded" title:"LOAD SETS" 
				
			)
			else
				messageBox "Ini file does not exists.\n\nNamed Selection Sets\n\nMust be saved before" title:"LOAD SETS" 

	)
)


/**
  */
macroscript	selection_sets_delete_all
category:	"_Selection-Sets"
buttontext:	"DELETE"
toolTip:	"DELETE ALL Named Selection Sets From Scene"
icon:	""
(
	on execute do
	(
		
		if queryBox ("DELETE SELECTION SETS ?") title:"DELETE SETS" then
			(
				nsm = NamedSelectionSetManager
				
				/* DELETE OLD SETS */ 
				for s = nsm.GetNumNamedSelSets() - 1 to 0 by -1 do 
					nsm.RemoveNamedSelSetByIndex s
			)
	)
)