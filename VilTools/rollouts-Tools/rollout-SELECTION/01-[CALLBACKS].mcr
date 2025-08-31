
macroscript	selection_select_copied_objects
category:	"_Object-Name"
buttontext:	"SELECT NEW OBJECTS AFTER COPY"
--toolTip:	""
icon:	"control:checkbox|MENU:true|across:1|offset:[0,8]|AUTORUN:TRUE"
(
	--on IsChecked do AUTO_END_RESULT != undefined

	on execute do
	(
		--clearListener(); print("Cleared in:\n"+getSourceFileName())

		if  EventFired == undefined or ( EventFired != undefined and EventFired.val ) then
			CALLBACKMANAGER.start "selectNewNodes" --"./../../../CallBacks/postNodesClonedEnd/selectNewNodes.ms"

		else
			CALLBACKMANAGER.kill "selectNewNodes"
	)
)

