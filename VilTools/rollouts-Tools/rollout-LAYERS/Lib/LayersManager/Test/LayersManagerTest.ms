clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../LayersManager.ms" )	-- "./../LayersManager.ms"



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

			for n = 1 to 3 do
			(
				nesetd_layer = LayersManager.newLayer ("Nested Layer"  + t as string + " " + s as string + " " + s as string  ) parent:child_layer
			)

		)
	)
)

delete objects

LayersManager.deleteLayers( LayersManager.getAllLayers() )


createLayersTree()