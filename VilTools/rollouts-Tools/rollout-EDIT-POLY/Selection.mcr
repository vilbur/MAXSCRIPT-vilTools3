filein( getFilenamePath(getSourceFileName()) + "/Lib/SelectionConvertor/SelectionConvertor.ms" ) -- "./Lib/SelectionConvertor/SelectionConvertor.ms"


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