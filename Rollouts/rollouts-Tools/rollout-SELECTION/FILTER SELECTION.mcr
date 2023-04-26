
/*------------------------------------------------------------------------------
	FILTER UNIQUE OBJECTS
--------------------------------------------------------------------------------*/

/**
  *
  */
macroscript	selection_filter_unique_objects
category:	"_Selection"
buttontext:	"Unique"
toolTip:	"Filter only unique objects in selection"
--icon:	"#(path, index)"
(

	undo "Filter unique objects" on

	(
		max create mode

		(Selection_v()).filterUniqueObjects()
	)
)


/**
  *
  */
macroscript	selection_filter_visible
category:	"_Selection"
buttontext:	"Visible"
toolTip:	"Filter only visible objects in selection"
--icon:	"#(path, index)"
(

	undo "Filter visible objects" on
	(
		select (for obj in selection where not obj.isHidden collect obj)
	)
)
