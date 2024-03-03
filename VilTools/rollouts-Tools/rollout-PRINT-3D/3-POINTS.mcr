
/*==============================================================================

		COTNROLS ROW 1

================================================================================*/
/** CHECKBOX
  */
macroscript	_print_platform_generator_normal_use
category:	"_3D-Print"
buttontext:	"Use Normals"
tooltip:	"Use normals to get support direction.\n\nPoints direction is to ground if FALSE "
icon:	"across:2|control:checkbox|range:[ 1, 999, 3 ]"
(
	format "EventFired:	% \n" EventFired
)

/** SPINNER
  */
macroscript	_print_platform_generator_normal_length
category:	"_3D-Print"
buttontext:	"Normal Length"
tooltip:	"Length of first segment of platform facing to vertex normal"
icon:	"across:2|control:spinner|range:[ 1, 999, 3 ]|filedwidth:12"
(
	format "EventFired:	% \n" EventFired
)


/*==============================================================================

		COTNROLS ROW 2

================================================================================*/

/** CHECKBOX
 */
macroscript	_print_platform_generator_normal_always_down
category:	"_3D-Print"
buttontext:	"Keep Down"
icon:	"across:2|control:checkbox|tooltip:Keep secon helper point always lower then first.\n\nIt makes to part of support always pointing down printable."

(
	format "EventFired:	% \n" EventFired
)
/** SPINNER
  */
macroscript	_print_platform_generator_normal_always_down_limit
category:	"_3D-Print"
buttontext:	"Keep down Limit"
tooltip:	"How much must be second point bellow first"
icon:	"across:2|control:spinner|type:#integer|range:[ 1, 99, 1 ]|filedwidth:12"
(
	format "EventFired:	% \n" EventFired
)


/*==============================================================================

		COTNROLS ROW 3

================================================================================*/
/** CHECKBOX
 */
macroscript	_print_platform_generator_normals_up
category:	"_3D-Print"
buttontext:	"Normal Limit"
icon:	"across:2|control:checkbox|tooltip:TRUE: Use all verts\n\nFALSE: Use only verts which normal is pointing down or side"

(
	format "EventFired:	% \n" EventFired
)

/** SPINNER
  */
macroscript	_print_platform_generator_use_every_vertex
category:	"_3D-Print"
buttontext:	"Use nth vertex"
tooltip:	"Use every nth vertex of spline"
icon:	"across:2|control:spinner|type:#integer|range:[ 1, 99,1 ]|filedwidth:12"
(
	format "EventFired:	% \n" EventFired
)
