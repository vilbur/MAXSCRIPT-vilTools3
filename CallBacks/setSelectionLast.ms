global GLOBAL_SELECTION_LAST

/** Get last selected nodes
 */
function setSelectionLast =
(
	--print "setLastSelectedNodes()"
	--print GLOBAL_SELECTION_LAST as string
	if( selection.count > 0 ) then
	(
		GLOBAL_SELECTION_LAST = for o in selection collect o
	)
	else	
	format "GLOBAL_SELECTION_MODIFIERS = % \n" GLOBAL_SELECTION_MODIFIERS
)


try( callbacks.addScript callback_type_name callback id:callback )catch()