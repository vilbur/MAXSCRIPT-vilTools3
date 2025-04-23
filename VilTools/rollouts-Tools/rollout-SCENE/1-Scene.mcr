filein( getFilenamePath(getSourceFileName()) + "/RecentFile/RecentFile.ms" ) -- "./RecentFile/RecentFile.ms"

/** OPEN FILE DIALOG
 *
 */
macroscript	_scene_open_file
category:	"_Scene"
buttontext:	"Open File"
toolTip:	"Open File Dialog"
--icon:	"control:checkButton|MENU:_Scene"
icon:	"across:5|width:72|MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SCENE\Scene.mcr"
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SCENE\1-Scene.mcr"

		init_dir = if (last_file = (RecentFile_v()).getRecentFileNotMatching #( "temp", "autoback" )) != undefined then getFilenamePath( last_file ) else unsupplied

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
buttontext:	"Open Recent"
toolTip:	"Open recent scene on Max start"
--icon:	"control:checkButton|MENU:_Scene"
icon:	"across:5|width:72|MENU:Open &Recent"
(
	--on isVisible  return maxFileName == ""

	on execute do
	(
		recent_file = (RecentFile_v()).getRecentFileNotMatching #( "autoback", "temp" )

		if recent_file != undefined and doesFileExist recent_file then
		(
			if  maxFilePath == "" or queryBox ("Laod last file ?\n\n"+(getFilenameFile (recent_file))+" ?" ) title:"LAOD RECENT FILE"  beep:false then
			(
				start_time = timestamp()

				loadMaxFile recent_file quiet:true

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
	INCREMENTAL SAVE
--------------------------------------------------------------------------------*/

/**
 *
 */
macroscript	_scene_incremental_save_with_basename
category:	"_Scene"
buttontext:	"Save++"
toolTip:	"Incremental save and copy basename file version"
icon:	"offset:[-2, 0]"
(
	on execute do
	(

		file_path = maxFilePath
		file_name = maxFileName

		if file_path == "" and (file_path_new = getMAXSaveFileName()) != undefined then
		(
			file_path = getFilenamePath(  file_path_new )
			file_name = filenameFromPath( file_path_new )
		)

		if file_path != "" then
		(
			matches = ( dotNetClass "System.Text.RegularExpressions.RegEx" ).matches file_name "(.*[^0-9]+)(\d+)*\.max" ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase

			match	= (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value ))[1] --return

			basename	= trimRight match[2] "-"
			suffix_current	= match[3]

			if (suffix_current = match[3]) == "" then
				suffix_current = "001"

			path_basename  = file_path + "\\" + basename
			path_increment = path_basename + "-" + suffix_current

			/*------ FIND NEXT AVAILABLE INCREMENTAL FILENAME ------*/
			while doesFileExist (path_increment + ".max") do
			(
				suffix_current = (suffix_current as integer ) + 1

				digit_prefix = case ( suffix_current as string ).count of -- create number string with 3 digits E.G.: "099"
				(
					1: "00"
					2: "0"
					default: ""
				)

				path_increment = path_basename + "-" + digit_prefix + suffix_current as string
			)

			path_basename  += ".max"
			path_increment += ".max"

			format "path_increment	= % \n" path_increment
			format "doesFileExist path_increment	= % \n" (doesFileExist path_increment)

			if not (file_exists = doesFileExist path_increment) or (file_exists and queryBox ("Overwrite file "+filename+" ?") title:"FILE EXISTS" ) then
			(
				saveMaxFile path_increment

				/* CREATE COPY OF FILE WITHOUT PREFIX */
				if doesFileExist path_basename then
					deleteFile path_basename


				/* COPY FILE WITHOUT SUFFIX NUMBER */
				copyFile path_increment path_basename

				print "File has been saved"

			)
		)
	)
)


/*------------------------------------------------------------------------------

	SAVE \ OPEN RECENT FILE

--------------------------------------------------------------------------------*/

/**
 */
macroscript	_scene_temp_open
category:	"_Scene"
buttontext:	"Open\Save Temp"
toolTip:	"OPEN TEMP File"
icon:	"offset:[14, 0]|width:96|MENU:Open &Temp File"
(
	on execute do
	(
		if maxFilePath == "" or queryBox "Open Temp File ?" title:"Open Temp File"  beep:false then

		--if queryBox "Open Temp File ?" title:"Fetch scene"  beep:false then
			if doesFileExist (max_file = (getDir #temp) + "\\temp.max") then
				loadMaxFile max_file quiet:false

	)
)
/**
 */
macroscript	_scene_temp_save
category:	"_Scene"
buttontext:	"Open\Save Temp"
toolTip:	"SAVE TEMP File"
icon:	"MENU:tooltip"
(
	on isVisible return objects.count > 0

	on execute do
		if queryBox "Save Temp File ?" title:"Save Temp File"  beep:false then
			--if doesFileExist (max_file = (getDir #temp) + "\\temp.max") then
				--saveMaxFile max_file quiet:true
				saveMaxFile ((getDir #temp) + "\\temp.max") quiet:true

)

/*------------------------------------------------------------------------------

	 OPEN FILE DIALOG AT AUTOBACKUP DIR

--------------------------------------------------------------------------------*/


macroscript	_scene_open_autobackup
category:	"_Scene"
buttontext:	"Open Autobackup"
toolTip:	"Open Autobackup File"
--icon:	"control:checkButton|MENU:_Scene"
--icon:	"across:5|width:72|MENU:true"
icon:	"MENU:true"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SCENE\Scene.mcr"
	on execute do
	(

		file_path = getOpenFileName caption:"Open File" types:"3ds Max(*.max)" filename:( getDir( #autoback ) + "\\" ) historyCategory:"MAXScriptFileOpenSave"

		if file_path != undefined then
			loadMaxFile file_path quiet:true

	)
)
