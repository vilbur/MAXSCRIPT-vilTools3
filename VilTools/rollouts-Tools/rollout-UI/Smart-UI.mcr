/** Next
 */
macroscript _smart_ui_Next
category:	"Smart-UI"
buttonText:	"Next"
icon:	"MENU:true"
(

	on execute do (
		 if subObjectLevel == 0 then print "Subobject" else print "Modifier Test"
	)
)

