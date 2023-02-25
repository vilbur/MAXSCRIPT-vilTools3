/*------------------------------------------------------------------------------
	SELECT INTANCES
--------------------------------------------------------------------------------*/

/**  
  *	
  */
macroscript	selection_select_instances_and_references
category:	"_Selection"
buttontext:	"Select instances"
toolTip:	"Select instances and references"
--icon:	"#(path, index)"
(
	for obj in selection do 
		selectmore ((Selection_v()).getInstances( obj ))
)

/**  
  *	
  */
macroscript	selection_select_instances
category:	"_Selection"
buttontext:	"Select instances"
toolTip:	"Select instances"
--icon:	"#(path, index)"
(
	for obj in selection do 
		selectmore ((Selection_v()).getInstances( obj ) type:#INSTANCE)
)
/*------------------------------------------------------------------------------
	SELECT REFERENCE
--------------------------------------------------------------------------------*/

/**  
  *	
  */
macroscript	selection_select_references
category:	"_Selection"
buttontext:	"Select References"
toolTip:	"Select References"
--icon:	"#(path, index)"
(
	for obj in selection do 
		selectmore ((Selection_v()).getInstances( obj ) type:#REFERENCE)
)

/*------------------------------------------------------------------------------
	FILTER UNIQUE OBJECTS
--------------------------------------------------------------------------------*/

/**  
  *	
  */
macroscript	selection_filter_unique_objects
category:	"_Selection"
buttontext:	"Unique objects"
toolTip:	"Filter only unique objects from selection"
--icon:	"#(path, index)"
(
	(Selection_v()).filterUniqueObjects()
)


/*------------------------------------------------------------------------------
	REINSTANCER
--------------------------------------------------------------------------------*/


/**  
  *	
  */
macroscript	selection_reinstancer
category:	"_Selection"
buttontext:	"Reinstance"
toolTip:	"Reinstance selection by 1st object in selection"
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
buttontext:	"Re-reference"
toolTip:	"Make references of selection.\n1Master object is 1st in selection"
--icon:	"#(path, index)"
(
	
	if selection.count >= 2 then
    (
		undo on
		(
			master_object	= selection[1]
			
			for_instance = deleteItem ( selection as Array ) 1
			
			for obj in for_instance do
			(
				maxOps.CollapseNodeTo obj 1 off
								
				referenceReplace obj master_object
			)
		)
    )
	else
		messageBox "Select at least 2 objects for referencing" title:"Reinstancer" 
)



