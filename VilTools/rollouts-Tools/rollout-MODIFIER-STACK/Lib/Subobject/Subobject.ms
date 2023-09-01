
global LAST_USED_SUBOBJECT_LEVEL = Dictionary ( #string )

/** Enter or quit subobject on selection
  *
  * If modifier with subobjects is not actieve then:
  * 	1) Edit poly   modifier is added to selection
  * 	2) Edit spline modifier is added if only shapes are selected
  *
 */
struct Subobject_v
(
	/* construct */
	/* properties */
	curr_mod,

	/* dependency */
	/* reference */
	/* inhered */

	/** 1) Enter to last used subobject
	  * 2) Exit if subObjectLevel is active
	  */
	function enterExitSubobjectToggle =
	(
		format "\n"; print "Subobject_v.enterExitSubobject()"
		if( GetCommandPanelTaskMode() != #modify ) then
			max modify mode

		if ( this.curr_mod = modPanel.getCurrentObject() ) != undefined and numSubObjectLevels > 0 then
		(
			/* EXIT  */
			if subObjectLevel != 0  then
			(
				LAST_USED_SUBOBJECT_LEVEL[this._getModPointer()] = subObjectLevel

				subObjectLevel = 0
			)
			else
				/* ENTER */
				subObjectLevel = if ( last_level = LAST_USED_SUBOBJECT_LEVEL[this._getModPointer()] ) != undefined then last_level else 1
		)

	),


	/** Enter or quit subobject
	 */
	function enterOrQuitSubobject sub_obj =
	(
		--format "\n"; print "Subobject_v.enterOrQuitSubobject()"
		this.curr_mod = modPanel.getCurrentObject()

		if selection.count == 0 or this.curr_mod == undefined then
			return false

		max modify mode

		if numSubObjectLevels != 0 then
			this._enterOrQuitSubobject(sub_obj)

		else
			this._addEditModier(sub_obj)
	),


	private

	/** Get mod pointer
	  *
	  */
	function _getModPointer =
	(
		--format "\n"; print "Subobject_v.getModPointer()"
		(getHandleByAnim this.curr_mod) as string
	),


	/** Try add subobject modier
	 */
	function _addEditModier sub_obj =
	(
		--format "\n"; print "Subobject_v.addEditModier()"
		this._filterGeometryAndShapesFromSelection()

		if this._areAllObejctsShapes() then
			modPanel.addModToSelection (Edit_Spline ()) ui:on
		else
			modPanel.addModToSelection (Edit_Poly ()) ui:on

		if numSubObjectLevels != 0 then
			this._enterOrQuitSubobject(sub_obj)
	),

	/** Filter geometry and shapes from selection
	 */
	function _filterGeometryAndShapesFromSelection =
	(
		--format "\n"; print "Subobject_v._filterGeometryAndShapesFromSelection()"
		filtered_selection = for o in selection where superClassOf o == GeometryClass or superClassOf o == shape collect o

		clearSelection()

		select filtered_selection
	),

	/** Are all obejcts shapes
	 */
	function _areAllObejctsShapes =
	(
		--format "\n"; print "Subobject_v._areAllObejctsShapes()"
		selected_shapes = for o in selection where superClassOf o == shape collect o
		--format "selected_shapes.count == selection.count	= % \n" (selected_shapes.count == selection.count)
		selected_shapes.count == selection.count
	),

	/** Enter or quit subobject
	 */
	function _enterOrQuitSubobject sub_obj =
	(
		--format "\n"; print "Subobject_v._enterOrQuitSubobject()"
		if subObjectLevel != 0 then
			LAST_USED_SUBOBJECT_LEVEL[this._getModPointer()] = subObjectLevel

		subObjectLevel = if subObjectLevel != sub_obj then sub_obj else 0
	),



	/**
	 */
	on create do
	(
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)
)