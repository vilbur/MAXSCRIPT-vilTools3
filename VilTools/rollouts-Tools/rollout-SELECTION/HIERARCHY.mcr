/*
*/
macroscript	selection_link_to_last
category:	"_Selection-Hierarchy"
buttontext:	"Link to last"
tooltip:	"Link to last selected object"
icon:	"MENU:true"
autoUndoEnabled: true
(
	on execute do
		if selection.count > 1 then
		(
			_selection = for o in selection collect o

			parent_obj = _selection[_selection.count]

			children = deleteItem _selection _selection.count

			for child_obj in children do
			(
				if parent_obj.parent == child_obj then
					parent_obj.parent = undefined

				child_obj.parent = parent_obj
			)
		)
		else
			print "SELECT 2 OBJECTS - LAST OBJECT IS PARENT"

)


/*
*/
macroscript	selection_link_selection_chain
category:	"_Selection-Hierarchy"
buttontext:	"Link Chain"
tooltip:	"Link multiple selected objects to chain.\n\nFIRST OBJECT IS CHILDREN\nLAST OBJECT IS PARENT"
icon:	"MENU:true"
autoUndoEnabled: true
(
	on execute do
		if selection.count >= 2 then
		(
			--_selection = for o in selection collect o

			for i = 1 to selection.count - 1 do
			(
				child_obj	= selection[i]
				parent_obj	= selection[i + 1]

				if parent_obj.parent == child_obj then
					parent_obj.parent = undefined

				child_obj.parent = parent_obj
			)

		)
		else
			print "SELECT 2 OBJECTS - LAST OBJECT IS PARENT"

)
