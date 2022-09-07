--clearListener()

 content = "/Rollouts"
 -- content = "/Rollouts-Test"
 

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
	rollouts_path = "$userscripts/vilTools3/Rollouts/rollouts-Tools"
	
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

)

if  content != "/Rollouts-Test" then -- DEV
	importStdScripts()

/*------------------------------------------------------------------------------
	IMPORT FILES
--------------------------------------------------------------------------------*/

filein( getFilenamePath(getSourceFileName()) + "/../Library/MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentLoader.ms" )

try
(
	filein( getFilenamePath(getSourceFileName()) + "/VilTools/rollouts-Tools/rollout-OBJECTS-SELECTION/Lib/Instance/Instance.ms" )
	filein( getFilenamePath(getSourceFileName()) + "/VilTools/rollouts-Tools/rollout-OBJECTS-SELECTION/Lib/Selection/Selection.ms" )
	
)
catch()


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

--print "!!!!!!!!!!!!!!!!"
/* CHANGE PROPERTIES oF ROLLOUTS */
-- ContentLoader.Dialog.width  = 420
-- ContentLoader.Dialog.height = 1024

ContentLoader.Dialog.RolloutMain.title = "VilTools"

--print "!!!!!!!!!!!!!!!!"



/* CREATE DIALOG */ 
Dialog = ContentLoader.create()


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

