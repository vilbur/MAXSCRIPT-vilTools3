filein( getFilenamePath(getSourceFileName()) + "/../../ExportNode/ExportNode.ms" )	--"./../../ExportNode/ExportNode.ms"
filein( getFilenamePath(getSourceFileName()) + "/../NodeList.ms" )	-- "./../NodeList.ms"

clearListener()

delete objects


pos_A = [0, 0,0]
pos_B = [0, 110,0]
pos_C = [0, 200,0]

--node_A = Export_node name:"Node A"  text:"Node A" pos:pos_A
--node_B = Export_node name:"Node B"  text:"Node B" pos:pos_B
--node_C = Export_node name:"Node C"  text:"Node C" pos:pos_C
--
--
--LayerManager.newLayerFromName "Layer A"
--layer_A = LayerManager.getLayerFromName "Layer A"
--
--LayerManager.newLayerFromName "Layer B"
--layer_B = LayerManager.getLayerFromName "Layer B"
--
--LayerManager.newLayerFromName "Layer C"
--layer_C = LayerManager.getLayerFromName "Layer C"
--
---- NodeList 	= NodeList_v(ROLLOUT_export.ML_nodes)
--
--_Box	= Box	pos:pos_A parent:node_A
--_Sphere	= Sphere	pos:pos_B parent:node_B
--_Teapot	= Teapot	pos:pos_C parent:node_C
--
--layer_A.addNodes #(node_A, _Box)
--layer_B.addNodes #(node_B, _Sphere)
--layer_C.addNodes #(_Teapot)


_Box	= Box	pos:pos_A
_Sphere	= Sphere	pos:pos_B
_Teapot	= Teapot	pos:pos_C


select _Box
-- selectmore	node_C

ExportNode = (ExportNode_v()).create()

-- nodes_in_scene = NodeList.getNodesInScene()
-- format "nodes_in_scene	= % \n" nodes_in_scene


-- nodes_selected_in_scene = NodeList.getSelectedNodesInScene()
-- format "nodes_selected_in_scene	= % \n" nodes_selected_in_scene
