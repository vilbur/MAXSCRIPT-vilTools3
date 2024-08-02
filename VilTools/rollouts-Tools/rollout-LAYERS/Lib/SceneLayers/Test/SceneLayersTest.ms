clearListener(); print("Cleared in:\n"+getSourceFileName())


filein( getFilenamePath(getSourceFileName()) + "/../../LayersManager/LayersManager.ms" )	--"./../../LayersManager/LayersManager.ms"
filein( getFilenamePath(getSourceFileName()) + "/../SceneLayers.ms" )	--"./../SceneLayers.ms"


delete objects
macros.run "Scene Explorer" "SERemoveEmptyLayers"

_sphere = Sphere()
_box    = Box name:"BoxFooBar"
_teapot = Teapot name:"Teapot"

SceneLayers 	= SceneLayers_v()
LayersManager = LayersManager_v()


/* CREATE TOP LAYERS */
SceneLayers.createTopLayers()


/* MAKE LAYERS HIERARCHY */
top_layer_edit =  LayersManager.findLayer ("EDIT") search_only_top_layers:true

objects_layer = LayersManager.newLayer "Foo-Obejcts"
objects_layer = LayersManager.newLayer "Foo-Obejcts" parent:top_layer_edit


--/* CREATE CUSTOM LAYER FOR OBJECT */
--SceneLayers.moveToLayerType( $Sphere001 ) layer_type:#EDIT
--layer_sphere	= SceneLayers.createLayerByObject( $Sphere* )


/* CREATE CUSTOM LAYER FOR OBJECT */
--layer_box	= SceneLayers.createLayerByObject( $Box* )
--layer_box[1].setParent (objects_layer)



/*------------------------------------------------------------------------------

	MOVE|COPY|INSTANCE|REFERENCE

	layer types "#FINAL" and "#PRINT" DOES NOT USE SUFFIX !

--------------------------------------------------------------------------------*/


/* MOVE OBJECT TO lAYER */
--SceneLayers.moveToLayerType( $Box*[1] )	layer_type:(#SOURCE)


/* COPY OBJECT TO lAYER */
--SceneLayers.moveToLayerType( $'Box*-source' )	layer_type:("FINAL")	mode:#COPY


/* COPY OBJECT AS REFERENCE TO lAYER */
--SceneLayers.moveToLayerType( $Box* )	layer_type:(#EDIT)	mode:#REFERENCE


/* COPY OBJECT AS INSTANCE TO lAYER */
SceneLayers.moveToLayerType( $Box* )	layer_type:(#PRINT)	mode:#INSTANCE


/* GROUP TEST */
--objs_group = group objects name:"GROUP-ALL-OBJECTS"
--setGroupOpen objs_group true


format "layer_edit: %\n" layer_edit


actionMan.executeAction 0 "40021"  -- Selection: Select All


