
/*
 *
*/
macroscript smart_subobject_up
category:	"_Subobject-Smart-Remote"
buttonText:	"Smart Up Epoly"
--tooltip:	"Enter\Exit Subobject"
--icon:	"across:6|width:62"
(
	on execute do
		(Subobject_v()).enterExitSubobjectToggle()
)