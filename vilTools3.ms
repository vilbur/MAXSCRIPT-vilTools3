clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/FileInImporter/FileInImporter.ms" )	--"./../MAXSCRIPT-UI-framework/Lib/FileInImporter/FileInImporter.ms"
filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/StdScriptImporter/StdScriptImporter.ms" )	--"./../MAXSCRIPT-UI-framework/Lib/StdScriptImporter/StdScriptImporter.ms"
filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/PlugInImporter/PlugInImporter.ms" )	--"./../MAXSCRIPT-UI-framework/Lib/PlugInImpoerter/PlugInImpoerter.ms"
filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/MacroscriptGenerator/generateMacroscripts.ms" )	--"./../MAXSCRIPT-UI-framework/Lib/MacroscriptGenerator/generateMacroscripts.ms"

filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentLoader.ms" )	-- "./../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentLoader.ms"


--RUN_ON_STARTUP = true

global VILTOOLS

global ROLLOUT_export
global ROLLOUT_3d_print


/* DIRECTORY WHERE TO LOAD CONTENT */ 
content_dir = "VilTools"
--content_dir = "/Rollouts-Test" -- DEV

current_dir = getFilenamePath(getSourceFileName())

current_dir_name = trimRight ( pathConfig.stripPathToLeaf(current_dir)) "\\"

rollouts_dir = "$userscripts/"+current_dir_name+"/"+content_dir+"/rollouts-Tools"

/*------------------------------------------------------------------------------
	IMPORTED FILES
--------------------------------------------------------------------------------*/
std_scripts = #(

	( current_dir + "/../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms" ), -- "./../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms"

	( current_dir + "/../MAXSCRIPT-UI-framework/Lib/CallbackManager/CallbackManager.ms"),	--"./../MAXSCRIPT-UI-framework/Lib/CallbackManager/CallbackManager.ms"
	
	
	"/../../Lib/RegExer/RegExer.ms",

	"/rollout-SELECTION/Lib/InstaceManager/InstaceManager.ms",

	"/rollout-SPLINE/Lib/SplineConvertor/SplineConvertor.ms",

	"/rollout-TOOLS/Lib/ToolMode.ms",

	"/rollout-SCENE/RecentFile/RecentFile.ms",

	"/rollout-MODIFIER-STACK/Lib/ModifierRenamer/ModifierRenamer.ms",
	"/rollout-MODIFIER-STACK/Lib/ModStackPreset/ModStackPreset.ms",
	"/rollout-MODIFIER-STACK/Lib/Subobject/Subobject.ms",
	"/rollout-MODIFIER-STACK/Lib/CircleStack/circleStack.ms",

	"/rollout-MATERIALS/Lib/MaterialIdAssigner/MaterialIdAssigner.ms",

	"/rollout-OBJECT/Lib/OnNewNodeCallback.ms",

	"/rollout-EDIT-POLY/Lib/epolyFilter.ms",
	"/rollout-EDIT-POLY/Lib/SelectionConvertor.ms",
	----"/rollout-EDIT-POLY/Lib/EpolySelection_v.ms",
	----"/rollout-EDIT-POLY/Lib/executeEpolyLoopTool.ms",
	----"/rollout-EDIT-POLY/Lib/executeEpolyMacroWithOptions.ms",
	"/rollout-EDIT-POLY/Lib/toggleConstrainType.ms",
	

	"/rollout-LAYERS/Lib/LayersManager/LayersManager.ms",	--"./VilTools/rollouts-Tools/rollout-LAYERS/Lib/LayersManager/LayersManager.ms"
	"/rollout-LAYERS/Lib/SceneLayers/SceneLayers.ms",	--"./VilTools/rollouts-Tools/rollout-LAYERS/Lib/SceneLayers/SceneLayers.ms"
	"/rollout-LAYERS/Lib/LayersToogleDialog/LayersToogleDialog.ms",

	"/rollout-VIEWPORTS/Lib/ViewportSwitcher/ViewportSwitcher.ms",
	"/rollout-VIEWPORTS/Lib/ViewportLayoutManager/ViewportLayoutManager.ms",

	"/rollout-MODIFIER-STACK/Lib/LoftRemote/LoftRemote.ms",
	"/rollout-MODIFIER-STACK/Lib/CommandPanel/CommandPanel.ms",
	"/rollout-MODIFIER-STACK/Lib/ModifierStackRemote/ModifierStackRemote.ms",

	"/rollout-EXPORT/rollouts-ExportTo/rollout-ZBRUSH/Lib/MaxToZbrushSync.ms" -- "./VilTools/rollouts-Tools/rollout-EXPORT/rollouts-ExportTo/rollout-ZBRUSH/Lib/MaxToZbrushSync.ms"
)

