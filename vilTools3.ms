clearListener()

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
	filein_files = #(
		"$userscripts/vilTools3/Rollouts/rollouts-Tools/rollout-TOOLS/Lib/ToolMode.ms",
		"$userscripts/vilTools3/Rollouts/rollouts-Tools/rollout-VIEWPORTS/Lib/ViewportSwitcher/ViewportSwitcher.ms"
	)
	
	stdscript_file_path = (getDir #maxroot)+ "/stdplugs/stdscripts/viltools-startup.ms"
	deleteFile stdscript_file_path
	stdscript_file = createFile stdscript_file_path
	
	for file in filein_files do 
		format "%" ("filein( \""+file+"\" )\n") to:stdscript_file
	
	close stdscript_file

)

--if  content != "/Rollouts-Test" then -- DEV
	--importStdScripts()

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

----ContentLoader	= ContentLoader_v path:(current_dir+content) -- WITHOUT INI FILE
ContentLoader	= ContentLoader_v path:(current_dir+content)  ini:( getSourceFileName())

/* CHANGE PROPERTIES oF ROLLOUTS */ 
ContentLoader.Dialog.RolloutMain.title = "VilTools"

--if( ( unreal_engine_rollout = ContentLoader.Dialog.get #UnrealEngine) != undefined ) then
	--unreal_engine_rollout.height = 164


/* CREATE DIALOG */ 
Dialog = ContentLoader.create width:420

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

