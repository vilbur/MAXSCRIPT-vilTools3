

/**
 * https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_C1F6495F_5831_4FC8_A00C_667C5F2EAE36_htm
 */
function openUnwrapEditorEvent =
(
	print "Start: openUnwrapEditor()"
	try( callbacks.addScript #modPanelObjPostChange "openUnwrapEditor()" id:#openUnwrapEditor )catch()
)


/** 
 */
function openUnwrapEditorKill =
(
	print "Kill: openUnwrapEditor()"
	try( callbacks.removeScripts #modPanelObjPostChange id:#openUnwrapEditor )catch()
)


/** 
 */
function openUnwrapEditor =
(
	print "openUnwrapEditor()"
	 --_mod	= modPanel.getCurrentObject()
	 
	if( classOf ( _mod = modPanel.getCurrentObject() ) == Unwrap_UVW ) then
		_mod.edit ()
	
)
