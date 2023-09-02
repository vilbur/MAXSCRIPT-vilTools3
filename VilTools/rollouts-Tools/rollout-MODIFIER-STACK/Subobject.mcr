
/*
  * IMMPORTANT:	Subobject.ms must be included in folder: "{MaxRooot}/stdplugs/stdscripts/"
  *	Otherwise commands does not work on Max start up before vilTools are executed.
*/

macroscript enter_subobject_toggle
category:	"_Subobject"
buttonText:	"Enter\Exit"
tooltip:	"Enter\Exit Subobject"
icon:	"across:6|width:62"
(
	on execute do
		(Subobject_v()).enterExitSubobjectToggle()
)

--macroscript	enter_subobject_circle_x
--category:	"_Subobject"
--buttonText:	"Enter circle"
--tooltip:	"Circle subobjects  1, 2, 4"
--(
--	format "EventFired = % \n" EventFired
--	(Subobject_v()).circle #( 1, 2, 4)
--)


macroscript enter_subobject_1
category:	"_Subobject"
buttonText:	"Enter 1"
tooltip:	"Enter to subobject 1"

icon:	"across:6|width:62"
(
	format "EventFired = % \n" EventFired
	(Subobject_v()).enterOrQuitSubobject 1
)

macroscript enter_subobject_2
category:	"_Subobject"
buttonText:	"Enter 2"
tooltip:	"Enter to subobject 2"
(
	format "EventFired = % \n" EventFired
	(Subobject_v()).enterOrQuitSubobject 2
)

macroscript enter_subobject_3
category:	"_Subobject"
buttonText:	"Enter 3"
tooltip:	"Enter to subobject 3"
(
	format "EventFired = % \n" EventFired
	(Subobject_v()).enterOrQuitSubobject 3
)

macroscript enter_subobject_4
category:	"_Subobject"
buttonText:	"Enter 4"
tooltip:	"Enter to subobject 4"
(
	format "EventFired = % \n" EventFired
	(Subobject_v()).enterOrQuitSubobject 4
)

macroscript enter_subobject_5
category:	"_Subobject"
buttonText:	"Enter 5"
tooltip:	"Enter to subobject 5"
(
	format "EventFired = % \n" EventFired
	(Subobject_v()).enterOrQuitSubobject 5
)



/*------------------------------------------------------------------------------

	CONVERT SUBOBJECT

--------------------------------------------------------------------------------*/

macroscript	epoly_convert_subobject_to_1
category:"_Epoly-Convert-Selection"
buttonText:"To vertex"
tooltip:	"Convert subobject to vertex"
icon:	"across:5|width:72"
(
	(SelectionConvertor_v()).convertSelection #vertex
)

macroscript	epoly_convert_subobject_to_edge
category:"_Epoly-Convert-Selection"
buttonText:"To edge"
tooltip:	"Convert subobject to edge"
(
	(SelectionConvertor_v()).convertSelection #edge
)

macroscript	epoly_convert_subobject_to_border
category:"_Epoly-Convert-Selection"
buttonText:"To border"
tooltip:	"Convert subobject to border"
(
	(SelectionConvertor_v()).convertSelection #border
)

macroscript	epoly_convert_subobject_to_face
category:"_Epoly-Convert-Selection"
buttonText:"To face"
tooltip:	"Convert subobject to face"
(
	(SelectionConvertor_v()).convertSelection #face
)

macroscript	epoly_convert_subobject_to_element
category:"_Epoly-Convert-Selection"
buttonText:"To element"
tooltip:	"Convert subobject to element"
(
	(SelectionConvertor_v()).convertSelection #element
)
