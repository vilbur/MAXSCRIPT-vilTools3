/**
 * 
 */
function setModelingMaterialCallback =
(
	--print "Start: setModelingMaterial()"
	try( callbacks.addScript #selectionSetChanged "setModelingMaterial()"	id:#setModelingMaterial )catch()
)


/** 
 */
function setModelingMaterialKill =
(
	--print "Kill: setModelingMaterial()"
	try( callbacks.removeScripts #selectionSetChanged	id:#setModelingMaterial )catch()
)


/** 
 */
function setModelingMaterial =
(
	--print "setModelingMaterial()"

	for i = 1 to GLOBAL_SELECTION_LAST.count where superClassof GLOBAL_SELECTION_LAST[i] == GeometryClass  do
		if( MODELING_MATERIAL_STORE[i] != undefined )
		then
			GLOBAL_SELECTION_LAST[i].material = MODELING_MATERIAL_STORE[i]
		else
			GLOBAL_SELECTION_LAST[i].material = undefined

	MODELING_MATERIAL_STORE =  for o in selection where superClassof o == GeometryClass collect o.material 

	selection.material = (StandardMaterial glossiness:0 specularLevel:0 diffuse:(color 255 190 200) )
)