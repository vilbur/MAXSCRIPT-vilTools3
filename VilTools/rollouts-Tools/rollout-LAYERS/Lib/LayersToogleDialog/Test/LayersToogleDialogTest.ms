clearListener(); print("Cleared in:"+getSourceFileName())


filein( getFilenamePath(getSourceFileName()) + "/../../../../../../../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms" )	-- "./../../../../../../../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../LayersManager/LayersManager.ms" )	-- "./../../LayersManager/LayersManager.ms"
filein( getFilenamePath(getSourceFileName()) + "/../LayersToogleDialog.ms" )	-- "./../LayersToogleDialog.ms"


/*------------------------------------------------------------------------------

	PREAPTE LAYERS TREE

--------------------------------------------------------------------------------*/
LayersManager = LayersManager_v()

/** Create layers tree
  *
  */
function createLayersTree =
(
	for t = 1 to 3 do
	(
		top_layer = LayersManager.newLayer ("Top Layer" + t as string )

		for s = 1 to 2 do
		(
			child_layer = LayersManager.newLayer ("Child Layer"  + t as string + " " + s as string ) parent:top_layer

			child_layer.addNode (Teapot pos:[ (s * 100), ( t * 100), 0] )

			--for n = 1 to 3 do
			--(
				nesetd_layer = LayersManager.newLayer ("Nested Layer"  + t as string + " " + s as string + " " + s as string  ) parent:child_layer
			--)

		)
	)
)


delete objects

LayersManager.deleteLayers( LayersManager.getAllLayers() )
createLayersTree()


/*------------------------------------------------------------------------------

	TEST DIALOG

------------------------------------------------------------------------------*/

select	objects[ 1 ]
--selectmore	objects[ 5 ]

select objects

LayersToogleDialog = LayersToogleDialog_v()


LayersToogleDialog.resetSelectedLayers()


LayersToogleDialog.create()

