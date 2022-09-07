/* DEV */ 
/*
  * IMMPORTANT:	Subobject.ms must be included in folder: "{MaxRooot}/stdplugs/stdscripts/"
  *	Otherwise commands does not work on Max start up before vilTools are executed.
*/ 

--macroscript enter_subobject_toggle
--category:	"_Subobject" 
--buttonText:	"Enter\Exit"
--tooltip:	"Enter\Exit subobject"
--(
--	(Subobject_v()).enterToogleLast()
--)

macroscript enter_subobject_1
category:	"_Subobject" 
buttonText:	"Enter 1"
tooltip:	"Enter to subobject 1"
(
	(Subobject_v()).enterOrQuitSubobject 1
)

macroscript enter_subobject_2
category:	"_Subobject" 
buttonText:	"Enter 2"
tooltip:	"Enter to subobject 2"
(
	(Subobject_v()).enterOrQuitSubobject 2
)

macroscript enter_subobject_3
category:	"_Subobject" 
buttonText:	"Enter 3"
tooltip:	"Enter to subobject 3"
(
	(Subobject_v()).enterOrQuitSubobject 3
)

macroscript enter_subobject_4
category:	"_Subobject" 
buttonText:	"Enter 4"
tooltip:	"Enter to subobject 4"
(
	(Subobject_v()).enterOrQuitSubobject 4
)

macroscript enter_subobject_5
category:	"_Subobject" 
buttonText:	"Enter 5"
tooltip:	"Enter to subobject 5"
(
	(Subobject_v()).enterOrQuitSubobject 5
)

macroscript	enter_subobject_circle_x
category:	"_Subobject" 
buttonText:	"Enter circle"
tooltip:	"Circle subobjects  1, 2, 4"
(
	(Subobject_v()).circle #( 1, 2, 4)
)

