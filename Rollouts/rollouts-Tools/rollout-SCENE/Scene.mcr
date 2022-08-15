




/**  
 *	
 */
macroscript	_scene_open_recent
category:	"_Scene"
buttontext:	"Open Recent"
toolTip:	"Open recent scene on Max start"
icon:	"type:checkButton|menu:_Scene"
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
