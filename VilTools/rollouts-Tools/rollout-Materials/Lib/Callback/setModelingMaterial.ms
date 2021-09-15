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
	print "setModelingMaterial()"
	format "MODELING_MATERIAL_STORE = % \n" MODELING_MATERIAL_STORE
	
	_selection =  for o in selection where superClassof o == GeometryClass collect o 

	/** RESTORE ORIGINAL MATERIAL 
	 *	
	 */
	for i = 1 to GLOBAL_SELECTION_LAST.count where superClassof GLOBAL_SELECTION_LAST[i] == GeometryClass and findItem _selection GLOBAL_SELECTION_LAST[i] == 0 do
		if( MODELING_MATERIAL_STORE[i] != undefined )then
		(
			if( classOf  MODELING_MATERIAL_STORE[i] != Color ) then 
				GLOBAL_SELECTION_LAST[i].material = MODELING_MATERIAL_STORE[i]
			else
				GLOBAL_SELECTION_LAST[i].material = undefined
		)
		

	/** SAVE MATERIALS OF CURRENT SELECTION 
	 *	
	 */	
	selection_materials	= #()
	
	for obj in _selection do 
		if( (mat_index = findItem GLOBAL_SELECTION_LAST obj) > 0 and MODELING_MATERIAL_STORE[mat_index] != undefined ) then
			append selection_materials MODELING_MATERIAL_STORE[mat_index] -- get material from store
		else
		(
			if( obj.material != undefined ) then
				append selection_materials obj.material
			
			else
				append selection_materials obj.wirecolor
		)
	
	
	MODELING_MATERIAL_STORE =  selection_materials
	
	--format "MODELING_MATERIAL_STORE = % \n" MODELING_MATERIAL_STORE
	selection.material = (StandardMaterial glossiness:0 specularLevel:0 diffuse:(color 190 190 200) )
)