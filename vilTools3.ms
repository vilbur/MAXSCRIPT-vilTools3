clearListener()

--RUN_ON_STARTUP = true

content_dir = "VilTools"
--content_dir = "/Rollouts-Test" -- DEV

current_dir = getFilenamePath(getSourceFileName())

global VILTOOLS_DIR = trimRight ( pathConfig.stripPathToLeaf(current_dir)) "\\"

rollouts_path = "$userscripts/"+VILTOOLS_DIR+"/"+content_dir+"/rollouts-Tools"

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
		"/rollout-EDIT-POLY/Subobject/Subobject.ms",
		"/rollout-VIEWPORTS/Lib/ViewportSwitcher/ViewportSwitcher.ms",
		"/rollout-EXPORT/rollouts-ExportTo/rollout-ZBRUSH/Lib/MaxToZbrushSync.ms" -- "./VilTools/rollouts-Tools/rollout-EXPORT/rollouts-ExportTo/rollout-ZBRUSH/Lib/MaxToZbrushSync.ms"
	)

	for i = 1 to filein_files.count do
		filein_files[i] =  rollouts_path + filein_files[i]

	stdscript_file_path = (getDir #maxroot)+ "/stdplugs/stdscripts/viltools-startup.ms" -- "C:\Program Files\Autodesk\3ds Max 2023\stdplugs\stdscripts\viltools-startup.ms"

	deleteFile stdscript_file_path

	stdscript_file = createFile stdscript_file_path

	for file_path in filein_files do
		format "if doesFileExist \"%\" then\n\t%" file_path ("filein( \""+file_path+"\" )\n\n") to:stdscript_file

	close stdscript_file

	filein stdscript_file_path
)

if content != "/Rollouts-Test" then -- DEV
	importStdScripts()

/*------------------------------------------------------------------------------
	INSTALL PLUGINS
--------------------------------------------------------------------------------*/

export_node_plugin_source = rollouts_path + "\\rollout-EXPORT\\Lib\\ExportNode\\ExportNodePlugin.ms"
export_node_plugin_target = (getDir #maxroot)+ "\\stdplugs\\stdscripts\\ExportNodePlugin.ms"

if doesFileExist export_node_plugin_source then
(
	deleteFile export_node_plugin_target

	copyFile (export_node_plugin_source) (export_node_plugin_target)

	filein export_node_plugin_source
)


/*------------------------------------------------------------------------------
	IMPORT FILES
--------------------------------------------------------------------------------*/

/* MANNUAL IMPORT */
filein_files = #(

	"/../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentLoader.ms", -- IMPORT UI FRAMEWORK

	"/../MAXSCRIPT-UI-framework/Lib/Menus/RcMenu/RcMenu.ms" , -- Check if this is necessary to import, it should be imported with framework
	"/VilTools/rollouts-Tools/rollout-EDIT-POLY/Lib/Epoly.ms",

	"/VilTools/rollouts-Tools/rollout-SELECTION/Lib/Selection/Selection.ms",

	"/VilTools/rollouts-Tools/rollout-MODIFIERS/Lib/Modifier/Modifier.ms",

	"/VilTools/rollouts-Tools/rollout-MODIFIER-STACK/Lib/ModStackPreset/ModStackPreset.ms" -- "./VilTools/rollouts-Tools/rollout-MODIFIER-STACK/Lib/ModStackPreset/ModStackPreset.ms"

)


/* CONVERT RELATIVE PATHS TO ABSOLUTE */
filein_files = for file_path in filein_files collect if ( matchPattern file_path pattern:@"/*" ) then pathConfig.convertPathToAbsolute(current_dir + file_path) else file_path


/* ADD CALLBACK FILES from "./CallBacks/" */
for callback_subdir in  getDirectories (current_dir + "/CallBacks/*") recurse:true do
	for callback_file in getFiles (callback_subdir + "/*.ms") do
		appendIfUnique filein_files callback_file


/* FILE IN FILES */
for file_path in filein_files do
(
	--format "FILE IN: = % \n" (file_path)

	filein( file_path)
)




global VILTOOLS
/*------------------------------------------------------------------------------
	START VilTools
--------------------------------------------------------------------------------*/

/** LOAD CONTENT */
current_dir	= getFilenamePath(getSourceFileName())

--ContentLoader	= ContentLoader_v path:(current_dir+content) -- WITHOUT INI FILE
ContentLoader	= ContentLoader_v path:(current_dir+content_dir)  ini:( getSourceFileName())

/* CHANGE PROPERTIES oF ROLLOUTS */
--ContentLoader.Dialog.title = "VilTools"

/* CREATE DIALOG */
VILTOOLS = ContentLoader.create width:420 height:1024

VILTOOLS.register()

	--format " VilTools	= % \n" (classOf VilTools)

/*------------------------------------------------------------------------------
	QUADMENUS
--------------------------------------------------------------------------------*/



--filein( getFilenamePath(getSourceFileName()) + "/QuadMenu/modifyQuadMenus.ms" ) -- "./QuadMenu/modifyQuadMenus.ms"


/*------------------------------------------------------------------------------
	START CALLBACKS
--------------------------------------------------------------------------------*/


/* import when UI exists */
try
(
      filein( getFilenamePath(getSourceFileName()) + "/VilTools/rollouts-Tools/rollout-EXPORT/Lib/ExportNodeCallbacks/ExportNodeCallback.ms" )	-- "./Rollouts/rollouts-Tools/rollout-EXPORT/Lib/ExportNodeCallbacks/ExportNodeCallback.ms"

	--(NodeList_v()).loadNodes()

	selectExportNodeInListCallbactAdd()

	loadModifierDefaultsCallback()

	nodeCreatedSetDefaultPropertiesCallback()

)
catch()
