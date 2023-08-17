clearListener(); print("Cleared in:"+getSourceFileName())


filein( getFilenamePath(getSourceFileName()) + "/../../../../../../../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms" )	-- "./../../../../../../../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../LayersManager/LayersManager.ms" )	-- "./../../LayersManager/LayersManager.ms"
filein( getFilenamePath(getSourceFileName()) + "/../LayersToogleDialog.ms" )	-- "./../LayersToogleDialog.ms"


/** Create layers tree
  *
  */
function createLayersTree =
(
	for t = 1 to 4 do
	(
		title_top	= ("Top" + t as string )
		top_layer	= LayersManager.newLayer(title_top)
		top_layer.addNode (Teapot pos:[ (t * 100), 0, 0] name:title_top wirecolor:red )

		for c = 1 to 3 do
		(
			title_child	= title_top + "Child" + c as string
			child_layer	= LayersManager.newLayer ( title_child ) parent:top_layer
			child_layer.addNode (Teapot pos:[ (t * 100), (c * 100), 0] name:title_child wirecolor:green )

			for n = 1 to 2 do
			(
				title_nested	= title_child +"Nested"+ n as string
				--title_nested	= "Nested-"+ n as string + title_child

				nested_layer = LayersManager.newLayer (title_nested) parent:child_layer

				nested_layer.addNode (Teapot pos:[ (t * 100), ( c * 100),  ( n * 100)] name:title_nested  wirecolor:blue)

			)
		)
	)
)


delete objects


LayersManager = LayersManager_v()

LayersManager.deleteLayers( LayersManager.getAllLayers() )

createLayersTree()


selectmore	$Top1
--selectmore	$Top1Child1
--selectmore	$Top1Child1Nested1
--
--selectmore	$Top2
--selectmore	$Top2Child2
selectmore	$Top2Child2Nested2


LayersToogleDialog = LayersToogleDialog_v()


LayersToogleDialog.create reset_layers:true
