--filein( getFilenamePath(getSourceFileName()) + "/../rollout-VERTEX-COLOR/Lib/meshVertToColorVertexConvertor/MeshVertToColorVertexConvertor.ms" )	--"./../rollout-VERTEX-COLOR/Lib/meshVertToColorVertexConvertor/MeshVertToColorVertexConvertor.ms"
--
--filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/MeshVertexGetter/MeshVertexGetter.ms" )	--"./Lib/SupportManager/MeshVertexGetter/MeshVertexGetter.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SupportModifiers/SupportModifiers.ms" )	--"./Lib/SupportManager/SupportModifiers/SupportModifiers.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SupportOptions/SupportOptions.ms" )	--"./Lib/SupportManager/SupportOptions/SupportOptions.ms"
--
--filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SourceObject/SourceObject.ms" )	--"./Lib/SupportManager/SourceObject/SourceObject.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/HelperObject/HelperObject.ms" )	--"./Lib/SupportManager/HelperObject/HelperObject.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SupportObject/SupportObject.ms" )	--"./Lib/SupportManager/SupportObject/SupportObject.ms"
----filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/BeamObject/BeamObject.ms" )	--"./Lib/SupportManager/BeamObject/BeamObject.ms"
--
--filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/HelperGenerator/HelperGenerator.ms" )	--"./Lib/SupportManager/HelperGenerator/HelperGenerator.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SupportGenerator/SupportGenerator.ms" )	--"./Lib/SupportManager/SupportGenerator/SupportGenerator.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/BeamGenerator/BeamGenerator.ms" )	--"./Lib/SupportManager/BeamGenerator/BeamGenerator.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/SupportManager/SupportManager.ms" )	--"./Lib/SupportManager/SupportManager.ms"

/** GET INSTANCE OF SUPPORT GENERATOR
  *
  */
function getSupportManagerInstance =
(
	/** Reg ex replace
	 */
	function regExReplace _string search _replace = ( dotNetObject "System.Text.RegularExpressions.Regex" search ).Replace ( _string as string ) _replace

	SupportManager = SupportManager_v export_size:ROLLOUT_export.SPIN_export_size.value --use_every_nth_vert_of_spline:ROLLOUT_print_3d.SPIN_use_nth_vertex.value

	Options	= SupportManager.Options

	/** FILL SupportManager PROPERTIES WITH DATA FROM UI
	  *
	  * Perform kind of this in loop:
	  *   Options.base_extrude	= roll.SPIN_base_width.value
	  */
	for ctrl in ROLLOUT_print_3d.controls where (prop_key = regExReplace ctrl.name "^(SPIN|BTN|CBX)_" "") != undefined and hasProperty Options prop_key do
		setProperty Options prop_key ctrl.value

	SupportManager.BeamGenerator.same_height	= ROLLOUT_print_3d.CBX_same_height.state

	SupportManager.Options.init()

	SupportManager --return
)


/** GENERATE POINTS
 */
macroscript	_print_support_generate_points
category:	"_3D-Print"
buttontext:	"POINTx"
icon:	"across:4|height:32|tooltip:GENERATE POINTS From selected object.\n\nLAST OBEJCT IS USED IF NOTHING SELECTED"
(
	on execute do
		undo "Generate Points" on
		--undo off
		(
			clearListener(); print("Cleared in:\n"+getSourceFileName())
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\5-SUPPORT GENERATOR.mcr"
			points_created = (getSupportManagerInstance()).generatePointHelpers( selection ) reset_helpers: keyboard.controlPressed

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
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\5-SUPPORT GENERATOR.mcr"

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
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\5-SUPPORT GENERATOR.mcr"

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
			filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-PRINT-3D\5-SUPPORT GENERATOR.mcr"

			--SupportManager = getSupportManagerInstance()

			(getSupportManagerInstance()).createBeams( selection as Array )
		)
)