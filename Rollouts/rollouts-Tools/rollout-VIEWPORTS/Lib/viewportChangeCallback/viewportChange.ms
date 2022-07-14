/**
 * https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_C1F6495F_5831_4FC8_A00C_667C5F2EAE36_htm
 */
function viewportChangeCallback =
(
	print "Start: viewportChange()"
	try( callbacks.addScript #viewportChange "rotateTopView()"	id:#viewportChange )catch()
)


/** 
 */
function viewportChangeKill =
(
	print "Kill: viewportChange()"
	try( callbacks.removeScripts #viewportChange	id:#viewportChange )catch()
)


/** 
 */
function rotateTopView =
(
	print "rotateTopView()"
	current_view = viewport.getType()
	
	
	if current_view == #view_top or current_view == #view_bottom then
	(
		viewport.rotate (quat 0 0 -1 1)	
		completeredraw()
	)	
)