/**
 * https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_C1F6495F_5831_4FC8_A00C_667C5F2EAE36_htm
 */
function layerStatesCallback =
(
	print "Start: loadLayerStates()"
	try( callbacks.addScript #filePostOpen "loadLayerStates()" id:#loadLayerStates )catch()
)


/** 
 */
function layerStatesKill =
(
	print "Kill: loadLayerStates()"
	try( callbacks.removeScripts #filePostOpen id:#loadLayerStates )catch()
)


/** 
 */
function loadLayerStates =
(
	print "LayerStatesCallback.msloadLayerStates()"
	format "ROLLOUT_layers.LISTBOX_states.items	= % \n" ROLLOUT_layers.LISTBOX_states.items
	--try
	--(
		
	ROLLOUT_layers.LISTBOX_states.items = (LayerStates_v()).getSceneStates()
	--)
	--catch()
	
)