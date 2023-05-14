/** Select node in list
 */
function selectExportNodeInListCallback =
(
	NodeList = NodeList_v(ROLLOUT_export.ML_nodes)

	NodeList.loadNodes()

	--format "selected_nodes	= % \n" selected_nodes
	if ( selected_nodes = NodeList.getSelectedNodesInScene()).count > 0 then
	(
		--format "\n"; print ".selectExportNodeInListCallback()"

		selectExportNodeInListCallbackRemove()


		NodeList.selectNodesInList(selected_nodes)

		export_dirs = for selected_node in selected_nodes  collect selected_node.export_dir

		--format "export_dirs.count	= % \n" export_dirs.count
		--format "(makeUniqueArray export_dirs).count	= % \n" ((makeUniqueArray export_dirs).count)
		--format "export_dirs	= % \n" export_dirs

		ROLLOUT_export.BP_export_path.text = case (export_dirs_unique = (makeUniqueArray export_dirs)).count of
		(
			0: ""
			1: export_dirs_unique[1]
			default: "Multiple export paths"
		)



		ROLLOUT_export.ML_node_groups.items = sort (makeUniqueArray(for obj in shapes where classOf obj == Export_Node and obj.parent != undefined and isGroupHead obj.parent collect obj.parent.name))

		--if export_dirs.count == 0 or (makeUniqueArray export_dirs).count != 1 then
		--	ROLLOUT_export.BP_exxport_path.text = ""
		--else
		--	ROLLOUT_export.BP_exxport_path.text = export_dirs[1]

	)
	else
		ROLLOUT_export.BP_export_path.text = ""



	selectExportNodeInListCallbactAdd()

	--format "\n"; print ".selectExportNodeInListCallback() DONE"

)


/** Remove callback
 */
function selectExportNodeInListCallbackRemove =
(
	--format "\n"; print ".selectExportNodeInListCallbackRemove()"

	try( callbacks.removeScripts #selectionSetChanged id:#selectExportNodeInListCallback )catch()
)

/** Add callback
 */
function selectExportNodeInListCallbactAdd =
(
	--format "\n"; print ".selectExportNodeInListCallbactAdd()"
	selectExportNodeInListCallbackRemove()

	try( callbacks.addScript #selectionSetChanged "selectExportNodeInListCallback()" id:#selectExportNodeInListCallback )catch()
)