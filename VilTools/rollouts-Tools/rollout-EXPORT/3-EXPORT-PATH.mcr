
/**
 */
macroscript	_export_path_2nd
category:	"_Export"
buttontext:	"[Open Export Path]"
toolTip:	"Open Export Path"
icon:	"across:10|width:16|offset:[ -16, 0 ]"
(
	format "eventFired	= % \n" eventFired
	--format "ROLLOUT_export.BP_export_path.text	= % \n" ROLLOUT_export.BP_export_path.text
	export_path = maxFilePath + ROLLOUT_export.BP_export_path.text

	export_path = ( dotNetObject "System.Text.RegularExpressions.Regex" @"[\\/]+" ).Replace export_path "\\"

	if doesFileExist export_path then
		ShellLaunch  "explorer.exe" export_path
)


/**
 */
macroscript	_export_path
category:	"_Export"
buttontext:	"[Export Path]"
toolTip:	"Set\Get export dir of selected nodes"
icon:	"Control:browsePath|initialDir:maxFilePath|across:1|offset:[ 5, -24 ]|border:false"
(
	format "EventFired.val	= % \n" EventFired.val

	if (is_absolute = (( dotNetClass "System.Text.RegularExpressions.RegEx" ).match EventFired.val "[a-zA-Z]:[\\\/]" ).success) then
	(
		relative_path = pathConfig.convertPathToRelativeTo EventFired.val maxFilePath
		--format "relative_path	= % \n" relative_path

		--relative_path = trimLeft relative_path "."
		--format "relative_path	= % \n" relative_path
		ROLLOUT_export.BP_export_path.text = relative_path

		for selected_node in (NodeList_v(ROLLOUT_export.ML_nodes)).getSelectedNodesInScene() do
			selected_node.export_dir = (relative_path)
	)
)

--
--/**
-- */
--macroscript	_export_subfolder_per_node
--category:	"_Export"
--buttontext:	"Sub directory by node name"
--toolTip:	"Export each node to custom subfolder of export path"
--icon:	"Control:checkbox|across:1"
--(
--	format "eventFired	= % \n" eventFired
--)
--

/**
 */
macroscript	_export_subfolder_per_node
category:	"_Export"
buttontext:	"Sub directory by node name"
toolTip:	"Export each node to custom subfolder of export path\n\nE.G: 'Export_Dir\Node_Name\Node_Name.obj'"
icon:	"Control:checkbox|across:1"
(
	format "Export size set to % \n" eventFired.val
)
