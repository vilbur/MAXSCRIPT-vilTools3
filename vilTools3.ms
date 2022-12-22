clearListener()

content = "/Rollouts"
 -- content = "/Rollouts-Test" -- DEV

current_dir = getFilenamePath(getSourceFileName())

global VILTOOLS_DIR = trimRight (pathConfig.stripPathToLeaf(current_dir)) "\\"


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
	rollouts_path = "$userscripts/"+VILTOOLS_DIR+"/Rollouts/rollouts-Tools"

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
	IMPORT FILES
--------------------------------------------------------------------------------*/


filein_files = #(

	"/../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentLoader.ms",

	"/../MAXSCRIPT-UI-framework/Lib/Menus/RcMenu/RcMenu.ms" ,
	"/Rollouts/rollouts-Tools/rollout-EDIT-POLY/Lib/Epoly.ms",

	"/Rollouts/rollouts-Tools/rollout-MODIFIERS/Lib/Modifier/Modifier.ms" ,
	 "/Rollouts/rollouts-Tools/rollout-MODIFIERS/Lib/ModifierPreset/ModifierPreset.ms" ,

	/* CALLBACK */
	"/CallBacks/selectionSetChanged/setSelectionLast.ms" ,
	"/CallBacks/filePostOpen/checkWorldUnits.ms"
)

for file_path in filein_files where doesFileExist (current_dir + file_path) do
	filein(current_dir + file_path)





/*------------------------------------------------------------------------------
	START VilTools
--------------------------------------------------------------------------------*/

/** LOAD CONTENT */
current_dir	= getFilenamePath(getSourceFileName())

--ContentLoader	= ContentLoader_v path:(current_dir+content) -- WITHOUT INI FILE
ContentLoader	= ContentLoader_v path:(current_dir+content)  ini:( getSourceFileName())

/* CHANGE PROPERTIES oF ROLLOUTS */
ContentLoader.Dialog.title = "VilTools"

/* CREATE DIALOG */
Dialog = ContentLoader.create width:420 height:1024

--unrealRollout = Dialog.get(#unrealEngine)
--format "unrealRollout	= % \n" unrealRollout
--unrealRollout.height = 256

Dialog.register()



filein( getFilenamePath(getSourceFileName()) + "/QuadMenu/VilToolsQuadMenu.ms" )


/* import when UI exists */
try
(
	checkWorldUnitsCallback()

	filein( getFilenamePath(getSourceFileName()) + "/VilTools/rollouts-Tools/rollout-UNREAL/Lib/NodeList/NodeList.ms" )

	(NodeList_v()).loadNodes()

)
catch()
