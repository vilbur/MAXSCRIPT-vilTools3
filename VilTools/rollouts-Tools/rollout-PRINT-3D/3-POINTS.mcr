/**
  */
macroscript	_print_platform_generator_normal_length
category:	"_3D-Print"
buttontext:	"Normal Length"
tooltip:	"Length of first segment of platform facing to vertex normal"
icon:	"across:3|control:spinner|type:#integer|range:[ 1, 999, 3 ]|width:64"
(
	format "EventFired:	% \n" EventFired
)

/**
  */
macroscript	_print_platform_generator_use_every_vertex
category:	"_3D-Print"
buttontext:	"Use nth vertex"
tooltip:	"Use every nth vertex of spline"
icon:	"across:3|control:spinner|type:#integer|range:[ 1, 99,1 ]|width:64"
(
	format "EventFired:	% \n" EventFired
)

/**
 */
macroscript	_print_platform_generator_normals_up
category:	"_3D-Print"
buttontext:	"Normal Limit"
icon:	"across:3|control:checkbox|height:32|tooltip:TRUE: Use all verts\n\nFALSE: Use only verts which normal is pointing down or side"

(
	format "EventFired:	% \n" EventFired
)


