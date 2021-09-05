global GLOBAL_SELECTION_LAST

/** Get last selected nodes
 */
function setLastSelectedNodes =
(
	--print "setLastSelectedNodes()"
	--print GLOBAL_SELECTION_LAST as string
	if( selection.count > 0 ) then 
		GLOBAL_SELECTION_LAST = for o in selection collect o
	--else	
	--format "GLOBAL_SELECTION_LAST = % \n" GLOBAL_SELECTION_LAST
)
