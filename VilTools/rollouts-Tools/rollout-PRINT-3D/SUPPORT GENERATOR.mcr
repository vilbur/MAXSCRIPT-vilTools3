filein( getFilenamePath(getSourceFileName()) + "/../rollout-VERTEX-COLOR/Lib/meshVertToColorVertexConvertor/MeshVertToColorVertexConvertor.ms" )	--"./../rollout-VERTEX-COLOR/Lib/meshVertToColorVertexConvertor/MeshVertToColorVertexConvertor.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/MeshVertexGetter/MeshVertexGetter.ms" )	--"./Lib/SupportManager/MeshVertexGetter/MeshVertexGetter.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SupportModifiers/SupportModifiers.ms" )	--"./Lib/SupportManager/SupportModifiers/SupportModifiers.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SupportOptions/SupportOptions.ms" )	--"./Lib/SupportManager/SupportOptions/SupportOptions.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SourceObject/SourceObject.ms" )	--"./Lib/SupportManager/SourceObject/SourceObject.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/HelperObject/HelperObject.ms" )	--"./Lib/SupportManager/HelperObject/HelperObject.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SupportObject/SupportObject.ms" )	--"./Lib/SupportManager/SupportObject/SupportObject.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/BeamObject/BeamObject.ms" )	--"./Lib/SupportManager/BeamObject/BeamObject.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/HelperGenerator/HelperGenerator.ms" )	--"./Lib/SupportManager/HelperGenerator/HelperGenerator.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SupportGenerator/SupportGenerator.ms" )	--"./Lib/SupportManager/SupportGenerator/SupportGenerator.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/BeamGenerator/BeamGenerator.ms" )	--"./Lib/SupportManager/BeamGenerator/BeamGenerator.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SupportManager.ms" )	--"./Lib/SupportManager/SupportManager.ms"

/** Get support generator instance
  *
  */
function getSupportManagerInstance =
(
	--format "\n"; print "PLATFORMS GENERATOR.mcr.getSupportManagerInstance()"
	SupportManager = SupportManager_v export_size:ROLLOUT_export.SPIN_export_size.value --use_every_nth_vert_of_spline:ROLLOUT_print_3d.SPIN_use_nth_vertex.value

	Options	= SupportManager.Options
	roll	= ROLLOUT_print_3d

	Options.base_extrude	= roll.SPIN_base_width.value
	Options.extrude_top	= roll.SPIN_top_extrude.value

	Options.layer_height	= roll.SPIN_layer_height.value
	Options.bar_width	= roll.SPIN_bar_width.value
	Options.chamfer_top	= roll.SPIN_chamfer_top.value
	Options.normal_length	= roll.SPIN_normal_length.value

	--Options.cross_section	= roll.CBX_cross_section.state
	--Options.cross_section_max	= roll.SPIN_max_distance.value


	Options.beams_max_distance	= roll.SPIN_max_distance.value
	Options.beams_min_height	= roll.SPIN_min_height.value


	--SupportManager.BeamGenerator.same_height	= roll.CBX_same_height.state



	SupportManager.Options.init()

	SupportManager --return
)



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
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\SUPPORT GENERATOR.mcr"

			if ( points_created = (getSupportManagerInstance()).generatePointHelpers( selection ) reset_helpers: keyboard.controlPressed ).count > 0 then
				select points_created
			--	--format "POINTS_CREATED	= % \n" POINTS_CREATED
		)
)


/*
*/
macroscript	_print_support_generator
category:	"_3D-Print"
buttontext:	"SUPPORTS"
icon:	"across:4|height:32|tooltip:GEENERATE SUPPORTS.\n\nWORKS ON SELECTION OF:\n\t1) SOURCE OBJECT - All supports of object\n\t2) POINTS\n\t3) SUPPORTS - Rebuild selected supports"
(
	on execute do
		undo "Generate Supports" on
		(
			clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\SUPPORT GENERATOR.mcr"

			--SupportManager = getSupportManagerInstance()

			(getSupportManagerInstance()).createSupports( selection as Array )
		)
)

/*
*/
macroscript	_print_support_generator_rafts
category:	"_3D-Print"
buttontext:	"RAFTS"
icon:	"across:4|height:32|tooltip:GEENERATE RAFTS.\n\nWORKS ON SELECTION OF:\n\t1) SOURCE OBJECT\n\t2) POINTS\n\t3) SUPPORTS - Turn support into raft"
(
	on execute do
		undo "Generate Rafts" on
		(
			clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\SUPPORT GENERATOR.mcr"

			--SupportManager = getSupportManagerInstance()

			(getSupportManagerInstance()).createSupports( selection as Array ) raft_mode:true
		)
)


/*
*/
macroscript	_print_support_generator_beams
category:	"_3D-Print"
buttontext:	"BEAMS"
icon:	"across:4|height:32|tooltip:GEENERATE BEAMS between supports.\n\nWORKS ON SELECTION OF:\n\t1) SOURCE OBJECT\n\t2) POINTS\n\t3) SUPPORTS"
(
	on execute do
		undo "Generate Beams" on
		(
			clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\SUPPORT GENERATOR.mcr"

			--SupportManager = getSupportManagerInstance()

			(getSupportManagerInstance()).createBeams( selection as Array )
		)
)