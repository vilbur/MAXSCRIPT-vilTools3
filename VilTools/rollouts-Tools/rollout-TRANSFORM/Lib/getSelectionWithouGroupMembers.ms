/** Get selection without members of closed group
 */
function getSelectionWithouGroupMembers =
(
	mapped function getAllChildren node &children = (if isValidNode node and isKindOf children Array do join children node.children)

	children = #()

	groups_closed = for o in ( _selection = selection as Array ) where isGroupHead o and isOpenGroupHead o == false and findItem _selection o.parent == 0 collect o

	getAllChildren groups_closed &children

	for o in selection where findItem children o == 0 collect o --return
)
