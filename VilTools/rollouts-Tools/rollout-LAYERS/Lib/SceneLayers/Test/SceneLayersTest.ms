clearListener(); print("Cleared in:\n"+getSourceFileName())


filein( getFilenamePath(getSourceFileName()) + "/../../LayersManager/LayersManager.ms" )	--"./../../LayersManager/LayersManager.ms"
filein( getFilenamePath(getSourceFileName()) + "/../SceneLayers.ms" )	--"./../SceneLayers.ms"


delete objects
macros.run "Scene Explorer" "SERemoveEmptyLayers"
macros.run "Scene Explorer" "SELayerExplorer"

_box    = Box name:"BoxFooBar"

SceneLayers 	= SceneLayers_v()
LayersManager = LayersManager_v()






/*==============================================================================
	
	MANAGE LAYERS
	
================================================================================*/

/* CREATE TOP LAYERS */
SceneLayers.createTopLayers()


/* FIND LAYERS */
--top_layer_edit =  LayersManager.findLayer ("EDIT") search_only_top_layers:true

/* NEW LAYER */ 
--objects_layer = LayersManager.newLayer "Foo-Obejcts"
--objects_layer = LayersManager.newLayer "Foo-Obejcts" parent:(LayersManager.findLayer ("EDIT"))

/* MOVE TO LAYER OF TYPE */ 
--SceneLayers.moveTo #EDIT $Sphere001

/* CREATE CUSTOM LAYER FOR OBJECT */
--layer_sphere	= SceneLayers.createLayerByObject $Sphere*

/* CREATE CUSTOM LAYER FOR OBJECT */
--layer_box	= SceneLayers.createLayerByObject $Box*
--layer_box[1].setParent objects_layer



/*==============================================================================
	
	MOVE|COPY|INSTANCE|REFERENCE

	layer types "#FINAL" and "#PRINT" DOES NOT USE SUFFIX !
	
================================================================================*/

/* MOVE OBJECT TO lAYER */
--SceneLayers.moveTo #SOURCE $Box*[1]

/* COPY OBJECT AS REFERENCE TO lAYER */
--SceneLayers.moveTo #EDIT $Box*[1] mode:#REFERENCE


/* COPY OBJECT AS INSTANCE TO lAYER */
--SceneLayers.moveTo #PRINT $Box*[1]	mode:#INSTANCE

/* COPY OBJECT TO lAYER */
--SceneLayers.moveTo "FINAL" ( $'Box*' )	mode:#COPY

/* SELECT BY lAYER TYPE */
--SceneLayers.selectIn #SOURCE $Box*[1] 
--SceneLayers.selectIn #FINAL $Box*[1] select_more:true

/*==============================================================================
	
	GROUP TEST
	
================================================================================*/

/* */
----objs_group = group objects name:"GROUP-ALL-OBJECTS"
objs_group = group #( Sphere(), Teapot() ) name:"GROUP-OBJECTS"
--setGroupOpen objs_group true

SceneLayers.moveTo #SOURCE $'GROUP-OBJECTS'

--format "layer_edit: %\n" layer_edit

/* SELECT ALL - help for debug */
--actionMan.executeAction 0 "40021"  -- Selection: Select All




