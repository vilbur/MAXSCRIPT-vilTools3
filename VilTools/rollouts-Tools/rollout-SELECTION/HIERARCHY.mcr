/*
*/
macroscript	selection_link_selection_chain
category:	"_Selection-Hierarchy"
buttontext:	"Link Chain"
tooltip:	"Link multiple selected objects to chain.\n\nFIRST OBJECT IS CHILDREN\nLAST OBJECT IS PARENT"
icon:	"MENU:true"
autoUndoEnabled: true
(

	/** Link all to last selected object
	 */
	function linkAllToLastSelectedObject =
	(
		--format "\n"; print ".linkAllToLastSelectedObject()"
		_selection = for o in selection collect o

		parent_object = _selection[_selection.count]

		children = deleteItem _selection _selection.count

		for child in children do
			child.parent = parent_object
)

	on execute do
		if selection.count >= 2 then
		(
			--_selection = for o in selection collect o

			for i = 1 to selection.count - 1 do
				selection[i].parent = selection[i + 1]

		)
		else
			print "SELECT 2 OBJECTS - LAST OBJECT IS PARENT"

)
