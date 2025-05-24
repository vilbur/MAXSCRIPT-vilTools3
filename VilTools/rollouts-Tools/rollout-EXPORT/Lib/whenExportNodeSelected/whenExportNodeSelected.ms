global WHEN_EXPORT_NODE_SELECTED = #()

/** When attribute change https://help.autodesk.com/view/MAXDEV/2024/ENU/?guid=GUID-513285B3-DBF6-471E-B587-B5BE14D4D875
 * 
 *  whenExportNodeSelected( selection as Array )
 * 
 */
function whenExportNodeSelected objs =
(
	 --format "\n"; print "whenExportNodeSelected()"

	if classOf objs == Array then
		join WHEN_EXPORT_NODE_SELECTED objs

	else
		append WHEN_EXPORT_NODE_SELECTED objs

	deleteAllChangeHandlers id:#WHEN_EXPORT_NODE_SELECTED

	
	WHEN_EXPORT_NODE_SELECTED = makeUniqueArray WHEN_EXPORT_NODE_SELECTED
	
	WHEN_EXPORT_NODE_SELECTED = for export_node in WHEN_EXPORT_NODE_SELECTED where isValidNode export_node collect export_node

	--format "WHEN_EXPORT_NODE_SELECTED.count: %\n" WHEN_EXPORT_NODE_SELECTED.count
	
	when select WHEN_EXPORT_NODE_SELECTED changes id:#WHEN_EXPORT_NODE_SELECTED obj do
	(

		if obj.isSelected then
		(
			format "WHEN_EXPORT_NODE_SELECTED: %\n" obj
			
			NodeList = NodeList_v(ROLLOUT_export.ML_nodes)
			
			/* GET SELECTED NODES IN SCENE */ 
			selected_nodes = NodeList.getSelectedNodesInScene()
			--format "selected_nodes: %\n" selected_nodes
			/* SELECT ITEMS IN LIST */ 
			NodeList.selectNodesInList(selected_nodes)
			
			ROLLOUT_export.BP_export_path.text = NodeList.getExportPathText(selected_nodes)
	
			ROLLOUT_export.ML_node_groups.items = sort (makeUniqueArray(for obj in shapes where classOf obj == Export_Node and obj.parent != undefined and isGroupHead obj.parent collect obj.parent.name))
		)
		else
			ROLLOUT_export.BP_export_path.text = ""
	)
)


/** Start events
 */
function whenExportNodeSelectedStart =
(
	-- format "\n"; print whenExportNodeSelectedStart()"
	whenExportNodeSelected(WHEN_EXPORT_NODE_SELECTED)
)

/** Stop events
 */
function whenExportNodeSelectedStop =
(
	-- format "\n"; print whenExportNodeSelectedStop()"
	deleteAllChangeHandlers id:#WHEN_EXPORT_NODE_SELECTED
)