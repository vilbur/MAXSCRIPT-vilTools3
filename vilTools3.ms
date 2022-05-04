clearListener()

/** Import structures used in macroscripts
  *
  * These file must be imported before Max evaluates macrosctips
  *
  * 3Ds Max is importing files in order
  * 	1) Std scripts 
  * 	2) Macroscripts
  * 	3) Startup scripts
  *
  * TODO: move this function to better location
  *
 */
function importStdScripts =
(
	filein_files = #(
		"$userscripts/vilTools3/Rollouts/rollouts-Tools/rollout-TOOLS/Lib/ToolMode.ms"
	)
	
	stdscript_file_path = (getDir #maxroot)+ "/stdplugs/stdscripts/viltools-startup.ms"
	deleteFile stdscript_file_path
	stdscript_file = createFile stdscript_file_path
	
	for file in filein_files do 
		format "%" ("filein( \""+file+"\" )\n") to:stdscript_file
	
	close stdscript_file

)
importStdScripts()

/*------------------------------------------------------------------------------
	IMPORT FILES
--------------------------------------------------------------------------------*/
filein( getFilenamePath(getSourceFileName()) + "/Lib/DynamicModifyPanel/DynamicModifyPanel.ms" )

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

current_dir	= getFilenamePath(getSourceFileName())

ContentLoader	= ContentLoader_v path:(current_dir+"/Rollouts") ini:(getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini")

Dialog = ContentLoader.create width:420

Dialog.dock #right




/* import when UI exists */
try
(
	checkWorldUnitsCallback()

	filein( getFilenamePath(getSourceFileName()) + "/VilTools/rollouts-Tools/rollout-UNREAL/Lib/NodeList/NodeList.ms" )
	
	(NodeList_v()).loadNodes()
	
)
catch()

