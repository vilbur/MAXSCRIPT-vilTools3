macroscript	visibility_unhide_selected
category:	"_Visibility"
buttonText:	"Unhide"
tooltip:	"Unhide selected obejcts"
(

	undo "Unhide Selected" on
	(
		for obj in selection where obj.isHidden do obj.isHidden = false
	)

)