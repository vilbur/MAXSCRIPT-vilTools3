/** Select node in list
 */
function selectExportNodeInListCallback =
(
	--format "\n"; print ".selectExportNodeInListCallback()"
	NodeList = NodeList_v(ROLLOUT_export.ML_nodes)

	NodeList.loadNodes()

	selectExportNodeInListCallbackRemove()

	if (selected_nodes = NodeList.getSelectedNodesInScene()).count > 0 then
		NodeList.selectNodesInList(selected_nodes)

	selectExportNodeInListAdd()
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
function selectExportNodeInListAdd =
(
	--format "\n"; print ".selectExportNodeInListAdd()"
	selectExportNodeInListCallbackRemove()

	try( callbacks.addScript #selectionSetChanged "selectExportNodeInListCallback()" id:#selectExportNodeInListCallback )catch()
)