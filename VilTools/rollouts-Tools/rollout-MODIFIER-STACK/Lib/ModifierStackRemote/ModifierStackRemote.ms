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
	  * @index integer|#(integer)|#all	items	indexes of items in stack (Index STARTS AT 1)
	  * @param boolean	state	desired state of modifiers
	  * @param boolean	clear	if TRUE, then new selection is created, if FALSE, then selection is added to current
	 */
	function selectItem items state clear:true =
	(
		--format "\n"; print "ModifierStackRemote_v.selectItem()"
		this._getItemsIndex(&items)


		if clear then
			ListBox.unselect()
		else
			this._addToCurrentItems (&items)

		if items.count > 0 then
			ModsStack.selectModByIndex(items[1])

		for index in items do
			ListBox.selectItem (state) (index)
	),

	/** Select by handle
	  *
	  * @index IntegerPtr|#(IntegerPtr)	handles of items in stack
	  */
	function selectByHandle handles state =
	(
		--format "\n"; print "ModifierStackRemote_v.selectByHandle()"
		--format "handles:	% \n" handles
		--format "classOf handles:	% \n" (classOf handles)
		if classOf handles != Array then handles = #(handles)

		items = for handle in handles where (index = ModsStack.getIndexByPointer(handle)) != undefined collect index
		--format "items:	% \n" items
		--format "classOf items:	% \n" (classOf handles)

		this.selectItem (items) (state)
	),

	/** Set state of modifiers in stack
	 *
	 * @param	integer|#(integer)|#ALL|#SELECTED	items	index or name of items to set state
	 * @param	boolean|#toggle	state	desired state of modifiers
	 *
	 */
	function setState items state =
	(
		--format "\n"; print "ModifierStackRemote_v.setState()"
		--format "ITEMS:	% \n" items
		this._getItemsIndex(&items)

		if state == #TOGGLE then
			state = this._getToggleState(items)(#ENABLED)

		this.setProp (items) (#ENABLED) (state)
	),

	/** Set state of modifiers in stack
	 *
	 * @param	integer|#(integer)|#ALL|#SELECTED	items	index or name of items to set state
	 * @pram	#name	property	neame of property to change
	 * @param	boolean|#toggle	val	desired val of modifiers
	 *
	 */
	function setProp items property val =
	(
		--format "\n"; print "ModifierStackRemote_v.setProp()"
		this._getItemsIndex(&items)

		if items == undefined then
			return false

		this._setProp (items) (property) (val)

		this.refresh()
	),

	/** Refresh
	  *
	  */
	function refresh =
	(
		--format "\n"; print "ModifierStackRemote_v.refresh()"
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
	function getModifiers items =
	(
		--format "\n"; print "ModifierStackRemote_v.getModifiers()"
		this._getItemsIndex(&items)

		for index in items collect ModsStack.getModifierByIndex (index)
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
	function _getItemsIndex &items =
	(
		--format "\n"; print "ModifierStackRemote_v._getItemsIndex()"
		--format "ITEMS:	% \n" ITEMS
		items = case of
		(
			(classOf items == integer ):	#(items)
			(classOf items == Array ):	items
			(items == #SELECTED):	ListBox.getSlectedItems()
			(items == #ALL):	#{ 1..(this.itemsCount()) } as Array
		)
		--format "ITEMS_INDEX:	% \n" items
		items --return
	),

	/** Set state of modifier property
	  *
	  * @pram property name of property to change
	  */
	function _setProp items property val =
	(
		--format "\n"; print "ModifierStackRemote_v._setProp()"
		for _mod in this.getModifiers(items) do
			case property of
			(
				#ENABLED:	_mod.enabled	= val
				#NAME:	_mod.name	= val
				default:	if hasProperty _mod property then setProperty _mod property val
			)
	),

	/** Get toggle state
	  *
	  */
	function _getToggleState items property =
	(
		--format "\n"; print "ModifierStackRemote_v.getToggleState()"
		modifiers = this.getModifiers(items)

		current_state = this._getDominantState ( modifiers ) ( property )

		not ( current_state != undefined and current_state == true ) -- get opposite state
	),

	/** Add to current items
	  *
	  */
	function _addToCurrentItems &items =
	(
		--format "\n"; print "ModifierStackRemote_v.addToCurrentItems()"
		selected_items = ListBox.getSlectedItems()

		sort( makeUniqueArray ( join selected_items items ) )
	),

	/** Find if more modifiers are ENABLED or DISABLED
	  *
	  * @return true|false|undefined return boolean by dominant state of modifiers, undefined if states are equal
	  */
	function _getDominantState modifiers property =
	(
		--format "\n"; print "ModifierStackRemote_v._getDominantState()"
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
