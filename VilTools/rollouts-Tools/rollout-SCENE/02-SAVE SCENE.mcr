/**
 */
macroscript	_scene_save
category:	"_Scene-Save"
buttontext:	"Save File"
toolTip:	"Save TEMP File"
icon:	"ACROSS:2|MENU:&Save File"
(
	on isVisible return objects.count > 0

	on execute do
	(
		if maxFileName == "" or keyboard.controlPressed then
		(
			
			file_path = getSaveFileName caption:"Save Script As" types:"Max File (*.max)|All Files (*.*)|*.*" initialDir:(getFilenamePath( maxFilePath ))
			
			if file_path != undefined then
				saveMaxFile file_path quiet:true

		)
		else
		(
			format "\nPress CTRL in menu to 'Save As'"
			
			saveMaxFile ( maxFilePath + maxFileName ) --quiet:true
		)
		
	)
)


/** SAVE TEMP FILE
 */
macroscript	_scene_temp_save
category:	"_Scene-Save"
buttontext:	"Save TEMP"
toolTip:	"Save TEMP File"
icon:	"MENU:true"
(
	on isVisible return objects.count > 0

	on execute do
	(
			if queryBox "Save Temp File ?" title:"Save Temp File"  beep:false then
			--if doesFileExist (max_file = (getDir #temp) + "\\temp.max") then
				--saveMaxFile max_file quiet:true
				saveMaxFile ((getDir #temp) + "\\temp.max") quiet:true
				
		--if keyboard.controlPressed then
		--(
		--	
		--	file_path = getSaveFileName caption:"Save Script As" types:"Max File (*.max)|All Files (*.*)|*.*" initialDir:(getFilenamePath( maxFilePath ))
		--	
		--	if file_path != undefined then
		--	(
		--		saveMaxFile file_path quiet:true
		--
		--	)
		--
		--	
		--)
		--else
		--(
		--	
		--)
		
	)

)

/*------------------------------------------------------------------------------
	INCREMENTAL SAVE
--------------------------------------------------------------------------------*/

/**
 *
 */
macroscript	_scene_incremental_save_with_basename
category:	"_Scene-Save"
buttontext:	"Save++"
toolTip:	"Incremental save and copy basename file version"
--icon:	"offset:[-2, 0]"
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

	 FETCH \ HLOD

--------------------------------------------------------------------------------*/

/**
 *
 */
macroscript	_scene_hold
category:	"_Scene-Save"
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
category:	"_Scene-Save"
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