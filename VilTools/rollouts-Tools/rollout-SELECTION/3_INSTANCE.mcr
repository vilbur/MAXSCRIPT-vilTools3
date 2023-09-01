/*------------------------------------------------------------------------------
	SELECT INTANCES
--------------------------------------------------------------------------------*/

/**
  *
  --*/
macroscript	selection_select_instances
category:	"_Selection"
buttontext:	"Select instances"
toolTip:	"Select instances"
(
	max create mode

	undo "Select instances" on
	(
		max create mode

		for obj in selection do
			selectmore ((Selection_v()).getInstances( obj ) type:#INSTANCE)
	)
)


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

	undo "Select instances and references" on

	for obj in selection do
		selectmore ((Selection_v()).getInstances( obj ))
		--select ((Selection_v()).getInstances( selection[1] ))
)



/*------------------------------------------------------------------------------
	REINSTANCER
--------------------------------------------------------------------------------*/


/**
  *
  */
macroscript	selection_reinstancer
category:	"_Selection-Instance"
buttontext:	"Reinstance"
toolTip:	"Reinstance selection.\n\nMaster object is last object in selection"
icon:	"MENU:true"
autoUndoEnabled: true
(
	on execute do
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

			print "REINSTANCED"
		)
		else
			messageBox "REINSTANCER: SELECT 2 OBJECTS AT LEAST" title:"Reinstancer"

	)

)
