filein( getFilenamePath(getSourceFileName()) + "/Lib/Project.ms" )

/**
 *
 */
macroscript	_project_root_folder
category:	"_Project"
buttontext:	"Project root"
toolTip:	"Path to projects root folder"
--icon:	"control:#browsePath"
icon:	"control:#browsePath|id:#project_root_path"
(
	--if queryBox "Hold scene ?" title:"Hold scene"  beep:false then
		--holdMaxFile()
)

/**
 *
 */
macroscript	_project_name
category:	"_Project"
buttontext:	"Project Name"
--toolTip:	""
--icon:	"control:EditText"
icon:	"control:EditText|id:#project_name_text"
(
	--if queryBox "Hold scene ?" title:"Hold scene"  beep:false then
		--holdMaxFile()
)

/**
 *
 */
macroscript	_project_create_folder_structure
category:	"_Project"
buttontext:	"Create Folders"
--toolTip:	""
--icon:	"control:EditText|id:#test_id"
--icon:	"control:EditText"
(
	filein(@"c:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-PROJECT\Lib\Project.ms")
	filein(@"C:\scripts\MAXSCRIPT-vilTools3\Rollouts\rollouts-Tools\rollout-PROJECT\Project.mcr")

	structure = #(
		#("Max",
			"Export"
		 ),
		"Output",
		"Reference",
		#("Textures", -- if array, then first item is directory and others are subdirecory of that directory
			"Edit",
			"Final",
			"Source"
		),
		"Unreal"
	)

	Project = Project_v structure:structure project_root:ROLLOUT_PROJECT.project_root_path.text project_name:ROLLOUT_PROJECT.project_name_text.text
	--Project = Project_v project.project_name_text.text project.project_root_path.text

	Project.createDirectoryStructure()



	--List = List_v()
	--
	--List.setVal "Max" #()
	--
	--
	--
	--
	--if project_root != "" and project_name != "" then
	--(
	--	root_path = project_root + "\\" + project_name
	--	format "root_path	= % \n" root_path
	--
	--	if not doesDirectoryExist root_path then
	--	(
	--		makeDir root_path all:true
	--
	--	)
	--	else
	--		messageBox ("Project exists already\n\n"+root_path) title:"PATH EXISTS"  beep:false
	--
	--)
	--else
	--	messageBox "Enter project root folder and project name" title:"MISSING PROJECT NAME OR ROOT"  beep:false

)