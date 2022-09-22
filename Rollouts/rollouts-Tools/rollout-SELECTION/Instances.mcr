/**  
  *	
  */
macroscript	selection_reinstancer
category:	"_Selection"
buttontext:	"Reinstance"
toolTip:	"Reinstance selection.\n1Master object is 1st in selection"
--icon:	"#(path, index)"
(
	
	if selection.count >= 2 then
    (
		undo on
		(
			master_object	= selection[1]
			
			for_instance = deleteItem ( selection as Array ) 1

			for obj in for_instance do 
				instanceReplace obj master_object
		)
    )
	else
		messageBox "Select at least 2 objects for reinstancing" title:"Reinstancer" 
)

/**  
  *	
  */
macroscript	selection_make_references
category:	"_Selection"
buttontext:	"Reference"
toolTip:	"Reference selection.\n1Master object is 1st in selection"
--icon:	"#(path, index)"
(
	
	if selection.count >= 2 then
    (
		undo on
		(
			master_object	= selection[1]
			
			for_instance = deleteItem ( selection as Array ) 1

			for obj in for_instance do 
				referenceReplace obj master_object
		)
    )
	else
		messageBox "Select at least 2 objects for referencing" title:"Reinstancer" 
)

/**  
  *	
  */
macroscript	selection_select_instances
category:	"_Selection"
buttontext:	"Select instances"
toolTip:	"Select instances of object"
--icon:	"#(path, index)"
(
	instances = (Selection_v()).getInstances( selection )
	
	clearSelection()

	select instances
)

/**  
  *	
  */
macroscript	selection_select_references
category:	"_Selection"
buttontext:	"Select References"
toolTip:	"Select References of object"
--icon:	"#(path, index)"
(
	instances = (Selection_v()).getReferences( selection[1] )
	
	clearSelection()

	select instances
)


/**  
  *	
  */
macroscript	selection_filter_unique_objects
category:	"_Selection"
buttontext:	"Unique objects"
toolTip:	"Select only Unique objects.\nDeselect multiple instances"
--icon:	"#(path, index)"
(
	(Selection_v()).filterUniqueObjects()
)




