/**
 *
 */
macroscript	_scene_open_recent
category:	"_Scene"
buttontext:	"Open Recent"
toolTip:	"Open recent scene on Max start"
--icon:	"control:checkButton|menu:_Scene"
icon:	"across:5|width:72|menu:_Scene"
(
	--on isVisible  return maxFileName == ""

	on execute do
	(

		xml_doc = dotNetObject "System.Xml.XmlDocument"

		recent_documents_file = (getDir #maxData) + "RecentDocuments.xml"

		xml_doc.load recent_documents_file

		file_path = xml_doc.GetElementsByTagName "FilePath"
		recent_document = (file_path.item 0).InnerXML


		if maxFilePath == "" or queryBox ("Laod last file ?\n\n"+(getFilenameFile (recent_document))+" ?" ) title:"LAOD RECENT FILE"  beep:false then
			loadMaxFile recent_document quiet:true

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
	--
	)
	--	--messageBox "Open Recent"
)

/*------------------------------------------------------------------------------
	INCREMENTAL SAVE
--------------------------------------------------------------------------------*/

/**
 *
 */
macroscript	_scene_incremental_save
category:	"_Scene"
buttontext:	"Save++"
toolTip:	"Incremental save without user prompt"
icon:	"offset:[-2, 0]"
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

		saveMaxFile path_increment

		/* CREATE COPY OF FILE WITHOUT PREFIX */
		if doesFileExist path_basename then
			deleteFile path_basename

		copyFile path_increment path_basename
	)
)



/*------------------------------------------------------------------------------

	RELOAD \ FETCH \ HLOD

--------------------------------------------------------------------------------*/


/**
 *
 */
macroscript	_scene_relaod
category:	"_Scene"
buttontext:	"Reload"
toolTip:	"Reload cuurent *.max file"
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

/*------------------------------------------------------------------------------

	SAVE \ OPEN RECENT FILE

--------------------------------------------------------------------------------*/


/**
 *
 */
macroscript	_scene_temp_open
category:	"_Scene"
buttontext:	"Open\Save Temp"
toolTip:	"Open Temp File"
icon:	"offset:[14, 0]|width:96"
(
	if maxFilePath == "" or queryBox "Open Temp File ?" title:"Fetch scene"  beep:false then

	--if queryBox "Open Temp File ?" title:"Fetch scene"  beep:false then
		if doesFileExist (max_file = (getDir #temp) + "\\temp.max") then
			loadMaxFile max_file quiet:true
)
/**
 *
 */
macroscript	_scene_temp_save
category:	"_Scene"
buttontext:	"Open\Save Temp"
toolTip:	"Save Temp File"
--icon:	"#(path, index)"
(
	if queryBox "Save Temp File ?" title:"Fetch scene"  beep:false then
		if doesFileExist (max_file = (getDir #temp) + "\\temp.max") then
			saveMaxFile max_file quiet:true
)
