clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../LayersManager.ms" )	-- "./../LayersManager.ms"


/** Create layers tree
  *
  */
function createLayersTree =
(
	for t = 1 to 4 do
	(
		title_top	= ("Top" + t as string )
		wirecolor = red
		wirecolor.b += (t * 30 ) 
		
		LayerManager.newLayerFromName (title_top)
		top_layer	= LayerManager.getLayerFromName title_top
		top_layer.addNode (Teapot pos:[ (t * 100), 0, 0] name:title_top wirecolor:wirecolor )

		for c = 1 to 3 do
		(
			title_child	= title_top + "Child" + c as string
			wirecolor = green
			wirecolor.r += (t * c * 30 ) 

			LayerManager.newLayerFromName ( title_child );
			child_layer	= LayerManager.getLayerFromName title_child
			child_layer.setParent (top_layer)
			child_layer.addNode (Teapot pos:[ (t * 100), (c * 100), 0] name:title_child wirecolor:wirecolor )

			for n = 1 to 2 do
			(
				wirecolor = blue
				wirecolor.g += (t * c * n *30 ) 
				title_nested	= title_child +"Nested"+ n as string

				--title_nested	= title_child +"Nested"
				LayerManager.newLayerFromName ( title_nested );
				nested_layer	= LayerManager.getLayerFromName title_nested
				nested_layer.setParent (child_layer)

				nested_layer.addNode (Teapot pos:[ (t * 100), ( c * 100),  ( n * 100)] name:title_nested  wirecolor:wirecolor )
			)
		)
	)
)

--/** Prepare scene
--  */
--function prepareScene =
--(
--	resetMaxFile #noPrompt
--
	--LayerManager.editLayerByName ""
--
--	createLayersTree()
--)

/* PREPARE SCENE */
if objects.count == 0 then
(
	--resetMaxFile #noPrompt
	--print "RESET"


	createLayersTree()

	--prepareScene()
	LayerManager.editLayerByName ""

	--holdMaxFile()
)
else
	--fetchMaxFile  quiet:true
	actionMan.executeAction 0 "277"  -- Tools: Unhide All


/* INIT STRUCT */
LayersManager = LayersManager_v()


--format "LayersManager.getCurrent():	% \n" (LayersManager.getCurrent())


/*

   SELECT NODES

*/
clearSelection()
selectmore	$Top1
--selectmore	$Top1Child1
--selectmore	$Top1Child1Nested1

--selectmore	$Top2
--selectmore	$Top2Child2
--selectmore	$Top2Child2Nested2

/*

  GET SELECTED LAYERS

*/

/* GET LAYERS by an type of identifier - integer|string|<MixinInterface:LayerProperties>|ReferenceTarget*/
--for layer in (LayersManager.getLayers#( 0, "Top1", LayerManager.getLayer 1, (LayerManager.getLayer 1).layerAsRefTarg  )) do format "TEST:	% \n" ( classOf layer == MixinInterface)


/* GET SELECTED LAYERS BY OBJECTS */
for layer in (LayersManager.getLayersByObjects( selection )) do format "layer.name:	% \n" layer.name

/* GET SELECTED LAYERS IN MANAGER */
--for layer in (LayersManager.getSelectedByManager()) do format "layer.name:	% \n" layer.name

/* GET SELECTED OR CURRENT LAYER */
--for layer in (LayersManager.getSelectedOrCurrent()) do format "layer.name:	% \n" layer.name

/* GET LAYERS INDEX */
--for id in (LayersManager.getLayersIndex#( 0, "Top1", LayerManager.getLayer 1, (LayerManager.getLayer 1).layerAsRefTarg  )) do format "Layer id:	% \n" id

/* GET ALL CHILDREN LAYERS */
--for layer in (LayersManager.getNestedLayers("Top1")) do format "layer.name:	% \n" layer.name


/*

  MANAGE LAYERS

*/

/* NEW LAYER */
--new_layer = LayersManager.newLayer("New Layer")
--format "new_layer:	% \n" new_layer

/* SELECT LAYER BY LAYERS */
 --LayersManager.selectLayers 2
 --LayersManager.selectLayers "Top1Child1"
 --LayersManager.selectLayers ( LayerManager.getLayer 3)


/* SELECT LAYER BY OBEJCTS */
--LayersManager.selectLayersByObjects #( objects[3] )


/* UNHIDE */
--LayersManager.setVisibility(LayersManager.getAllLayers())(true)


/* HIDE UNSELECTED */
--LayersManager.hideUnselected()
--LayersManager.hideUnselected isolate:true


/* SET CURRENT */
--LayersManager.setCurrent "Top3"

/* SET CURRENT BY SELECTION */
--if LayersManager.isCurrentHidden() then
--	LayersManager.setCurrent #()




/* EXPAND */
--select	$Top1Child1Nested1
--LayersManager.expand(  LayerManager.getLayer 1 )
--LayersManager.expand(  LayerManager.getLayer 1 ) children:true -- expand child layers too
