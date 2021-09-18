/**
 * https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_C1F6495F_5831_4FC8_A00C_667C5F2EAE36_htm
 */
function onSelectionMaxModifyModeCallback =
(
	print "Start: onSelectionMaxModifyMode()"
	try( callbacks.addScript	#selectionSetChanged "onSelectionMaxModifyMode()"	id:#onSelectionMaxModifyMode )catch()
)


/** 
 */
function onSelectionMaxModifyModeKill =
(
	print "Kill: onSelectionMaxModifyMode()"
	try( callbacks.removeScripts #selectionSetChanged	id:#onSelectionMaxModifyMode )catch()
)


/** 
 */
function onSelectionMaxModifyMode =
(
	--print "onSelectionMaxModifyMode()"
	if( selection.count > 0 ) then
		max modify mode
	
)