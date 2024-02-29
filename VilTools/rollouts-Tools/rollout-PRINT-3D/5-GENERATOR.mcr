filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SupportManager.ms" )	--"./Lib/SupportManager/SupportManager.ms"

/** GENERATE POINTS
 */
macroscript	_print_support_generate_points
category:	"_3D-Print"
buttontext:	"POINTS"
icon:	"across:4|height:32|tooltip:GENERATE POINTS From selected object.\n\nLAST OBEJCT IS USED IF NOTHING SELECTED"
(
	on execute do
		undo "Generate Points" on
		--undo off
		(
			clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\5-GENERATOR.mcr"
			points_created = (getSupportManagerInstance()).generatePointHelpers( selection ) reset_helpers: keyboard.controlPressed
			--format "POINTS_CREATED: %\n" points_created
			if points_created != undefined then
				select points_created

			if points_created.count == 0 then
				format "NO POINTS HAS BEEN GEERATED"
		)
)


/*
*/
macroscript	_print_support_generator
category:	"_3D-Print"
buttontext:	"SUPPORT"
icon:	"across:4|height:32|tooltip:GEENERATE SUPPORTS.\n\nWORKS ON SELECTION OF:\n\t1) SOURCE OBJECT - All supports of object\n\t2) POINTS\n\t3) SUPPORTS - Rebuild selected supports"
(
	on execute do
		undo "Generate Supports" on
		(
			clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\5-GENERATOR.mcr"

			--SupportManager = getSupportManagerInstance()

			(getSupportManagerInstance()).createSupports( selection as Array )
		)
)

/*
*/
macroscript	_print_support_generator_rafts
category:	"_3D-Print"
buttontext:	"RAFT"
icon:	"across:4|height:32|tooltip:GEENERATE RAFTS.\n\nWORKS ON SELECTION OF:\n\t1) SOURCE OBJECT\n\t2) POINTS\n\t3) SUPPORTS - Turn support into raft"
(
	on execute do
		undo "Generate Rafts" on
		(
			clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\5-GENERATOR.mcr"

			--SupportManager = getSupportManagerInstance()

			(getSupportManagerInstance()).createSupports( selection as Array ) raft_mode:true
		)
)


/*
*/
macroscript	_print_support_generator_beams
category:	"_3D-Print"
buttontext:	"BEAM"
icon:	"across:4|height:32|tooltip:GEENERATE BEAMS between supports.\n\nWORKS ON SELECTION OF:\n\t1) SOURCE OBJECT\n\t2) POINTS\n\t3) SUPPORTS"
(
	on execute do
		undo "Generate Beams" on
		(
			clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\5-GENERATOR.mcr"

			--SupportManager = getSupportManagerInstance()

			(getSupportManagerInstance()).createBeams( selection as Array )
		)
)