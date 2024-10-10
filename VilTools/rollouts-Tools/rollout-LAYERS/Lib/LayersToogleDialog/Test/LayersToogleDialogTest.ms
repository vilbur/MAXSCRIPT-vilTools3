clearListener(); print("Cleared in:"+getSourceFileName())


filein( getFilenamePath(getSourceFileName()) + "/../../../../../../../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms" )	-- "./../../../../../../../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../LayersManager/LayersManager.ms" )	-- "./../../LayersManager/LayersManager.ms"
filein( getFilenamePath(getSourceFileName()) + "/../LayersToogleDialog.ms" )	-- "./../LayersToogleDialog.ms"


/** Create layers tree
  *
  */
function createObjectsAndLayers =
(
	box() -- object in default layer

	for t = 1 to 4 do
	(
		title_top	= ("Top" + t as string )
		LayerManager.newLayerFromName (title_top)
		top_layer	= LayerManager.getLayerFromName title_top
		top_layer.addNode (Teapot pos:[ (t * 100), 0, 0] name:title_top wirecolor:red )

		for c = 1 to 3 do
		(
			title_child	= "Child" + c as string + "-" + title_top

			LayerManager.newLayerFromName ( title_child );
			child_layer	= LayerManager.getLayerFromName title_child
			child_layer.setParent (top_layer)
			child_layer.addNode (Teapot pos:[ (t * 100), (c * 100), 0] name:title_child wirecolor:green )

			for n = 1 to 2 do
			(
				title_nested	= "Nested"+ n as string + "-" + title_top

				--title_nested	= title_child +"Nested"
				LayerManager.newLayerFromName ( title_nested );
				nested_layer	= LayerManager.getLayerFromName title_nested
				nested_layer.setParent (child_layer)

				nested_layer.addNode (Teapot pos:[ (t * 100), ( c * 100),  ( n * 100)] name:title_nested  wirecolor:blue)
			)
		)
	)
)



/** Create new test scene
 */
function createNewTestScene =
(
	/** Prepare scene
	  */
	function prepareScene =
	(
		if objects.count == 0 then
		(
			resetMaxFile #noPrompt

			createObjectsAndLayers()

			LayerManager.editLayerByName ""
		)
		else
		(
			--fetchMaxFile  quiet:true
			actionMan.executeAction 0 "277"  -- Tools: Unhide All

			clearSelection
		)
	)

	prepareScene()

	/* DELETE ALL LAYERS */
	 delete objects
	 LayersManager = LayersManager_v()
	 LayersManager.deleteLayers( LayersManager.getAllLayers() )


	/* CREATE LAYERS */
	 createObjectsAndLayers()


   /* SELECT OBJECT OF LAYERS TO SHOW */
	 selectmore	$box*

	 selectmore	$Top1

    selectmore	$Child1*

    selectmore	$Nested*
)


/* PREPARE SCENE */

if objects.count == 0 then
createNewTestScene()

/*==============================================================================
	RUN TEST
================================================================================*/

--LayersManager = LayersManager_v()

LAYERS_TOOGLE_DIALOG = LayersToogleDialog_v()


LAYERS_TOOGLE_DIALOG.create reset_layers:true