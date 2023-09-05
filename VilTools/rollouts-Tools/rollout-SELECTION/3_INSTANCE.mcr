/*------------------------------------------------------------------------------
	SELECT INTANCES
--------------------------------------------------------------------------------*/

/** SELCT ONLY INSTANCES
  */
macroscript	selection_select_instances
category:	"_Selection"
buttontext:	"Select instances"
toolTip:	"Select instances"
autoUndoEnabled: true
(
	on execute do
	(
		max create mode

		_Selection = Selection_v()

		_selection = for o in selection collect o

		format "_selection.count:	% \n" _selection.count
		for obj in _selection do
			selection_new = _Selection.getInstances( obj )

		format "selection_new.count:	% \n" _selection.count

		if _selection.count == selection_new.count then
			selection_new = _Selection.filterUniqueObjects( _selection )


		format "selection_new.count:	% \n" _selection.count

		select selection_new
	)
)


/** SELECT INSTANCES AND REFERENCES
  */
macroscript	selection_select_instances_and_references
category:	"_Selection"
buttontext:	"Select instances"
toolTip:	"Select instances and references"
autoUndoEnabled: true
(
	on execute do
	(
		clearListener(); print("Cleared in:"+getSourceFileName())


		function compareArrays array1 array2 = ( (with printAllElements on array1) as string == (with printAllElements on array2) as string )

		max create mode

		_Selection = Selection_v()

		_selection_old = for o in selection collect o

		instances_all = _Selection.getInstances( _selection_old ) type:#ALL

		instances_only = _Selection.getInstances( instances_all ) type:#INSTANCE

		references = _Selection.getInstances( _selection_old ) type:#REFERENCE

		unique_objects = _Selection.filterUniqueObjects( instances_all )

		format "_selection_old.count:	% \n" _selection_old.count
		format "instances_all.count:	% \n" instances_all.count
		format "instances_only.count:	% \n" instances_only.count
		format "references.count:	% \n" references.count



		instances_all_selected	= compareArrays _selection_old instances_all
		instances_only_selected	= compareArrays _selection_old instances_only
		references_selected	= compareArrays _selection_old references
		unique_selected	= compareArrays _selection_old unique_objects

		format "\n"
		format "instances_all_selected:	% \n" instances_all_selected
		format "instances_only_selected:	% \n" instances_only_selected
		format "references_selected:	% \n" references_selected
		format "unique_selected:	% \n" unique_selected


		selection_new = case of
		(
			(unique_selected):	instances_all
			(instances_all_selected):	instances_only
			(instances_only_selected):	references
			--(references_selected):	unique_objects
			default:	unique_objects
		)
		format "selection_new:	% \n" selection_new
		if selection_new != undefined then
		select selection_new
	)
)



/*------------------------------------------------------------------------------
	REINSTANCER
--------------------------------------------------------------------------------*/


/**
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
