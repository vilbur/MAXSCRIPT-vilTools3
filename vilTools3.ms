--clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/FileInImporter/FileInImporter.ms" )	--"./../MAXSCRIPT-UI-framework/Lib/FileInImporter/FileInImporter.ms"
filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/StartUpScriptImporter/StartUpScriptImporter.ms" )	--"./../MAXSCRIPT-UI-framework/Lib/StartUpScriptImporter/StartUpScriptImporter.ms"
filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/PlugInImporter/PlugInImporter.ms" )	--"./../MAXSCRIPT-UI-framework/Lib/PlugInImpoerter/PlugInImpoerter.ms"


--RUN_ON_STARTUP = true

global VILTOOLS

global ROLLOUT_export
global ROLLOUT_3d_print
global ROLLOUT_viewports


/* DIRECTORY WHERE TO LOAD CONTENT */ 
content_dir = "VilTools"
--content_dir = "/Rollouts-Test" -- DEV

current_dir = getFilenamePath(getSourceFileName())

current_dir_name = trimRight ( pathConfig.stripPathToLeaf(current_dir)) "\\"

rollouts_dir = "$userscripts/"+current_dir_name+"/"+content_dir+"/rollouts-Tools"

/*------------------------------------------------------------------------------
	IMPORT FILES
--------------------------------------------------------------------------------*/
std_scripts = #(

	( current_dir + "/../MAXSCRIPT-UI-framework/Lib/CallbackManager/CallbackManager.ms"),	--"./../MAXSCRIPT-UI-framework/Lib/CallbackManager/CallbackManager.ms"
	
	( current_dir + "/../MAXSCRIPT-UI-framework/Lib/MacroscriptGenerator/MacroscriptGenerator.ms" ),	--"./../MAXSCRIPT-UI-framework/Lib/MacroscriptGenerator/MacroscriptGenerator.ms"
	( current_dir + "/../MAXSCRIPT-UI-framework/Lib/MacroscriptGenerator/generateMacroscripts.ms" ),	--"./../MAXSCRIPT-UI-framework/Lib/MacroscriptGenerator/generateMacroscripts.ms"
	
	( current_dir + "/../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentSubrollouts/ContentRollout/ScriptFile/ScriptFile.ms" ),	--"./../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentSubrollouts/ContentRollout/ScriptFile/ScriptFile.ms"
	( current_dir + "/../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentLoader.ms" ),	-- "./../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentLoader.ms"
	
	( current_dir + "/../MAXSCRIPT-UI-framework/Lib/Menus/include-menus.ms" ),	--"./../MAXSCRIPT-UI-framework/Lib/Menus/include-menus.ms"
	
	"/../../Lib/RegExer/RegExer.ms",

	"/rollout-ANIMATION/Lib/shiftCurrentTime.ms", --"./VilTools/rollouts-Tools/rollout-ANIMATION/Lib/shiftCurrentTime.ms"

	"/rollout-COLORS/Lib/Color/Color.ms",	--"./VilTools/rollouts-Tools/rollout-COLORS/Lib/Color/Color.ms"
	"/rollout-COLORS/Lib/Wirecolor/Wirecolor.ms",	--"./VilTools/rollouts-Tools/rollout-COLORS/Lib/Wirecolor/Wirecolor.ms"

	"/rollout-EDIT-POLY/Lib/SelectionConvertor.ms",
	"/rollout-EDIT-POLY/Lib/epolyFilter.ms",
	"/rollout-EDIT-POLY/Lib/toggleConstrainType.ms",

	"/rollout-EXPORT/rollouts-ExportTo/rollout-ZBRUSH/Lib/MaxToZbrushSync.ms", -- "./VilTools/rollouts-Tools/rollout-EXPORT/rollouts-ExportTo/rollout-ZBRUSH/Lib/MaxToZbrushSync.ms"

	"/rollout-LAYERS/Lib/LayersManager/LayersManager.ms",	--"./VilTools/rollouts-Tools/rollout-LAYERS/Lib/LayersManager/LayersManager.ms"
	"/rollout-LAYERS/Lib/LayersToogleDialog/LayersToogleDialog.ms",
	"/rollout-LAYERS/Lib/SceneLayers/SceneLayers.ms",	--"./VilTools/rollouts-Tools/rollout-LAYERS/Lib/SceneLayers/SceneLayers.ms"

	"/rollout-MATERIALS/Lib/MaterialIdAssigner/MaterialIdAssigner.ms",

	"/rollout-MODIFIER-STACK/Lib/CircleStack/circleStack.ms",
	"/rollout-MODIFIER-STACK/Lib/CommandPanel/CommandPanel.ms",
	"/rollout-MODIFIER-STACK/Lib/LoftRemote/LoftRemote.ms",
	"/rollout-MODIFIER-STACK/Lib/ModStackPreset/ModStackPreset.ms",
	"/rollout-MODIFIER-STACK/Lib/ModifierRenamer/ModifierRenamer.ms",
	"/rollout-MODIFIER-STACK/Lib/ModifierStackRemote/ModifierStackRemote.ms",
	"/rollout-MODIFIER-STACK/Lib/Subobject/Subobject.ms",

	"/rollout-OBJECT/Lib/OnNewNodeCallback.ms",

	"/rollout-OPTIONS/Lib/showQuadMenuHotkeys.ms",	--"./VilTools/rollouts-Tools/rollout-OPTIONS/Lib/showQuadMenuHotkeys.ms"

	"/rollout-SCENE/RecentFile/RecentFile.ms",
	"/rollout-SCENE/SceneStatesManager/SceneStatesManager-import.ms",	--"./VilTools/rollouts-Tools/rollout-SCENE/SceneStatesManager/SceneStatesManager-import.ms"

	"/rollout-SELECTION/Lib/InstaceManager/InstaceManager.ms",
	"/rollout-SELECTION/Lib/SelectionSetsManager/SelectionSetsManager.ms",	--"./VilTools/rollouts-Tools/rollout-SELECTION/Lib/SelectionSetsManager/SelectionSetsManager.ms"

	"/rollout-SPLINE/Lib/SplineConvertor/SplineConvertor.ms",

	"/rollout-TOOLS/Lib/ToolMode.ms",

	"/rollout-TRANSFORM/Lib/transformByArrow.ms", --"./VilTools/rollouts-Tools/rollout-TRANSFORM/Lib/transformByArrow.ms"

	"/rollout-VIEWPORTS/04-[Layout-Presets].mcr",	--"./VilTools/rollouts-Tools/rollout-VIEWPORTS/04-[Layout-Presets].mcr" -- menu items has unicode arrows, import on startup make it work in quad menu
	"/rollout-VIEWPORTS/Lib/GifRecorder/createGifRecorderDialog.ms", --"./VilTools/rollouts-Tools/rollout-VIEWPORTS/Lib/GifRecorder/createGifRecorderDialog.ms"
	"/rollout-VIEWPORTS/Lib/GifRecorder/GifRecorder.ms", --"./VilTools/rollouts-Tools/rollout-VIEWPORTS/Lib/GifRecorder/GifRecorder.ms"
	"/rollout-VIEWPORTS/Lib/toggleViewportShadeModes.ms", 	--"./VilTools/rollouts-Tools/rollout-VIEWPORTS/Lib/toggleViewportShadeModes.ms"
	"/rollout-VIEWPORTS/Lib/ViewportHud/_importHUD.ms", --"./VilTools/rollouts-Tools/rollout-VIEWPORTS/Lib/ViewportHud/_importHUD.ms"
	"/rollout-VIEWPORTS/Lib/ViewportLayoutManager/ViewportLayoutManager.ms",
	"/rollout-VIEWPORTS/Lib/ViewportSwitcher/ViewportSwitcher.ms",
	
	
	"/rollouts-Tools/rollout-MATERIALS/Lib/MaterialId/MaterialId.ms",	--"./VilTools/rollouts-Tools/rollout-MATERIALS/Lib/MaterialId/MaterialId.ms"

	"" -- last blank item to prevent errors on development
)

