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
	max create mode

	for obj in selection do
		selectmore ((Selection_v()).getInstances( obj ))
		--select ((Selection_v()).getInstances( selection[1] ))
)

/**
  *
  --*/
macroscript	selection_select_instances
category:	"_Selection"
buttontext:	"Select instances"
toolTip:	"Select instances"
--icon:	"#(path, index)"
(
	max create mode

	undo "Select instances objects" on
	(
		max create mode

		for obj in selection do
			selectmore ((Selection_v()).getInstances( obj ) type:#INSTANCE)
	)
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
	max create mode

	for obj in selection do
		selectmore ((Selection_v()).getInstances( obj ) type:#REFERENCE)
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
toolTip:	"Reinstance selection.\n\nMaster object is last object in selection"
--icon:	"#(path, index)"
(
	max create mode

	undo "Reinstancer Objects" on
	(
		if selection.count >= 2 then
		(
			undo on
			(
				master_object	= selection[ selection.count ]

				for_instance = deleteItem ( selection as Array ) selection.count

				for obj in for_instance do
					instanceReplace obj master_object
			)
		)
		else
			messageBox "Select at least 2 objects for reinstancing" title:"Reinstancer"
	)

)

/**
  *
  */
macroscript	selection_make_references
category:	"_Selection"
buttontext:	"Re-reference"
toolTip:	"Make references of selection.\n\nMaster object is last in selection"
--icon:	"#(path, index)"
(
	max create mode

	undo "Rereference Objects" on
	(
		if selection.count >= 2 then
		(
			undo on
			(
				master_object	= selection[selection.count]

				for_instance = deleteItem ( selection as Array ) selection.count

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
)