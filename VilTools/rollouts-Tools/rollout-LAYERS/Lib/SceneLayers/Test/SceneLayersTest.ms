clearListener(); print("Cleared in:\n"+getSourceFileName())


filein( getFilenamePath(getSourceFileName()) + "/../../LayersManager/LayersManager.ms" )	--"./../../LayersManager/LayersManager.ms"
filein( getFilenamePath(getSourceFileName()) + "/../SceneLayers.ms" )	--"./../SceneLayers.ms"


/* 
Creates a linear family hierarchy of male members
Each generation has one box object linked to the previous one
*/

function createHierarchy =
(
	grandfather = box name:"Grandfather" pos:(point3 0 0 0)

	father = box name:"Father" pos:(point3 100 0 0)
	father.parent = grandfather

	son = box name:"Son" pos:(point3 200 0 0)
	son.parent = father

	grandson = box name:"Grandson" pos:(point3 300 0 0)
	grandson.parent = son
	
	great_grandson = box name:"Great_Grandson" pos:(point3 400 0 0)
	great_grandson.parent = grandson
	
	grandfather --return
) -- return


delete objects
macros.run "Scene Explorer" "SERemoveEmptyLayers"
macros.run "Scene Explorer" "SELayerExplorer"




SceneLayers 	= SceneLayers_v()
LayersManager = LayersManager_v()

/* CREATE TOP LAYERS */
SceneLayers.createTopLayers()


/*==============================================================================
	
	MANAGE LAYERS
	
================================================================================*/


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

--_box    = Box name:"BoxFooBar"

/* MOVE OBJECT TO lAYER */
--SceneLayers.moveTo #SOURCE $Box*[1]

--/* COPY OBJECT AS REFERENCE TO lAYER */
--SceneLayers.referenceTo #EDIT $Box*[1]
--
----/* COPY OBJECT AS INSTANCE TO lAYER */
--SceneLayers.instanceTo #PRINT $Box*[1]
----
----/* COPY OBJECT TO lAYER */
--SceneLayers.copyTo "FINAL" $Box*[1]
--
--/* SELECT BY lAYER TYPE */
--SceneLayers.selectIn #SOURCE $Box*[1] 
--SceneLayers.selectIn #FINAL $Box*[1] select_more:true

/*==============================================================================
	
	HIEREARCHY TEST
	
================================================================================*/
grandfather = createHierarchy()

SceneLayers.moveTo #SOURCE grandfather

SceneLayers.copyTo #EDIT grandfather

--SceneLayers.InstanceTo #PRINT grandfather
--
--SceneLayers.referenceTo #FINAL grandfather


SceneLayers.selectIn #SOURCE (selection as Array )

/*==============================================================================
	
	GROUP TEST
	
================================================================================*/

/* */
--objs_group = group #( Sphere(), Teapot() ) name:"GROUP-OBJECTS"
----setGroupOpen objs_group true
----setGroupOpen objs_group false
--
--SceneLayers.moveTo #SOURCE $'GROUP-OBJECTS'
--
--SceneLayers.copyTo #EDIT   $'GROUP-OBJECTS*'
----clearListener(); print("Cleared in:\n"+getSourceFileName())
--SceneLayers.moveTo #FINAL $'GROUP-OBJECTS-edit'
--

/*==============================================================================
	
	NESTED GROUP TEST
	
================================================================================*/

--objs_child = group #( Cylinder() ) name:"GROUP-CHILD"
--
--objs_group_parent = group #( objs_child, Tube() ) name:"GROUP-PARENT"
--
--SceneLayers.moveTo #SOURCE $'GROUP-PARENT'
--
--SceneLayers.instanceTo #EDIT $'GROUP-PARENT'
--
--
--SceneLayers.referenceTo #FINAL $'GROUP-PARENT-source'


/*==============================================================================

	POST TEST

================================================================================*/

/* SELECT ALL - help for debug */
--actionMan.executeAction 0 "40021"  -- Selection: Select All









