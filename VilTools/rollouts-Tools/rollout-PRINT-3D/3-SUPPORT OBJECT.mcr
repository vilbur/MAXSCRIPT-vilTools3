
/*------------------------------------------------------------------------------

	PLATFORM OPTIONS

--------------------------------------------------------------------------------*/


/** BAR WIDTH
 */
macroscript	_print_platform_generator_bar_width
category:	"_3D-Print"
buttontext:	"Bar width"
tooltip:	"Bar width in mm of printed model.\n\nExported scale is used"
icon:	"across:2|control:spinner|range:[ 0.1, 99, 1.5 ]|width:64|offset:[ -8, 0]"
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
tooltip:	"Chamfer of support`s top.\n\n\nCHAMFER MIN: 0\nCHAMFER MAX: 10\n\nValue is portion of bar radius.\n\nE.EG: 5 == 50% use of radius"
icon:	"across:2|control:spinner|type:#integer|range:[ 0, 10, 5 ]|width:64|offset:[ 0, 0]"
(
	format "EventFired:	% \n" EventFired
)

