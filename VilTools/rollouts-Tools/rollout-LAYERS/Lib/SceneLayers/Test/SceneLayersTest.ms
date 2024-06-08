clearListener(); print("Cleared in:\n"+getSourceFileName())


filein( getFilenamePath(getSourceFileName()) + "/../../LayersManager/LayersManager.ms" )	--"./../../LayersManager/LayersManager.ms"
filein( getFilenamePath(getSourceFileName()) + "/../SceneLayers.ms" )	--"./../SceneLayers.ms"


delete objects
macros.run "Scene Explorer" "SERemoveEmptyLayers"

--_sphere = Sphere()

_box = Box name:"BoxFooBar"

SceneLayers 	= SceneLayers_v()
LayersManager = LayersManager_v()


/* CRETE TOP LAYERS */
--SceneLayers.createTopLayers()


/* MAKE LAYERS HIERARCHY */
top_layer_edit =  LayersManager.findLayer ("EDIT") search_only_top_layers:true

objects_layer = LayersManager.newLayer "Foo-Obejcts"
--objects_layer = LayersManager.newLayer "Foo-Obejcts" parent:top_layer_edit


/* CREATE CUSTOM LAYER FOR OBJECT */
--SceneLayers.moveToLayerType( $Sphere001 ) layer_type:#EDIT
--layer_sphere	= SceneLayers.moveToLayerByObject( $Sphere* )


/* CREATE CUSTOM LAYER FOR OBJECT */
layer_box	= SceneLayers.moveToLayerByObject( $Box* )
layer_box[1].setParent (objects_layer)


SceneLayers.moveToLayerType( $Box*[1] )	layer_type:(#SOURCE)
SceneLayers.moveToLayerType( $Box* )	layer_type:(#EDIT)	mode:#REFERENCE
SceneLayers.moveToLayerType( $'Box*-source' )	layer_type:("FINAL")	mode:#COPY


format "layer_edit: %\n" layer_edit


actionMan.executeAction 0 "40021"  -- Selection: Select All
