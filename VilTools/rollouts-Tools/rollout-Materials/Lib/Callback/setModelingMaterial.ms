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
	clearListener()
	print"\n"
	

	
		print "RESET last material to last selection"
	format "GLOBAL_SELECTION_LAST.count = % \n" GLOBAL_SELECTION_LAST.count
	
	for i = 1 to GLOBAL_SELECTION_LAST.count do
		if( MATERIAL_STORE[i] != undefined ) then
			GLOBAL_SELECTION_LAST[i].material = MATERIAL_STORE[i]
	

	
		print "SET modeling material to "
		--for i = 1 to selection.count do
		--(
		--	
		--	selection[i].material
		--	
		--)
	
	MATERIAL_STORE =  for o in selection  collect o.material 
	
		mat = StandardMaterial glossiness:0 specularLevel:0

	selection.material = mat

	
	--setSelectionLastKill()
	--setSelectionLast()
	--setSelectionLastCallback()
	
	
	--MODELING_MATERIAL_SOTRE[1] =  for o in selection  collect o 
		
	
	
	
	format "GLOBAL_SELECTION_LAST = % \n" GLOBAL_SELECTION_LAST
	format "MATERIAL_STORE = % \n" MATERIAL_STORE
	
)