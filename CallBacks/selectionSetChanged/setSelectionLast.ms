

global GLOBAL_SELECTION_LAST_ENABLED = true
global GLOBAL_SELECTION_LAST 
global GLOBAL_SELECTION_LAST_BUFFER


/**
 * 
 */
function setSelectionLastCallback =
(
	print "Start: setSelectionLast()"
	try( callbacks.addScript #selectionSetChanged "setSelectionLast()"	id:#setSelectionLast )catch()
)


/** 
 */
function setSelectionLastKill =
(
	print "Kill: setSelectionLast()"
	try( callbacks.removeScripts #selectionSetChanged	 id:#setSelectionLast )catch()
)




/** Set last selected objects to variable
 */
function setSelectionLast =
(
	if GLOBAL_SELECTION_LAST_ENABLED then
	(
		print "setSelectionLast()"
		GLOBAL_SELECTION_LAST = GLOBAL_SELECTION_LAST_BUFFER
	
		if( selection.count > 0 ) then
			GLOBAL_SELECTION_LAST_BUFFER = for o in selection collect o
			
		--format "GLOBAL_SELECTION_LAST = % \n" GLOBAL_SELECTION_LAST
	)
)


setSelectionLastCallback()