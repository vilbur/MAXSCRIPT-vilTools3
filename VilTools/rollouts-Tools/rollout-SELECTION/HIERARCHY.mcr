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

			parent_object = _selection[_selection.count]

			children = deleteItem _selection _selection.count

			for child in children do
				child.parent = parent_object
		)
		else
			print "SELECT 2 OBJECTS - LAST OBJECT IS PARENT"

)
