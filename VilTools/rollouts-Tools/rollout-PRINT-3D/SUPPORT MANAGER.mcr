filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SupportManager.ms" )	--"./Lib/SupportManager/SupportManager.ms"

/** GENERATE POINTS
 */
macroscript	_print_support_generate_points
category:	"_3D-Print"
buttontext:	"Generate Points"
tooltip:	"Generate Points From selected object.\n\nLAST OBEJCT IS USED IF NOTHING SELECTED"
icon:	"across:3|height:32|width:128"
(
	on execute do
		undo "Generate Points" on
		--undo off
		(
			clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\SUPPORT MANAGER.mcr"

			--if ( points_created = (getPlatformGeneratorInstance()).generatePointHelpers( selection ) ).count > 0 then
			--	select points_created
			--	--format "POINTS_CREATED	= % \n" POINTS_CREATED
		)
)
