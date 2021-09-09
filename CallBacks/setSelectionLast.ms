global GLOBAL_SELECTION_LAST
global GLOBAL_SELECTION_LAST_BUFFER

/** Set last selected objects to variable
 */
function setSelectionLast =
(
	print "setSelectionLast"
	if( selection.count > 0 ) then
	(
		GLOBAL_SELECTION_LAST = GLOBAL_SELECTION_LAST_BUFFER

		GLOBAL_SELECTION_LAST_BUFFER = for o in selection collect o
	)
	else	
	format "GLOBAL_SELECTION_MODIFIERS = % \n" GLOBAL_SELECTION_MODIFIERS
)


callbacks.addScript #selectionSetChanged "setSelectionLast()" id:#setSelectionLast
