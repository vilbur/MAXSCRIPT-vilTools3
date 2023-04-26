macroscript selection_boolean_union
category:	"_Selection"
buttonText:	"Boolean Union"
tooltip:	"Save selection"
(

	undo "Boolean union from selection" on
	(
			max create mode

			_selection = selection as array

			if _selection.count >= 2 then
			(
				source_obj = _selection[1]

				convertTo source_obj Editable_Poly

				add_objects = deleteItem _selection 1

				ProBoolean.createBooleanObjects source_obj #() 0 2 0

				print ("START OF ADDING "+ add_objects.count as string +" BOOLEAN OBEJTCS")

				for i = 1 to add_objects.count do
				(
					format "Adding Operand %: % of % \n" i add_objects[i].name add_objects.count

					convertTo add_objects[i] Editable_Poly

					ProBoolean.SetOperandB source_obj add_objects[i] 2 0
				)


				--convertTo source_obj Editable_Poly

				print "BOOLEAN FINISHED !"

				select source_obj
			)
	)



)
