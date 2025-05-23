global WHEN_EXPORT_NODE_SELECTED = #()

/** When attribute change https://help.autodesk.com/view/MAXDEV/2024/ENU/?guid=GUID-513285B3-DBF6-471E-B587-B5BE14D4D875
 * 
 *  whenExportNodeSelected( selection as Array )
 * 
 */
function whenExportNodeSelected objs =
(
	-- format "\n"; print whenExportNodeSelected()"

	if classOf objs == Array then
		join WHEN_EXPORT_NODE_SELECTED objs

	else
		append WHEN_EXPORT_NODE_SELECTED objs

	deleteAllChangeHandlers id:#WHEN_EXPORT_NODE_SELECTED

	when select WHEN_EXPORT_NODE_SELECTED changes id:#WHEN_EXPORT_NODE_SELECTED obj do
	(
		--format "WHEN_EXPORT_NODE_SELECTED: %\n" obj

		if obj.isSelected then
		(
			NodeList = NodeList_v(ROLLOUT_export.ML_nodes)
		
			selected_nodes = NodeList.getSelectedNodesInScene()
			
			NodeList.selectNodesInList(selected_nodes)
	
			export_dirs = for selected_node in selected_nodes  collect selected_node.export_dir
	
			ROLLOUT_export.BP_export_path.text = case (export_dirs_unique = (makeUniqueArray export_dirs)).count of
			(
				0: ""
				1: export_dirs_unique[1]
				default: "Multiple export paths"
			)
	
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