filein_files = #(

	"/VilTools/rollouts-Tools/rollout-SELECTION/Lib/Selection/Selection.ms",

	"/VilTools/rollouts-Tools/rollout-MODIFIERS/Lib/Modifier/Modifier.ms"
)

/*------------------------------------------------------------------------------
	INSTALL START UP FILES
--------------------------------------------------------------------------------*/
(StdScriptImporter_v root:rollouts_dir filename:content_dir files:std_scripts).createStartUpFile()


/*------------------------------------------------------------------------------
	INSTALL PLUGINS
--------------------------------------------------------------------------------*/
(PlugInImporter_v ( rollouts_dir + "/rollout-EXPORT/Lib/ExportNode/ExportNodePlugin.ms" )).install() --"./VilTools/rollouts-Tools/rollout-EXPORT/Lib/ExportNode/ExportNodePlugin.ms"

/*------------------------------------------------------------------------------
	GENERATE MACROS
--------------------------------------------------------------------------------*/
generateMacroscripts( rollouts_dir )


/*------------------------------------------------------------------------------
     IMPORTANT CALLBACKS
--------------------------------------------------------------------------------*/
CALLBACKMANAGER.import( getFilenamePath(getSourceFileName()) + "/Callbacks" ) --"./CallBacks/"	


/*------------------------------------------------------------------------------
	IMPORT FILES
--------------------------------------------------------------------------------*/
(FileInImporter_v root:current_dir files:filein_files blacklist:"*Test*" ).import()




/* CONVERT RELATIVE PATHS TO ABSOLUTE */
--filein_files = for file_path in filein_files collect if ( matchPattern file_path pattern:@"/*" ) then pathConfig.convertPathToAbsolute(current_dir + file_path) else file_path

--
--try(
--	/* FILE IN FILES */
--	for file_path in filein_files where not matchPattern file_path pattern:"*Test*" do
--	(
--		format "FILE IN: % \n" (file_path)
--		if doesFileExist file_path then
--			filein( file_path)
--	)
--
--)catch
--(
--	format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
--	format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
--    format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
--    format "\n——————————————————— STACK ———————————————————\n%\n" 	(getCurrentExceptionCallStack())
--)
--




/*------------------------------------------------------------------------------
	
	
	CREATE VilTools DILAOG
	
	
------------------------------------------------------------------------------*/
try(
	/** LOAD CONTENT */
	----ContentLoader	= ContentLoader_v path:(current_dir+content) -- WITHOUT INI FILE --DEV
	
	ContentLoader	= ContentLoader_v path:(current_dir + content_dir)  ini:( getSourceFileName()) width:400

	/* CHANGE PROPERTIES oF ROLLOUTS */
	ContentLoader.Dialog.title = "VilTools"

	
	/* CREATE DIALOG */
	VILTOOLS = ContentLoader.create height:1024

	VILTOOLS.register()

)catch(
	format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
	format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
    format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
	format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())
)





/*------------------------------------------------------------------------------

	IMPORT FILES

--------------------------------------------------------------------------------*/

/* import when UI exists */
try
(
    --filein( getFilenamePath(getSourceFileName()) + "/VilTools/rollouts-Tools/rollout-EXPORT/Lib/ExportNodeCallbacks/ExportNodeCallback.ms" )	-- "./Rollouts/rollouts-Tools/rollout-EXPORT/Lib/ExportNodeCallbacks/ExportNodeCallback.ms"

	--(NodeList_v()).loadNodes()

	--selectExportNodeInListCallbactAdd()

	--filein( getFilenamePath(getSourceFileName()) + "/generateMacroscripts.ms" ) -- "./generateMacroscripts.ms"

	--if ROLLOUT_layers.CBXBTN_layer_manager.state then
		--showLayerManagerCallback()


)
catch
(
	format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
	format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
    format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
	format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())
)




















