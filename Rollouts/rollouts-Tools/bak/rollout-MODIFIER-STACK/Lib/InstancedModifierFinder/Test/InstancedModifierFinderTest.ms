clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../ModifyStack.ms" )

/** Load test scene0
  *	
  */
if (scene_name = "ModifiersTestScene.max") != maxFileName then 
	loadMaxFile( getFilenamePath(getSourceFileName()) + "/../../../Test/" + scene_name )

 
obj = objects[1]

edit_poly_indexes = (ModifyStack_v nodes: #(obj) ).getIndexesOfInstances ( Edit_Poly );
unwrap_indexes    = (ModifyStack_v nodes: #(obj) ).getIndexesOfInstances ( Unwrap_UVW )

format "edit_poly_indexes	= % \n" edit_poly_indexes
format "unwrap_indexes	= % \n" unwrap_indexes
