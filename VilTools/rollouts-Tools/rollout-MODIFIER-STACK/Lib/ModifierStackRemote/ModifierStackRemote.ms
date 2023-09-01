clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/ListBoxStack/ListBoxStack.ms" )	-- "./ListBoxStack/ListBoxStack.ms"
filein( getFilenamePath(getSourceFileName()) + "/ModifierStack/ModifierStack.ms" )	-- "./ModifierStack/ModifierStack.ms"


/** Modifier stack remote
 */
struct ModifierStackRemote_v
(
	/* construct */

	/* properties */

	/* dependency */
	ListBox   = ListBoxStack_v(),
	ModsStack = ModifierStack_v(),

	/* reference */
	/* inhered */

	/** Select item
	  *
	  * @param boolean	state	desired state of modifiers
	  * @index integer|#(integer)|#all	items_index	indexes of items in stack (STARTS AT 1)
	  * @param boolean	clear	if TRUE, then new selection is created, if FALSE, then selection is added to current
	 */
	function selectItem state items_index clear:true =
	(
		format "\n"; print "ModifierStackRemote_v.selectItem()"

		this._setArray(&items_index)


		if clear then
			ListBox.unselect()
		else
			this._addToCurrentItems (&items_index)


		ModsStack.selectModByIndex(items_index[1])

		for index in items_index do
			ListBox.selectItem (state) (index)

	),

	/** Items count
	  *
	  */
	function itemsCount =
	(
		--format "\n"; print "ModifierStackRemote_v.itemsCount()"
		ModsStack.pointers.count --return
	),

	/** Find enabled modifier
	  *
	  * @param integer	from_index	index where to start search for modifier
	  * @param #UP|#DOWN	direction	in stack where to search for modifier
	  */
	function findEnabledModifierIndex from_index direction =
	(
		--format "\n"; print "ModifierStackRemote_v.findEnabledModifier()"

		/** Is modifier enabled
		  *
		  */
		function isModifierEnabled pointer =
		(
			_mod = getAnimByHandle pointer

			if superClassOf _mod == modifier then _mod.enabled else true -- test modifier or return true if mod is baseobject
		)

		next_index = case direction of
		(
			#UP: if from_index > 1 then
				for i = from_index - 1 to 1 by -1 where isModifierEnabled(ModsStack.pointers[i]) do return i -- go up

			#DOWN: if from_index < ModsStack.pointers.count then
				for i = from_index + 1 to ModsStack.pointers.count where isModifierEnabled(ModsStack.pointers[i]) do return i -- go down
		)

		if classOf next_index != OkClass then -- if loop return nothing
			next_index --return
	),

	private

	/** Set array
	  *
	  */
	function _setArray &items_index =
	(
		--format "\n"; print "ModifierStackRemote_v._setArray()"
		if classOf items_index != Array then items_index = #(items_index)

		items_index --return
	),

	/** Add to current items
	  *
	  */
	function _addToCurrentItems &items_index =
	(
		--format "\n"; print "ModifierStackRemote_v.addToCurrentItems()"
		selected_items = ListBox.getSlectedItems()

		items_index = sort( makeUniqueArray ( join selected_items items_index ) )

		items_index --return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "ModifierStackRemote.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

	)

)
