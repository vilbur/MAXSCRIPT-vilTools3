/**
 */
macroscript	_scene_relaod
category:	"_Scene-Reset"
buttontext:	"Reload"
toolTip:	"Reload current file"
icon:	"across:3|MENU:RELOAD file"
(
	on execute do
		if queryBox ("Reload "+ maxFileName +" ?") title:"Reload scene" then
			loadMaxFile ( maxFilePath + maxFileName ) quiet:true
)


macroscript	_scene_reset
category:	"_Scene-Reset"
buttontext:	"Reset Scene"
icon:	"MENU:RESET Scene"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SCENE\Scene.mcr"
	on execute do
	(
		
		if objects.count > 0 then
			resetMaxFile()
		
		else
			resetMaxFile #noPrompt
		
	)
)


/*------------------------------------------------------------------------------

	RESTART MAX

	Should be in different file, but this is suitbale because of quad menu

--------------------------------------------------------------------------------*/

macroscript	_scene_restart_max
category:	"_Scene-Reset"
buttontext:	"Restart"
tooltip:	"Restart 3Ds Max\n\nCTRL: Quiet mode"
icon:	"MENU: --- RESTART 3Ds Max ---"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SCENE\Scene.mcr"
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SCENE\2-Manage Scene.mcr"

		--if keyboard.controlPressed or queryBox "Restart this instance of\n\n  3Ds Max ?" title:"RESTART" then
		if queryBox "Restart this instance of\n\n  3Ds Max ?" title:"RESTART" then
		(
			max_path = (getDir #maxroot) + "3dsmax.exe"

			file_path = if maxFileName != "" then "\"" + maxFilePath + maxFileName +"\"" else ""

			wait_for_max_is_closed = 3 as string -- wait them max is closed ( 3DsMax .ini needs to be saved )
			
			DOSCommand ("cmd /c start \"\" cmd /c \"timeout /t "+wait_for_max_is_closed+" >nul & start \"\" \""+ max_path +"\" "+ file_path) 

			quitMax #noPrompt quiet:true
		)
	)
)


macroscript	_scene_kill_max_current_instance
category:	"_Scene-Reset"
buttontext:	"Kill"
tooltip:	"KILL current 3Ds Max instance"
--icon:	"MENU: --- RESTART 3Ds Max ---"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SCENE\Scene.mcr"
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SCENE\2-Manage Scene.mcr"

		--if keyboard.controlPressed or queryBox "Restart this instance of\n\n  3Ds Max ?" title:"RESTART" then
		if queryBox "KILL and restart this instance of\n\n  3Ds Max ?" title:"RESTART" then
		(
			max_path = (getDir #maxroot) + "3dsmax.exe"

			pid = ((dotNetClass "System.Diagnostics.Process").GetCurrentProcess()).Id
	
			file_path = if maxFileName != "" then "\"" + maxFilePath + maxFileName +"\"" else ""

			
			/* START NEW MAX */ 		
			DOSCommand ("start \"\" \""+ max_path +"\" "+ file_path)
			
			/* KILL CURRWNT MAX */ 
			DOSCommand ("cmd /c start \"\" taskkill /f /pid " + pid as string)
		)
	)
)
