clearListener()


filein( getFilenamePath(getSourceFileName()) + "/Lib/DynamicModifyPanel/DynamicModifyPanel.ms" )

filein( getFilenamePath(getSourceFileName()) + "/../Library/UI/Lib/ContentLoader/ContentLoader.ms" )

filein( getFilenamePath(getSourceFileName()) + "/CallBacks/setSelectionLast.ms" )

--filein( getFilenamePath(getSourceFileName()) + "/../Library/UI/Lib/Dialog/Dialog.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/includes.ms" )


--MacroAutoLoader = MacroAutoLoader_v()

--MacroAutoLoader.importScripts()
 
--format "MacroAutoLoader = % \n" MacroAutoLoader._all_files

--for file in MacroAutoLoader._all_files do
--for file in MacroAutoLoader._import_files do
--for file in MacroAutoLoader._inlcudes do
	--format "file = % \n" file

current_dir	= getFilenamePath(getSourceFileName())
format "current_dir = % \n" current_dir

ContentLoader	= ContentLoader_v path:(current_dir+"/VilTools")




--Dialog = ContentLoader.create()
Dialog = ContentLoader.create height:512
--Dialog = ContentLoader.create height:320
--width:720
--ContentLoader.create bgcolor:blue
ContentLoader.Dialog.dock #right

--Dialog.RolloutMain.Layout.fitSubrollouts dialog_height:472
--format "ContentLoader.Dialog = % \n" ContentLoader.Dialog
--ContentLoader.Dialog.undock()

--Dialog.RolloutMain.property height:1024
--format "Dialog.RolloutMain = % \n" Dialog.RolloutMain



--ContentLoader.Dialog.width 320

--(Callbacks_v()).start()



/** DEFINE FLOATER  */
--Dialog	= Dialog_v title:"vilTools3"


/*------ CREATE FLOATER DIALOG ------*/
--Dialog.create()


--Floater.Ini.dir  (getFilenamePath(getSourceFileName()))
--
--/*---------------------------------------
--	CONTENT
-------------------------------------------*/
--
--/* FINAL CONTENT */
--Content	= (Content_v dir:(getFilenamePath(getSourceFileName())+"/*") match:"rollout_(.*)(?<!_test)$").load()
--
--/* TEST CONTETNT */
----Content	= (Content_v dir:(getFilenamePath(getSourceFileName())+"/*") match:"rollout_(.*_test)$").load()
--
--/* ALL */
----Content	= (Content_v dir:(getFilenamePath(getSourceFileName())+"/*") match:"rollout_(.*)$").load()
--
--
--/* Set content to ui */
--Content.setControlsToUI Floater
--
--/*---------------------------------------
--	CREATE DIALOG
-------------------------------------------*/
--
----loadContent()
----Floater.create()
--Floater.create height:1280
--Floater.dock "right"
--
--
--
--/*---------------------------------------
--	CALLBACKS
-------------------------------------------*/
----(EpolyCallbacks_v()).add()
--
--
--/*---------------------------------------
--	STARTUP
-------------------------------------------*/
----ShellLaunch ( getFilenamePath(getSourceFileName()) + "/_Epoly/lib/EpolySelection/selectLoopOrRingOnMouseWheel.ahk" ) ""
----macros.run "_MainUI" "mainui_mini_transform_type_in"
--
----clearListener()
----format "Cleared in vilTools3.ms\n"
----AddSelectExportNodeCallback()
--
--
--
--
