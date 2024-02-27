filein( getFilenamePath(getSourceFileName()) + "/../rollout-VERTEX-COLOR/Lib/meshVertToColorVertexConvertor/MeshVertToColorVertexConvertor.ms" )	--"./../rollout-VERTEX-COLOR/Lib/meshVertToColorVertexConvertor/MeshVertToColorVertexConvertor.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/MeshVertexGetter/MeshVertexGetter.ms" )	--"./Lib/SupportManager/MeshVertexGetter/MeshVertexGetter.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SupportModifiers/SupportModifiers.ms" )	--"./Lib/SupportManager/SupportModifiers/SupportModifiers.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SupportOptions/SupportOptions.ms" )	--"./Lib/SupportManager/SupportOptions/SupportOptions.ms"

--filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SourceObject/SourceObject.ms" )	--"./Lib/SupportManager/SourceObject/SourceObject.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/HelperObject/HelperObject.ms" )	--"./Lib/SupportManager/HelperObject/HelperObject.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SupportObject/SupportObject.ms" )	--"./Lib/SupportManager/SupportObject/SupportObject.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/BeamGenerator/BeamGenerator.ms" )	--"./Lib/SupportManager/BeamGenerator/BeamGenerator.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/HelperGenerator/HelperGenerator.ms" )	--"./Lib/SupportManager/HelperGenerator/HelperGenerator.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SupportGenerator/SupportGenerator.ms" )	--"./Lib/SupportManager/SupportGenerator/SupportGenerator.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SupportManager.ms" )	--"./Lib/SupportManager/SupportManager.ms"

/** Get support generator instance
  *
  */
function getSupportManagerInstance =
(
	--format "\n"; print "PLATFORMS GENERATOR.mcr.getSupportManagerInstance()"
	SupportManager = SupportManager_v export_size:ROLLOUT_export.SPIN_export_size.value --use_every_nth_vert_of_spline:ROLLOUT_print_3d.SPIN_use_nth_vertex.value


	SupportManager.Options.base_extrude	= ROLLOUT_print_3d.SPIN_base_width.value
	SupportManager.Options.extrude_top	= ROLLOUT_print_3d.SPIN_top_extrude.value

	SupportManager.Options.layer_height	= ROLLOUT_print_3d.SPIN_layer_height.value
	SupportManager.Options.bar_width	= ROLLOUT_print_3d.SPIN_bar_width.value
	SupportManager.Options.chamfer_top	= ROLLOUT_print_3d.SPIN_chamfer_top.value
	SupportManager.Options.normal_length	= ROLLOUT_print_3d.SPIN_normal_length.value

	SupportManager.Options.cross_section	= ROLLOUT_print_3d.CBX_cross_section.state
	SupportManager.Options.cross_section_max	= ROLLOUT_print_3d.SPIN_max_distance.value


	SupportManager --return
)


/** GENERATE POINTS
 */
macroscript	_print_support_generate_points
category:	"_3D-Print"
buttontext:	"POINTS Gen"
tooltip:	"Generate Points From selected object.\n\nLAST OBEJCT IS USED IF NOTHING SELECTED"
icon:	"across:3|height:32|width:128"
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
buttontext:	"SUPPORTS Gen"
tooltip:	"GEnerate supports for selected object or point helepers"
icon:	"across:3|height:32|width:128"
(
	on execute do
		undo "Generate Supports" on
		(
			clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\SUPPORT GENERATOR.mcr"

			SupportManager = getSupportManagerInstance()

			SupportManager.createSupports( selection as Array )
		)
)

/*
*/
macroscript	_print_support_generator_raft
category:	"_3D-Print"
buttontext:	"RAFT Gen"
tooltip:	"GeEnerate rafts for selected object or point helepers"
icon:	"across:3|height:32|width:128"
(
	on execute do
		undo "Generate Rafts" on
		(
			clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\SUPPORT GENERATOR.mcr"

			SupportManager = getSupportManagerInstance()

			SupportManager.createSupports( selection as Array ) raft_mode:true
		)
)