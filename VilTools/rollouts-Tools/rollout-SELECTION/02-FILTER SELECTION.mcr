
/*------------------------------------------------------------------------------
	SELECTION FILTERS
--------------------------------------------------------------------------------*/
/** GEOMETRY
  */
macroscript	selection_filter_select_geometry
category:	"_Selection-Filter"
buttontext:	"Select Geometry"
toolTip:	"Toggle Select Geometry \ All. \n\nMenu Option:Filter only Geometry from current selection"
icon:	"MENU:true|across:3"
autoUndoEnabled: true
(
	on isChecked do return GetSelectFilter() == 2

	on execute do
		filterSelectionOrSetFilter type:#GEOMETRY

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
		filterSelectionOrSetFilter type:#SHAPE

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
		filterSelectionOrSetFilter type:#HELPERS

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
icon:	"MENU:true|across:2"
autoUndoEnabled: true

(

	on execute do
	--undo "Filter unique objects" on

	(
		filein( getFilenamePath(getSourceFileName()) + "/Lib/InstaceManager/InstaceManager.ms" )	-- "./Lib/InstaceManager/InstaceManager.ms"

		max create mode

		select ((InstaceManager_v()).filterUnique( selection ))
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
