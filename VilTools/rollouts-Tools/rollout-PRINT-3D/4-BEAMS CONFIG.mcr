
--/**
--  *
--  */
--macroscript	_print_generator_cross_section
--category:	"_3D-Print"
--buttontext:	"Cross Section"
--tooltip:	"Connect columns of platform with ccross beams"
--icon:	"across:2|control:checkbox"
--(
--	format "EventFired:	% \n" EventFired
--)


/**
  *
  */
macroscript	_print_generator_beams_max_distance
category:	"_3D-Print"
buttontext:	"Max Distance"
tooltip:	"Max distance between between supports"
icon:	"across:2|control:spinner|type:#integer|range:[ 1, 999, 5 ]|width:64"
(
	format "EventFired:	% \n" EventFired
)

/**
  *
  */
macroscript	_print_generator_beams_max_length
category:	"_3D-Print"
buttontext:	"Min Height"
tooltip:	"Min Height of supports where beam is created"
icon:	"across:2|control:spinner|type:#integer|range:[ 1, 999, 5 ]|width:64"
(
	format "EventFired:	% \n" EventFired
)
