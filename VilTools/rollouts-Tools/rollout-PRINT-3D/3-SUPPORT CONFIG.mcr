--filein( getFilenamePath(getSourceFileName()) + "/Lib/PlatformGenerator/PlatformGenerator.ms" )	-- "./Lib/PlatformGenerator/PlatformGenerator.ms"

--/**
-- */
--macroscript	_print_platform_generator_units_multiplier
--category:	"_3D-Print"
--buttontext:	"Units Multiplier"
----tooltip:	"Platform Generator"
--icon:	"across:2|Control:radiobuttons|items:#('Cylinder', 'Box')|unselect:false|tooltip:Compensate print export size"
--(
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-3D-PRINT\vilTools3.mcr"
--	on execute do
--		format "EventFired:	% \n" EventFired
--		--undo "Generate Platforms" on
--		--(
--		--	platforms = #()
--		--
--		--	_selection = for obj in selection where superClassOf obj == GeometryClass collect obj
--		--
--		--	for obj in _selection where superClassOf obj == GeometryClass do
--		--		join platforms ( (PlatformGenerator_v( obj )).generate() )
--		--
--		--	select platforms
--		--)
--)

--/**
-- */
--macroscript	_print_platform_generator_bind_to_parent
--category:	"_3D-Print"
--buttontext:	"Single Object"
----tooltip:	"Platform Generator"
--icon:	"across:3|Control:checkbox|tooltip:Each platform is independent object if unchcked"
--(
--	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-3D-PRINT\vilTools3.mcr"
--	on execute do
--		format "EventFired:	% \n" EventFired
--		--undo "Generate Platforms" on
--		--(
--		--	platforms = #()
--		--
--		--	_selection = for obj in selection where superClassOf obj == GeometryClass collect obj
--		--
--		--	for obj in _selection where superClassOf obj == GeometryClass do
--		--		join platforms ( (PlatformGenerator_v( obj )).generate() )
--		--
--		--	select platforms
--		--)
--)


/*------------------------------------------------------------------------------

	PLATFORM OPTIONS

--------------------------------------------------------------------------------*/


/** BAR WIDTH
 */
macroscript	_print_platform_generator_bar_width
category:	"_3D-Print"
buttontext:	"Bar width"
tooltip:	"Bar width in mm of printed model.\n\nExported scale is used"
icon:	"across:2|control:spinner|range:[ 1, 99, 1.5 ]|width:64|offset:[ -8, 0]"
(
	format "EventFired:	% \n" EventFired
)

/** EXTRUDE TOP
 */
macroscript	_print_platform_generator_extrude_top
category:	"_3D-Print"
buttontext:	"Top Extrude"
tooltip:	"Top Extrude part in mm of printed model.\n\nExported scale is used"
icon:	"across:2|control:spinner|range:[ 0, 99, 0.5 ]|width:64"
(
	format "EventFired:	% \n" EventFired
)

/**
 */
macroscript	_print_platform_generator_base_width
category:	"_3D-Print"
buttontext:	"Base width"
tooltip:	"Width of base part"
icon:	"across:2|control:spinner|type:#integer|range:[ 0, 99, 4 ]|width:64|offset:[ -6, 0]"
(
	format "EventFired:	% \n" EventFired
)

/**
 */
macroscript	_print_platform_generator_bar_chamfer
category:	"_3D-Print"
buttontext:	"Chamfer Top"
tooltip:	"Chamfer Multiplier of top section of support.\n\n\nCHAMFER MIN: 0\nCHAMFER MAX: 10"
icon:	"across:2|control:spinner|type:#integer|range:[ 0, 10, 5 ]|width:64|offset:[ 0, 0]"
(
	format "EventFired:	% \n" EventFired
)

