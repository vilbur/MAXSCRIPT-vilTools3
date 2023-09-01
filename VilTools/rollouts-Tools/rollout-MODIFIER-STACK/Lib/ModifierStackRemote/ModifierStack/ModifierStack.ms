clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../InstancedModifierFinder/InstancedModifierFinder.ms" )	-- "./../../InstancedModifierFinder/InstancedModifierFinder.ms"

/** Modifier stack
 */
struct ModifierStack_v
(
	/* construct */
	pointers = #(),

	/* dependency */
	InstancedModifierFinder = InstancedModifierFinder_v( selection ),

	/* properties */


	/** Select mod by index
	  *
	  */
	function selectModByIndex index =
	(
		format "\n"; print "ModifierStack_v.selectModByIndex()"
		format "INDEX:	% \n" index
		current_index = this._getIndexByMod( modPanel.getCurrentObject() )

		this.goToIndex (current_index) (index)

	),

	private

	/** Go to index
	  *
	  */
	function goToIndex current_index index =
	(
		format "\n"; print "ModifierStack_v.goToIndex()"
		format "current_index:	% \n" current_index
		format "index:	% \n" index

		direction = if index > current_index or current_index == 1 then #DOWN else #UP
		format "direction:	% \n" direction
		count = case direction of
		(
			#DOWN:	if current_index == items_count then items_count else index - current_index
			#UP:	if current_index == 1           then items_count else current_index - index
		)
		format "count:	% \n" count
		for i = 1 to count do
			if direction == #DOWN then
				max prev mod
			else
				max next mod
	),

	/** Get position of mod in modstack
	  */
	function _getIndexByMod _mod =
	(
		--format "\n"; print "ModifierStack_v.getCurrentItemIndex()"
		this._getPointerIndex (getHandleByAnim _mod)
	),

	/** Get index
	  *
	  */
	function _getPointerIndex pointer =
	(
		--format "\n"; print "ModifierStack_v._getIndex()"
		for i = 1 to pointers.count where pointers[i] == pointer do return i

	),

	/** Set pointers
	  *
	  */
	function _setPointers =
	(
		--format "\n"; print "ModifierStackPointer_v._setPointers()"
		modifiers = if selection.count == 1 then
			append (for _mod in selection[1].modifiers collect _mod) selection[1].baseobject
		else
			InstancedModifierFinder.getInstancedModifiers()

		for _mod in modifiers do
			append this.pointers (getHandleByAnim _mod)
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "ModifierStackPointer.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
		max modify mode

		if selection.count > 0 then
			this._setPointers()

	)

)
