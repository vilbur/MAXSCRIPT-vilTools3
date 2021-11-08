global export_nodes_in_scene = #()

/** Exporter
 */
struct ExporterFbx_v
(
	export_node,	-- used node for export
	
	export_path = @"c:\GoogleDrive\Programs\CG\3DsMax\scripts\vilTools3\VilTools\rollouts-Tools\rollout-UNREAL\Test\ExportedAssets\MaterialTest.fbx",
	
	preset_file = getFilenamePath(getSourceFileName()) + "\Presets\Unreal-default.fbxexportpreset",

	/** Setup fbx exporter
	 */
	function loadPreset =
	(
		print "ExporterFbx_v.loadPreset()"
		FBXExporterSetParam "LoadExportPresetFile" preset_file
	),
	
	/** Epxort
	 */
	function epxort nodes =
	(
		print "ExporterFbx_v.epxort()"
	
		for _node in nodes do 
			this.selectObjetcsAndExport (_node.children)
	
	),

	/** Select node children
	 */
	function selectObjetcsAndExport nodes =
	(
		--print "ExporterFbx_v.selectObjectsForExport()"
		select nodes
		
		if( nodes.count > 0 ) then
			exportFile export_path #noPrompt selectedOnly:true using:FBXEXP
	),
	
	/*------------------------------------------------------------------------------
		PRIVATE
	--------------------------------------------------------------------------------*/
	
	--/** Set export path
	--  * Combine Export dir path defined in user properties of node and node name
	-- */
	--function _setExportPath =
	--(
	--	export_dir = getUserProp export_node "export-dir"
	--	
	--	export_path = export_dir + "\\" + export_node.name + ".fbx"
	--),
	--/** Export node names
	-- */
	--function exportNodeNames =
	--(
	--	
	--	for _node in export_nodes_in_scene collect _node.name
	--),
	
	on create do ()
)