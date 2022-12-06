clearListener()

content = "/Rollouts"
 -- content = "/Rollouts-Test" -- DEV

global VILTOOLS_DIR = trimRight (pathConfig.stripPathToLeaf(getFilenamePath(getSourceFileName()))) "\\"


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
		rollouts_path + "/rollout-TOOLS/Lib/ToolMode.ms",
		rollouts_path + "/rollout-SUBOBJECT/Subobject/Subobject.ms",
		rollouts_path + "/rollout-VIEWPORTS/Lib/ViewportSwitcher/ViewportSwitcher.ms"
	)

	stdscript_file_path = (getDir #maxroot)+ "/stdplugs/stdscripts/viltools-startup.ms"
	deleteFile stdscript_file_path
	stdscript_file = createFile stdscript_file_path

	for file_path in filein_files do
		format "if doesFileExist \"%\" then %" file_path ("filein( \""+file_path+"\" )\n") to:stdscript_file

	close stdscript_file

	filein stdscript_file
)

if content != "/Rollouts-Test" then -- DEV
	importStdScripts()

/*------------------------------------------------------------------------------
	IMPORT FILES
--------------------------------------------------------------------------------*/

filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentLoader.ms")

filein( getFilenamePath(getSourceFileName()) + "/Rollouts/rollouts-Tools/rollout-SELECTION/Lib/Selection/Selection.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/Menus/RcMenu/RcMenu.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/VilTools/rollouts-Tools/rollout-OBJECTS-SELECTION/Lib/Instance/Instance.ms")
filein( getFilenamePath(getSourceFileName()) + "/Rollouts/rollouts-Tools/rollout-EDIT-POLY/Lib/Epoly.ms")

filein( getFilenamePath(getSourceFileName()) + "/Rollouts/rollouts-Tools/rollout-MODIFIERS/Lib/Modifier/Modifier.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Rollouts/rollouts-Tools/rollout-MODIFIERS/Lib/ModifierPreset/ModifierPreset.ms" )

/* CALLBACK */
filein( getFilenamePath(getSourceFileName()) + "/CallBacks/selectionSetChanged/setSelectionLast.ms" )
filein( getFilenamePath(getSourceFileName()) + "/CallBacks/filePostOpen/checkWorldUnits.ms" )

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
