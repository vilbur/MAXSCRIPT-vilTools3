clearListener(); print("Cleared in:"+getSourceFileName())

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

		( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms" ), -- "./../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms"

		"/CallBacks/CallbackManager/CallbackManager.ms", -- "./CallBacks/CallbackManager/CallbackManager.ms"

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
		--"/rollout-EDIT-POLY/Lib/EpolySelection_v.ms",
		--"/rollout-EDIT-POLY/Lib/executeEpolyLoopTool.ms",
		--"/rollout-EDIT-POLY/Lib/executeEpolyMacroWithOptions.ms",

		"/rollout-LAYERS/Lib/LayersManager/LayersManager.ms",	--"./VilTools/rollouts-Tools/rollout-LAYERS/Lib/LayersManager/LayersManager.ms"
		"/rollout-LAYERS/Lib/SceneLayers/SceneLayers.ms",	--"./VilTools/rollouts-Tools/rollout-LAYERS/Lib/SceneLayers/SceneLayers.ms"
		"/rollout-LAYERS/Lib/LayersToogleDialog/LayersToogleDialog.ms",

		"/rollout-VIEWPORTS/Lib/ViewportSwitcher/ViewportSwitcher.ms",
		"/rollout-VIEWPORTS/Lib/ViewportLayoutManager/ViewportLayoutManager.ms",

		"/rollout-MODIFIER-STACK/Lib/LoftRemote/LoftRemote.ms",
		"/rollout-MODIFIER-STACK/Lib/CommandPanel/CommandPanel.ms",
		"/rollout-MODIFIER-STACK/Lib/ModifierStackRemote/ModifierStackRemote.ms",

		--"/rollout-PRINT-3D/Lib/SupportManager/SupportManager.ms",



		"/rollout-EXPORT/rollouts-ExportTo/rollout-ZBRUSH/Lib/MaxToZbrushSync.ms" -- "./VilTools/rollouts-Tools/rollout-EXPORT/rollouts-ExportTo/rollout-ZBRUSH/Lib/MaxToZbrushSync.ms"
	)

	for i = 1 to filein_files.count do
		filein_files[i] =  rollouts_path + filein_files[i]



	insertItem ( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms") filein_files 1

	stdscript_file_path = (getDir #maxroot)+ "/stdplugs/stdscripts/viltools-startup.ms" -- "C:/Program Files\Autodesk\3ds Max 2023\stdplugs\stdscripts\viltools-startup.ms"

	--deleteFile stdscript_file_path

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

filein( getFilenamePath(getSourceFileName()) + "/generateMacroscripts.ms" ) -- "./generateMacroscripts.ms"

/* MANNUAL IMPORT */
filein_files = #(

	"/../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentLoader.ms", -- IMPORT UI FRAMEWORK

	"/../MAXSCRIPT-UI-framework/Lib/Menus/RcMenu/RcMenu.ms" , -- Check if this is necessary to import, it should be imported with framework
	--"/VilTools/rollouts-Tools/rollout-EDIT-POLY/Lib/Epoly.ms",

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


try(
	/* FILE IN FILES */
	for file_path in filein_files where not matchPattern file_path pattern:"*Test*" do
	(
		--format "FILE IN: % \n" (file_path)
		if doesFileExist file_path then
			filein( file_path)
	)

)catch(
	format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
	format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
	format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
	format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())
)





global VILTOOLS
global CALLBACKMANAGER = CallbackManager_v()

filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentLoader.ms" )	-- "./../MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentLoader.ms"

/*------------------------------------------------------------------------------
	START VilTools
------------------------------------------------------------------------------*/
try(

	/** LOAD CONTENT */
	----ContentLoader	= ContentLoader_v path:(current_dir+content) -- WITHOUT INI FILE --DEV
	ContentLoader	= ContentLoader_v path:(current_dir+content_dir)  ini:( getSourceFileName()) width:400

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
	START CALLBACKS
--------------------------------------------------------------------------------*/


/* import when UI exists */
--try
--(
--    --filein( getFilenamePath(getSourceFileName()) + "/VilTools/rollouts-Tools/rollout-EXPORT/Lib/ExportNodeCallbacks/ExportNodeCallback.ms" )	-- "./Rollouts/rollouts-Tools/rollout-EXPORT/Lib/ExportNodeCallbacks/ExportNodeCallback.ms"
--
--	--(NodeList_v()).loadNodes()
--
--	--selectExportNodeInListCallbactAdd()
--
--	--filein( getFilenamePath(getSourceFileName()) + "/generateMacroscripts.ms" ) -- "./generateMacroscripts.ms"
--
--	--if ROLLOUT_layers.CBXBTN_layer_manager.state then
--		--showLayerManagerCallback()
--
--
	--CALLBACKMANAGER.add "setDefaultPropertiesToObject"	#nodeCreated
--
	--CALLBACKMANAGER.add "loadModifierDefaults"	#preModifierAdded
--
--	--CALLBACKMANAGER.add "prependPolySelectModifier"	#postModifierAdded
--
--
--)
--catch(
--	format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
--	format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
--    format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
--	format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())
--
--)
