/**
 * 
 */
function setModelingMaterialCallback =
(
	print "Start: setModelingMaterial()"
	try( callbacks.addScript	#selectionSetChanged "setModelingMaterial()"	id:#setModelingMaterial )catch()
)


/** 
 */
function setModelingMaterialKill =
(
	print "Kill: setModelingMaterial()"
	try( callbacks.removeScripts #selectionSetChanged	id:#setModelingMaterial )catch()
)


/** 
 */
function setModelingMaterial =
(
	print "setModelingMaterial()"
format "GLOBAL_SELECTION_LAST = % \n" GLOBAL_SELECTION_LAST
	
)