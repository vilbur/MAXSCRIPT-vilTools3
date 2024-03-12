clearListener(); print("Cleared in:\n"+getSourceFileName())


filein( getFilenamePath(getSourceFileName()) + "/../../LayersManager/LayersManager.ms" )	--"./../../LayersManager/LayersManager.ms"
filein( getFilenamePath(getSourceFileName()) + "/../SceneLayers.ms" )	--"./../SceneLayers.ms"


delete objects
macros.run "Scene Explorer" "SERemoveEmptyLayers"

_sphere = Sphere()
_box = Box()

SceneLayers 	= SceneLayers_v()
LayersManager = LayersManager_v()


/* CRETE TOP LAYERS */
SceneLayers.createTopLayers()


/* MAKE LAYERS HIERARCHY */
--top_layer_edit =  LayersManager.findLayer ("EDIT") search_only_top_layers:true
objects_layer = LayersManager.newLayer "Foo-Obejcts" --parent:top_layer_edit


/* CREATE CUSTOM LAYER FOR OBJECT */
SceneLayers.moveToLayer( $Sphere001 ) #EDIT
layer_sphere	= SceneLayers.moveToLayerByObject( $Sphere001*[1] )



/* CREATE CUSTOM LAYER FOR OBJECT */


--
--layer_box	= SceneLayers.moveToLayerByObject( $Box001 )
--layer_box.setParent (objects_layer)
--
--
--SceneLayers.moveToLayer( $Box001 )(#SOURCE)
--SceneLayers.moveToLayer( $Box001 )(#EDIT) mode:#REFERENCE
--SceneLayers.moveToLayer( $Box001 )("FINAL") mode:#COPY
--

--format "layer_edit: %\n" layer_edit


actionMan.executeAction 0 "40021"  -- Selection: Select All
