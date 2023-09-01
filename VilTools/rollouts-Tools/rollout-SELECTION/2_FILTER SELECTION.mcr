
/*------------------------------------------------------------------------------
	SELECTIONH FILTERS
--------------------------------------------------------------------------------*/
/** GEOMETRY
  */
macroscript	selection_filter_select_geometry
category:	"_Selection-Filter"
buttontext:	"Select Geometry"
toolTip:	"Toggle Select Geometry \ All. \n\nMenu Option:Filter only Geometry from current selection"
icon:	"MENU:true"
autoUndoEnabled: true
(
	on isChecked do return GetSelectFilter() == 2

	on execute do
	(
		if GetSelectFilter() != 2 then SetSelectFilter 2 else SetSelectFilter 1
	)

	on altExecute type do
	(
		deselect ( for obj in selection where superClassOf obj != GeometryClass collect obj  )
	)

)

/** SHAPES
  */
macroscript	selection_filter_select_shapes
category:	"_Selection-Filter"
buttontext:	"Select Shapes"
toolTip:	"Toggle Select Shapes \ All. \n\nMenu Option:Filter only Shapes from current selection"
icon:	"MENU:true"
autoUndoEnabled: true
(
	on isChecked do return GetSelectFilter() == 3

	on execute do
	(
		if GetSelectFilter() != 3 then SetSelectFilter 3 else SetSelectFilter 1
	)

	on altExecute type do
	(
		deselect ( for obj in selection where superClassOf obj != shape collect obj  )
	)

)

/** HELPERS
  */
macroscript	selection_filter_select_helpers
category:	"_Selection-Filter"
buttontext:	"Select Helpers"
toolTip:	"Toggle Select Helpers \ All. \n\nMenu Option:Filter only Helpers from current selection"
icon:	"MENU:true"
autoUndoEnabled: true
(
	on isChecked do return GetSelectFilter() == 6

	on execute do
	(
		if GetSelectFilter() != 6 then SetSelectFilter 6 else SetSelectFilter 1
	)

	on altExecute type do
	(
		deselect ( for obj in selection where superClassOf obj != helper collect obj  )
	)

)




/*------------------------------------------------------------------------------
	FILTER UNIQUE OBJECTS
--------------------------------------------------------------------------------*/
/**
  */
macroscript	selection_filter_unique_objects
category:	"_Selection-Filter"
buttontext:	"Unique"
toolTip:	"Filter only unique objects in selection"
icon:	"MENU:true"
autoUndoEnabled: true

(

	on execute do
	--undo "Filter unique objects" on

	(
		max create mode

		(Selection_v()).filterUniqueObjects()
	)
)


/**
  */
macroscript	selection_filter_visible
category:	"_Selection-Filter"
buttontext:	"Visible"
toolTip:	"Filter only visible objects in selection"
icon:	"MENU:true"
autoUndoEnabled: true
(
	on execute do
	--undo "Filter visible objects" on
	(
		select (for obj in selection where not obj.isHidden collect obj)
	)
)
