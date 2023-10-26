filein( getFilenamePath(getSourceFileName()) + "/Lib/PlatformGenerator/PlatformGenerator.ms" )	-- "./Lib/PlatformGenerator/PlatformGenerator.ms"

/**
 */
macroscript	_print_platform_generator
category:	"_3D-Print"
buttontext:	"Platform Generator"
tooltip:	"Platform Generator"
(
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-3D-PRINT\vilTools3.mcr"
	on execute do
		undo "Generate Platforms" on
		(
			platforms = #()

			for obj in selection where superClassOf obj == GeometryClass do
				join platforms ( (PlatformGenerator_v( obj )).generate() )

			select platforms
		)
)