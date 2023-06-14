
/**
  *
  */
macroscript	selection_unhide_selected_
category:	"_Selection"
buttontext:	"Unhide Selected"
toolTip:	"Unhide selected objects"
--icon:	"#(path, index)"
(

	undo "Unhide Selected" on
	(
		for obj in selection where obj.isHidden do obj.isHidden = false
	)
)


