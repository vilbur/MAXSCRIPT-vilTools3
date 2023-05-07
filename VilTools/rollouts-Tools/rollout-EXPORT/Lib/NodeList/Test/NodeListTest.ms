filein( getFilenamePath(getSourceFileName()) + "/../NodeList.ms" )	-- "./../NodeList.ms"

clearListener()

delete objects



node_A = Export_node name:"Node A"  text:"Node A" pos:[0, 0,0]
node_B = Export_node name:"Node B"  text:"Node B" pos:[0, 100,0]
node_C = Export_node name:"Node C"  text:"Node C" pos:[0, 200,0]


-- NodeList 	= NodeList_v(ROLLOUT_export.ML_nodes)


-- select	node_A
-- selectmore	node_C


-- nodes_in_scene = NodeList.getNodesInScene()
-- format "nodes_in_scene	= % \n" nodes_in_scene


-- nodes_selected_in_scene = NodeList.getSelectedNodesInScene()
-- format "nodes_selected_in_scene	= % \n" nodes_selected_in_scene
