/**
 *
 */
macroscript	_scene_open_recent
category:	"_Scene"
buttontext:	"Open Recent"
toolTip:	"Open recent scene on Max start"
icon:	"control:checkButton|menu:_Scene"
(


	on isVisible  return maxFileName == ""

	on execute do
	(
		format "EventFired	= % \n" EventFired
		stdscript_file = (getDir #maxroot)+ "/scripts/Startup/viltools-open-recent.ms"
		ini_file = (getDir #maxroot)+ "/scripts/Startup/viltools-open-recent.ini"

		deleteFile stdscript_file


		if EventFired != undefined and EventFired.val then
		(
			--set_ini = "setINISetting \""+ini_file+"\" \"last_file\" \"1\" (maxFilePath + maxFileName)"

			try( callbacks.addScript #filePostOpen ("setINISetting \""+ini_file+"\" \"last_file\" \"1\" (maxFilePath + maxFileName)") id:#openRecent )catch()
			----try( callbacks.addScript #filePostOpen "print\"Test\"" id:#openRecent )catch()
			--
			stdscript_file = createFile ini_file

			format "%" ("loadMaxFile ( getINISetting \""+ini_file+"\" \"last_file\" \"1\" ) quiet:true") to:stdscript_file

			close stdscript_file

		)
		else
			try( callbacks.removeScripts id:#openRecent )catch()


		--if EventFired == undefined or (EventFired != undefined and EventFired.val == true)  then
		--(
		--	if( last_file = getINISetting ini_file "last_file" "1" ) != "" then
		--		loadMaxFile last_file quiet:true
		--	else
		--		actionMan.executeAction 0 "203"  -- File: Last File 1
		--)

	)
		--messageBox "Open Recent"
)

/**
 *
 */
macroscript	_scene_relaod
category:	"_Scene"
buttontext:	"Reload"
toolTip:	"Relaod cuurent *.max file"
--icon:	"#(path, index)"
(
	if queryBox ("Reload "+maxFileName+" ?") title:"Hold scene"  beep:false then
		loadMaxFile (maxFilePath + maxFileName ) quiet:true

)

/**
 *
 */
macroscript	_scene_hold
category:	"_Scene"
buttontext:	"Hold\Fetch"
toolTip:	"Hold scene"
--icon:	"#(path, index)"
(
	if queryBox "Hold scene ?" title:"Hold scene"  beep:false then
		holdMaxFile()
)

/**
 *
 */
macroscript	_scene_fetch
category:	"_Scene"
buttontext:	"Hold\Fetch"
toolTip:	"Fetch scene"
--icon:	"#(path, index)"
(
	if queryBox "Fetch scene ?" title:"Fetch scene"  beep:false then
	(
		fetchMaxFile quiet:true
		print "SCENE FETCHED"
	)
)


--
--/**
-- *
-- */
--macroscript	_scene_incremental_save
--category:	"_Scene"
--buttontext:	"Incremental Save"
--toolTip:	"Incremental save without user prompt"
----icon:	"#(path, index)"
--(
--	filein (@"c:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-SCENE\Scene.mcr")
--
--	matches = ( dotNetClass "System.Text.RegularExpressions.RegEx" ).matches maxFileName "(.*[^0-9]+)(\d+)*\.max" ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase
--
--	match	= (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value ))[1] --return
--
--	increment_number = if match[3] != undefined then ( match[3] as integer + 1 ) as string  else "1"
--
--	increment_number_string = case increment_number.count of
--	(
--		1: "00" + increment_number
--		2: "0"  + increment_number
--		default: increment_number
--	)
--
--
--	filename  = match[2] + increment_number_string + ".max"
--	save_path = ( maxFilePath + filename )
--
--	if not (file_exists = doesFileExist save_path) or (file_exists and queryBox ("Overwrite file "+filename+" ?") title:"FILE EXISTS" ) then
--	(
--		saveMaxFile save_path
--
--		print "FILE HAS BEEN SAVED"
--	)
--)
