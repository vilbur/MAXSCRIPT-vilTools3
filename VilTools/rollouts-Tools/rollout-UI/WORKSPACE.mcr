
/**
 */
macroscript	_workspace_save_current
category:	"ui-dIALOGS"
buttontext:	"Save Current"
tooltip:	""
(
	
	on execute do
	(
		filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-UI\WORKSPACE.mcr"
		
		/* GET CURRENT WORKSPACE */ 
	--	current_workspace = WorkspaceManager.GetCurrentWorkspaceIdentifier()
		--TEMP_dir = getDir #TEMP -- HELP: https://help.autodesk.com/view/MAXDEV/2023/ENU/?guid=GUID-F7577416-051E-478C-BB5D-81243BAAC8EC
	--	workspace_file = (getDir #TEMP) + "\\..\\en-US\\UI\\Workspaces\\" + current_workspace + ".maxsettings"
	--
	--	/* GET TEMPORARY WORKSPACE */ 
	--	temp_workspace = current_workspace + "_temp"
	--
	--	--temp_name = WorkspaceManager.GetWorkspaceNameWithIdentifier current_workspace + " (TEMP)"
	--
	--	WorkspaceManager.CreateNewWorkspace temp_workspace temp_workspace
	--
	--	
	--	/* CHANGE CURRENT WORKSPACE TO TEMP */ 
	--	WorkspaceManager.SetCurrentWorkspaceByIdentifier temp_workspace
	--
	--	/* XmlParser */
	--	XmlParser = XmlParser_v(workspace_file)
	--	
	--	element = XmlParser.getElement "SystemSettings"
	--	
	--	/* SET TRACKBAR VISIBLE */ 
	--	XmlParser.setAttribute element "ShowTrackbar" "true"
	--
	--	
	--	/* REVERT CURRENT WORKSPACE */ 
	--	WorkspaceManager.SetCurrentWorkspaceByIdentifier(current_workspace)
	--
	--	/* ROSET- show trackbar and time slider */ 
	--	WorkspaceManager.ResetToDefaults(current_workspace)
	--
	--	/* DELETE TEMP */ 
	--	WorkspaceManager.DeleteWorkspace(temp_workspace)
		
	)
	
)