startup_scripts = #(
	--( current_dir + "/../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms" ), -- "./../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms"
	--( current_dir + "/../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentLoader.ms" ), -- "./../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms"
	
	--"/rollout-VIEWPORTS/Lib/ViewportHud/_importHUD.ms", --"./VilTools/rollouts-Tools/rollout-VIEWPORTS/Lib/ViewportHud/_importHUD.ms"
	--"/rollout-OPTIONS/Lib/setCreatePanelOnUnselectedObjects.ms",	--"./VilTools/rollouts-Tools/rollout-OPTIONS/Lib/setCreatePanelOnUnselectedObjects.ms"
	"" -- last blank item to prevent errors on development
)

filein_files = #(

	"/VilTools/rollouts-Tools/rollout-SELECTION/Lib/Selection/Selection.ms",

	"/VilTools/rollouts-Tools/rollout-MODIFIERS/Lib/Modifier/Modifier.ms"
)




/*==============================================================================
	INSTALL
================================================================================*/
if open_or_install != #OPEN then
(
	try(

		StartUpScriptImporter = StartUpScriptImporter_v root:rollouts_dir filename:content_dir DEBUG:true
		
		/*------------------------------------------------------------------------------
			INSTALL STD SCRIPTS
		--------------------------------------------------------------------------------*/
		StartUpScriptImporter.createStartUpFile(std_scripts) std:true
		

		
		/*------------------------------------------------------------------------------
			INSTALL START SCRIPTS
		--------------------------------------------------------------------------------*/
		StartUpScriptImporter.createStartUpFile(startup_scripts)
		
		
		/*------------------------------------------------------------------------------
			 IMPORT CALLBACKS
		--------------------------------------------------------------------------------*/
		
		CALLBACKMANAGER.import( getFilenamePath(getSourceFileName()) + "/Callbacks" ) --"./CallBacks/"	
		

		
		/*------------------------------------------------------------------------------
			IMPORT FILES
		--------------------------------------------------------------------------------*/
		(FileInImporter_v root:current_dir files:filein_files blacklist:"*Test*" DEBUG:false ).import()
		
						

		
		/*------------------------------------------------------------------------------
			GENERATE MACROS - import after all functions
		--------------------------------------------------------------------------------*/
		generateMacroscripts( rollouts_dir )
		
		
		/** LOAD CONTENT */
		----ContentLoader	= ContentLoader_v path:(current_dir+content) -- WITHOUT INI FILE --DEV
		
		ContentLoader	= ContentLoader_v path:(current_dir + content_dir)  ini:( getSourceFileName()) width:400
	
		/* CHANGE PROPERTIES oF ROLLOUTS */
		ContentLoader.Dialog.title = "VilTools"
	
		
		/* CREATE DIALOG */
		VILTOOLS = ContentLoader.create height:1024
	

	)catch(
		format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
		format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
		format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
		format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())
	)
)
/*==============================================================================
	OPEN
================================================================================*/
else
(

	VILTOOLS = Dialog_v title:"VilTools"  ini:(getSourceFileName()) width:400
	
	VILTOOLS.create cache:true
)


/*==============================================================================
	POST OPEN
================================================================================*/



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




















