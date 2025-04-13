/**
 */
macroscript	_scene_relaod
category:	"_Scene-Reset"
buttontext:	"Reload"
toolTip:	"Reload current file"
icon:	"MENU:RELOAD file"
(
	if queryBox ("Reload "+ maxFileName +" ?") title:"Hold scene"  beep:false then
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
		resetMaxFile()
	)
)

macroscript	_scene_open_maxstart_scene
category:	"_Scene-Reset"
buttontext:	"MaxStart Scene"
icon:	"MENU:OPEN MaxStart scene"
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

	RESTART MAX

	Should be in different file, but this is suitbale because of quad menu

--------------------------------------------------------------------------------*/

macroscript	_scene_restart_max
category:	"_Scene-Reset"
buttontext:	"Restart"
tooltip:	"Restart 3Ds Max\n\nCTRL: Quiet mode"
icon:	"MENU:RESTART 3Ds Max"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SCENE\Scene.mcr"
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-SCENE\2-Manage Scene.mcr"

		if keyboard.controlPressed and queryBox "Restart this instance of\n\n  3Ds Max ?" title:"RESTART" then
		(

			max_path = (getDir #maxroot) + "3dsmax.exe"

			file_path = if maxFileName != "" then "\"" + maxFilePath + maxFileName +"\"" else ""

			DOSCommand ("start \"\" \""+ max_path +"\" "+ file_path)

			quitMax #noPrompt quiet:true

		)

	)
)


