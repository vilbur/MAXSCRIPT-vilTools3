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

	if selection.count >= 2 then
	(
		undo "Reinstance Objects" on
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


/*------------------------------------------------------------------------------

	RE REFERENCE OBEJCTS

--------------------------------------------------------------------------------*/

/** MACROS BELOOW SHOULD BE IN OWN STRUCT
  */
macroscript	selection_make_references
category:	"_Selection"
buttontext:	"Re-reference"
toolTip:	"Each object will be THE SAME reference."
icon:	"tooltip:'Make references of selection.\nLast object in selection is master object.\n'"
(
	max create mode

	if selection.count >= 2 then
	(
		undo "Re-reference Objects" on
		(
			master_object	= selection[selection.count]

			for_instance = deleteItem ( selection as Array ) selection.count

			for obj in for_instance do
				maxOps.CollapseNode obj true


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

/**
  *
  */
macroscript	selection_make_references_each_copy
category:	"_Selection"
buttontext:	"Re-reference"
toolTip:	"Each object will be INDEPENDTENT reference."
--icon:	"#(path, index)"
(
	max create mode

	if selection.count >= 2 then
	(
		--undo "Re-reference Objects" on
		--(
			master_object	= selection[selection.count]

			for_instance = deleteItem ( selection as Array ) selection.count


			for obj in for_instance do
			(
				select #( obj, master_object)

				macros.run "_Selection" "selection_make_references"
			)


		--)

	)
	else
		messageBox "Select at least 2 objects for referencing" title:"Reinstancer"
)

