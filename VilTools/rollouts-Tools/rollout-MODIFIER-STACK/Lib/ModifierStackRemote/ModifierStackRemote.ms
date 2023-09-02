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
	  * @index integer|#(integer)|#all	items_index	indexes of items in stack (STARTS AT 1)
	  * @param boolean	state	desired state of modifiers
	  * @param boolean	clear	if TRUE, then new selection is created, if FALSE, then selection is added to current
	 */
	function selectItem items_index state clear:true =
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

	/** Set state of modifiers in stack
	 *
	 * @param	integer|#(integer)|#ALL|#SELECTED	items	index or name of items to set state
	 * @pram	#name	property	neame of property to change
	 * @param	boolean|#toggle	state	desired state of modifiers
	 *
	 */
	function setState items property state =
	(
		--format "\n"; print "CommandPanel_v.setState()"

		items_index = case of
		(
			(classOf items == integer ):	#(items)
			(items == #SELECTED):	ListBox.getSlectedItems()
			(items == #ALL):	#{ 1..(this.itemsCount()) } as Array
			default:items
		)

		if state == #TOGGLE then
			state = this._getToggleState(items_index)(property)

		this._setState (items_index) (property) (state)

		this.refresh()
	),

	/** Refresh
	  *
	  */
	function refresh =
	(
		format "\n"; print "ModifierStackRemote_v.refresh()"
		curr_mod = modPanel.getCurrentObject()

		selected_items = ListBox.getSlectedItems()

		if selection.count > 1 then
		(
			current_index = ModsStack.getIndexByMod(curr_mod)

			if current_index < this.itemsCount() then
			(
				max prev mod
				max next mod
			)
			else
			(
				max next mod
				max prev mod
			)
		)
		else
			modPanel.setCurrentObject( curr_mod )

		this.selectItem(selected_items) (true)
	),

	/** Get selected modifiers
	  *
	  */
	function getSelectedModifiers =
	(
		--format "\n"; print "ModifierStackRemote_v.getSelectedModifiers()"
		this.getModifiers( ListBox.getSlectedItems() )
	),

	/** Get modifiers
	  *
	  */
	function getModifiers items_index =
	(
		format "\n"; print "ModifierStackRemote_v.getModifiers()"
		this._setArray(&items_index)

		for index in items_index collect ModsStack.getModifierByIndex (index)
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

	/** Set state of modifier property
	  *
	  * @pram property name of property to change
	  */
	function _setState items_index property state =
	(
		format "\n"; print "ModifierStackRemote_v.setState()"
		this._setArray(&items_index)

		for _mod in this.getModifiers(items_index) do
			setProperty _mod property state

		this.refresh()
	),

	/** Get toggle state
	  *
	  */
	function _getToggleState items_index property =
	(
		--format "\n"; print "ModifierStackRemote_v.getToggleState()"
		modifiers = this.getModifiers(items_index)

		current_state = this._getDominantState ( modifiers ) ( property )

		not ( current_state != undefined and current_state == true ) -- get opposite state
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

	/** Find if more modifiers are ENABLED or DISABLED
	  *
	  * @return true|false|undefined return boolean by dominant state of modifiers, undefined if states are equal
	  */
	function _getDominantState modifiers property =
	(
		--format "\n"; print "CommandPanel_v._getDominantState()"
		--format "modifiers.count:	% \n" modifiers.count
		--format "modifiers[1].enabled:	% \n" modifiers[1].enabled

		enabled  = for _modifier in modifiers where (getProperty _modifier property) == true  collect _modifier
		disabled = for _modifier in modifiers where (getProperty _modifier property) == false collect _modifier

		if enabled.count != disabled.count then
			enabled.count > disabled.count --return
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
