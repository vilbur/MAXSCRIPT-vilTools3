filein( getFilenamePath(getSourceFileName()) + "/RecentFile/RecentFile.ms" ) -- "./RecentFile/RecentFile.ms"

/** OPEN FILE DIALOG
 *
 */
macroscript	_scene_open_file
category:	"_Scene"
buttontext:	"OPEN File"
toolTip:	"Open File Dialog"
--icon:	"control:checkButton|MENU:_Scene"
icon:	"across:3|MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SCENE\Scene.mcr"
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SCENE\1-Scene.mcr"

		init_dir = if (last_file = (RecentFile_v()).getRecentFileNotMatching blacklist:#( "temp", "autoback" )) != undefined then getFilenamePath( last_file ) else unsupplied

		file_path = getOpenFileName caption:"Open File" types:"3ds Max(*.max)" filename:(init_dir) historyCategory:"MAXScriptFileOpenSave"

		if file_path != undefined then
		(
			start_time = timestamp()

			loadMaxFile file_path quiet:true

			format "SCENE OPEN TIME % s\n" ( ((timestamp()) - start_time) / 1000.0 )
		)

	)
)
/**
 *
 */
macroscript	_scene_open_recent
category:	"_Scene"
buttontext:	"RECENT"
toolTip:	"Open recent scene on Max start"
--icon:	"control:checkButton|MENU:_Scene"
icon:	"MENU:Open &Recent"
(
	--on isVisible  return maxFileName == ""

	on execute do
	(
		recent_file = (RecentFile_v()).getRecentFileNotMatching blacklist:#( "autoback", "maxstart", "temp" )
		if recent_file != undefined and doesFileExist recent_file then
		(
			if  maxFilePath == "" or queryBox ("Load recent file ?\n\n"+(getFilenameFile (recent_file))+" ?" ) title:"LOAD RECENT FILE"  beep:false then
			(
				start_time = timestamp()

				loadMaxFile recent_file quiet:true

				format "RECENT_FILE: %\n" recent_file
				format "SCENE OPEN TIME % s\n" ( ((timestamp()) - start_time) / 1000.0 )
			)
		)
		else if recent_file != undefined then
			print ("FILE DOES NOT EXISTS:\n\n"+recent_file)

	)


	/*
			BELLOW IS CODE FOR OPENING RECENT FILE ON MAX START
	*/
	--
	----	format "EventFired	= % \n" EventFired
	----	stdscript_file = (getDir #maxroot)+ "/scripts/Startup/viltools-open-recent.ms"
	----	ini_file = (getDir #maxroot)+ "/scripts/Startup/viltools-open-recent.ini"
	----
	----	deleteFile stdscript_file
	----
	----
	----	if EventFired != undefined and EventFired.val then
	----	(
	----		--set_ini = "setINISetting \""+ini_file+"\" \"last_file\" \"1\" (maxFilePath + maxFileName)"
	----
	----		try( callbacks.addScript #filePostOpen ("setINISetting \""+ini_file+"\" \"last_file\" \"1\" (maxFilePath + maxFileName)") id:#openRecent )catch()
	----		----try( callbacks.addScript #filePostOpen "print\"Test\"" id:#openRecent )catch()
	----		--
	----		stdscript_file = createFile ini_file
	----
	----		format "%" ("loadMaxFile ( getINISetting \""+ini_file+"\" \"last_file\" \"1\" ) quiet:true") to:stdscript_file
	----
	----		close stdscript_file
	----
	----	)
	----	else
	----		try( callbacks.removeScripts id:#openRecent )catch()
	--
	--
	--	--if EventFired == undefined or (EventFired != undefined and EventFired.val == true)  then
	--	--(
	--	--	if( last_file = getINISetting ini_file "last_file" "1" ) != "" then
	--	--		loadMaxFile last_file quiet:true
	--	--	else
	--	--		actionMan.executeAction 0 "203"  -- File: Last File 1
	--	--)
	--startObjectCreation
	--)
	--	--messageBox "Open Recent"
)



/*------------------------------------------------------------------------------

	SAVE \ OPEN RECENT FILE

--------------------------------------------------------------------------------*/

/**
 */
macroscript	_scene_temp_open
category:	"_Scene"
buttontext:	"TEMP"
toolTip:	"Open TEMP File"
icon:	"MENU:Open &TEMP File"
(
	on execute do
	(
		if maxFilePath == "" or queryBox "Open Temp File ?" title:"Open Temp File"  beep:false then

		--if queryBox "Open Temp File ?" title:"Fetch scene"  beep:false then
			if doesFileExist (max_file = (getDir #temp) + "\\temp.max") then
				loadMaxFile max_file quiet:false

	)
)


/*------------------------------------------------------------------------------
	OPEN MaxStart.max
--------------------------------------------------------------------------------*/

macroscript	_scene_open_maxstart_scene
category:	"_Scene"
buttontext:	"MaxStart"
toolTip:	"Open MaxStart"
icon:	"ACROSS:2|MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SCENE\Scene.mcr"
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SCENE\2-Manage Scene.mcr"

		if queryBox "Open Max start scene ?\n\nmaxStart.max" title:"OPEN MASTART" then
		(
			--scene_dir = getDir #SCENE
			max_file = (getDir #MAXSTART) + "\\maxstart.max"
			
			if not doesFileExist max_file then
				saveMaxFile max_file quiet:true

			loadMaxFile max_file quiet:false
		)

	)
)


/*------------------------------------------------------------------------------

	 OPEN FILE DIALOG AT AUTOBACKUP DIR

--------------------------------------------------------------------------------*/


macroscript	_scene_open_autobackup
category:	"_Scene"
buttontext:	"Autobackup"
toolTip:	"Open Autobackup File"
--icon:	"control:checkButton|MENU:_Scene"
--icon:	"across:5|width:72|MENU:true"
icon:	"MENU:true|MENU:Open AUTOBACKUP"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SCENE\Scene.mcr"
	on execute do
	(

		file_path = getOpenFileName caption:"Open File" types:"3ds Max(*.max)" filename:( getDir( #autoback ) + "\\" ) historyCategory:"MAXScriptFileOpenSave"

		if file_path != undefined then
			loadMaxFile file_path quiet:true

	)
)