clearListener()

content = "/VilTools"
--content = "/Rollouts-Test" -- DEV

current_dir = getFilenamePath(getSourceFileName())

global VILTOOLS_DIR = trimRight ( pathConfig.stripPathToLeaf(current_dir)) "\\"

rollouts_path = "$userscripts/"+VILTOOLS_DIR+"/Rollouts/rollouts-Tools"

/** Import structures used in macroscripts on Max start
  *
  * These file must be imported before Max evaluates macrosctips
  *
  * 3Ds Max is importing files in order
  * 	1) Std scripts
  * 	2) Macroscripts
  * 	3) Startup scripts
  *
  * TODO: CREATE STRUCT FOR THIS METHOD
  *
 */
function importStdScripts =
(

	filein_files = #(
		"/rollout-SELECTION/Lib/Selection/Selection.ms",
		"/rollout-TOOLS/Lib/ToolMode.ms",
		"/rollout-SUBOBJECT/Subobject/Subobject.ms",
		"/rollout-VIEWPORTS/Lib/ViewportSwitcher/ViewportSwitcher.ms"
	)

	stdscript_file_path = (getDir #maxroot)+ "/stdplugs/stdscripts/viltools-startup.ms"

	deleteFile stdscript_file_path
	stdscript_file = createFile stdscript_file_path

	for file_path in filein_files do
		format "if doesFileExist \"%\" then %" (rollouts_path + file_path) ("filein( \""+(rollouts_path + file_path)+"\" )\n") to:stdscript_file

	close stdscript_file
	filein stdscript_file_path
)

if content != "/Rollouts-Test" then -- DEV
	importStdScripts()

/*------------------------------------------------------------------------------
	INSTALL PLUGINS
--------------------------------------------------------------------------------*/

export_node_plugin_source = rollouts_path + "/rollout-EXPORT/Lib/ExportNode/ExportNodePlugin.ms"
export_node_plugin_target = (getDir #maxroot)+ "/stdplugs/stdscripts/ExportNodePlugin.ms"

if doesFileExist export_node_plugin_source then
(

	deleteFile export_node_plugin_target

	copyFile (export_node_plugin_source) (export_node_plugin_target)

	filein export_node_plugin_source
)


/*------------------------------------------------------------------------------
	IMPORT FILES
--------------------------------------------------------------------------------*/


filein_files = #(

	"/../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentLoader.ms", -- IMPORT UI FRAMEWORK

	"/../MAXSCRIPT-UI-framework/Lib/Menus/RcMenu/RcMenu.ms" , -- Check if this is necessary to import, it should be imported with framework
	"/Rollouts/rollouts-Tools/rollout-EDIT-POLY/Lib/Epoly.ms",

	"/Rollouts/rollouts-Tools/rollout-MODIFIERS/Lib/Modifier/Modifier.ms" ,
	 "/Rollouts/rollouts-Tools/rollout-MODIFIERS/Lib/ModifierPreset/ModifierPreset.ms" ,

	/* CALLBACK */
	"/CallBacks/selectionSetChanged/setSelectionLast.ms" ,
	"/CallBacks/filePostOpen/checkWorldUnits.ms"
)

for file_path in filein_files where doesFileExist (current_dir + file_path) do
	filein(current_dir + file_path)




global VILTOOLS
/*------------------------------------------------------------------------------
	START VilTools
--------------------------------------------------------------------------------*/

/** LOAD CONTENT */
current_dir	= getFilenamePath(getSourceFileName())

--ContentLoader	= ContentLoader_v path:(current_dir+content) -- WITHOUT INI FILE
ContentLoader	= ContentLoader_v path:(current_dir+content)  ini:( getSourceFileName())

/* CHANGE PROPERTIES oF ROLLOUTS */
--ContentLoader.Dialog.title = "VilTools"

/* CREATE DIALOG */
VILTOOLS = ContentLoader.create width:420 height:1024

VILTOOLS.register()

	--format " VilTools	= % \n" (classOf VilTools)

/*------------------------------------------------------------------------------
	QUADMENUS
--------------------------------------------------------------------------------*/



filein( getFilenamePath(getSourceFileName()) + "/QuadMenu/VilToolsQuadMenu.ms" )



/*------------------------------------------------------------------------------
	CALLBACKS
--------------------------------------------------------------------------------*/


/* import when UI exists */
try
(
	filein( getFilenamePath(getSourceFileName()) + "/Rollouts/rollouts-Tools/rollout-EXPORT/Lib/ExportNodeCallbacks/ExportNodeCallback.ms" )	-- "./Rollouts/rollouts-Tools/rollout-EXPORT/Lib/ExportNodeCallbacks/ExportNodeCallback.ms"

	--(NodeList_v()).loadNodes()

	selectExportNodeInListCallbactAdd()
)
catch()
