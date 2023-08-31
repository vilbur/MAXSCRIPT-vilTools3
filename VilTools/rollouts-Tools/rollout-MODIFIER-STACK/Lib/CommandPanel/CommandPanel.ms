/** Command panel
 */
struct CommandPanel_v
(
	/* construct */
	hwnd,	-- Command panel HWND
	list_box,  	-- modifier stack HWND

	/* properties */
	obj,

	/* lsitbox commands */
	LB_GETSEL	= 0x187,
	LB_SETSEL	= 0x0185,
	LB_GETCOUNT	= 0x18B,
	LB_GETTEXT	= 0x189,
	LB_GETTEXTLEN	= 0x18A,

	/* dependency */
	/* reference */
	/* inhered */

	/** Find modifier in stack
	  *
	  */
	function findModifierInStack modifiers_search =
	(
		--format "\n"; print "CommandPanel_v.findModifierInStack()"
		--format "modifiers_search:	% \n" modifiers_search
		obj = this._getObj (obj)

		if classOf modifiers_search != Array then
			modifiers_search = #(modifiers_search)

		/** Rename duplicate names
		  *
		  */
		function renameDuplicateNames modifiers_search =
		(
			name_duplicates	= Dictionary (#string)
			white_space = "                                                 "

			for modifier_search in modifiers_search do
			(
				mods_with_same_name = for _mod in obj.modifiers where _mod.name == modifier_search.name collect _mod
				format "mods_with_same_name:	% \n" mods_with_same_name
				if mods_with_same_name.count > 1 then
					 name_duplicates[modifier_search.name] = for i = 1 to obj.modifiers.count where obj.modifiers[i].name == modifier_search.name collect i
			)

			/* TEMP RENAME MODS WQITH SAME NAME */
			for data_pair in name_duplicates do
				 for index in data_pair.value do
					obj.modifiers[index].name +=  white_space + getHandleByAnim obj.modifiers[index] as string

			name_duplicates --return
		)

		/** Restore names
		  *
		  */
		function restoreNames name_duplicates =
		(
			--format "\n"; print "CommandPanel_v.restoreNames()"
			for data_pair in name_duplicates do
				 for index in data_pair.value do
					obj.modifiers[index].name =  data_pair.key
		)

		name_duplicates	= renameDuplicateNames(modifiers_search)

		modifier_indexes = this._getModifiersListboxIndex (modifiers_search)

		restoreNames (name_duplicates)

		modifier_indexes --return
	),



	/** Set state of CURRENTLY SELECTED modifiers in stack
	 *
	 *  @param boolean|#toggle state desired state of modifiers
	 *  @param #ALL|#SELECTED wich items in stack should be set
	 *
	 */
	function setStateSelectedModifiers state which obj: =
	(
		--clearListener(); print("Cleared in:"+getSourceFileName())
		--format "\n"; print "CommandPanel_v.setStateSelectedModifiers()"
		--_selection = selection

		if ( obj = this._getObj (obj) ) != undefined then
		(
			--format "OBJ:	% \n" OBJ
			if GetCommandPanelTaskMode()!= #modify then
				max modify mode

			if which == #ALL then
				this.selectAll

			if (modifiers = obj.modifiers).count == 0 then
				return false

			selected_items = this.getSlectedItems()

			if selected_items.count == 0 then
				return false

			selected_modifiers = this.getSelectedModifiers obj:obj
			--format "SELECTED_MODIFIERS:	% \n" selected_modifiers
			if state == #toggle then
				state = not ((current_state = this._getDominantState (selected_modifiers)) != undefined and current_state == true ) -- swtich state to opposite

			--format "STATE:	% \n"( this._getDominantState (selected_modifiers))

			for selected_modifier in selected_modifiers do
				selected_modifier.enabled = state

			--select _selection

			this.selectItem (true) (selected_items)
		)
	),

	/** Get slected items
	  *
	  * @return array of selected items indexes
	 */
	function getSlectedItems =
	(
		--format "\n"; print "CommandPanel_v.getSlectedItems()"
		for i=0 to this.itemsCount() - 1 where ( windows.sendMessage this.list_box LB_GETSEL i 0) == 1 collect (i+1) --returnobj,
	),

	/** Get selected modifiers
	 */
	function getSelectedModifiers obj: =
	(
		--format "\n"; print "CommandPanel_v.getSelectedModifiers()"
		--format "this._getObj (obj):	% \n" (this._getObj (obj))

		if ( obj = this._getObj (obj) ) != undefined then
			this._getSelectedModifiers( obj.modifiers ) --return
	),

	/** Get obj
	  *
	  */
	function _getObj obj =
	(
		--format "\n"; print "CommandPanel_v._getObj()"
		--format "superClassOf obj:	% \n" (superClassOf obj)
		--format "superClassOf this.obj:	% \n" (superClassOf this.obj)
		case of
		(
			( superClassOf this.obj	!= value ) :	this.obj
			( superClassOf obj	!= value ) :	obj
			( selection.count > 0 ):	selection[1]
		)
	),


	/** Get indexes of modifiers items in lisbox
	  *
	  * @param array modifiers in stack
	  *
	  * @return #(integer)  E.G.: #( 1, 2, 5)
	 */
	function _getModifiersListboxIndex modifiers =
	(
		----format "\n"; print "CommandPanel_v._getModifiersListboxIndex()"
		modifier_indexes = #()

		all_items = this._getAllItems()

		for modifier_index = 1 to modifiers.count do
		(
			item_index = findItem all_items modifiers[modifier_index].name

			all_items[item_index] = undefined

			append modifier_indexes item_index
		)

		modifier_indexes --return
	),



	/** Select item
	  *
	  * @param boolean	state	desired state of modifiers
	  * @index integer|#(integer)|#all	items_index	indexes of items in stack (STARTS AT 1)
	  * @param boolean	clear	if TRUE, then new selection is created, if FALSE, then selection is added to current
	 */
	function selectItem state items_index clear:true =
	(
		format "\n"; print "CommandPanel_v.selectItem()"

		if classOf items_index == Array and items_index.count > 1 then
		(
			/* CLEAR SELECTION */
			if clear then
				this.unselect()

			for index in items_index do
				this._selectItem state (index - 1)
		)
		else if items_index == #ALL then
			this._selectItem state -1

		else
			this.goToItem(items_index)
	),

	/** Select mod in stack
	  */
	function goToItem items_index =
	(
		format "\n"; print "CommandPanel_v.goToItem()"

		new_index	= if classOf items_index == Array then items_index[1] else items_index

		selected_items	= this.getSlectedItems()
		items_count	= this.itemsCount()

		current_index	= selected_items[1]

		is_first_mod_selected	= current_index == 1
		is_base_object_selected	= current_index	== items_count

		select_first_mod	= is_base_object_selected and new_index == 1
		select_baseobject	= new_index == items_count

		is_multiple_items_selected = selected_items.count > 1

		select_opposite_side_of_stack =  (is_first_mod_selected and select_baseobject) or (is_base_object_selected and select_first_mod)

		/*
		   SELECT MOD DIRECTLY IF:
				is multiple items selected

		*/
		if selection.count == 1 and ( is_multiple_items_selected or select_opposite_side_of_stack ) then
		(
			set_modifier = case of
			(
				select_first_mod:	selection[1].modifiers[1]
				select_baseobject:	selection[1].baseobject
				default:	selection[1].modifiers[new_index]
			)

			modPanel.setCurrentObject( set_modifier ) node: selection[1]
		)
		else
		(
			format "ITEMS_COUNT:	% \n" items_count
			format "CURRENT_INDEX:	% \n" current_index

			direction = if new_index > current_index or current_index == 1 then #DOWN else #UP
			format "DIRECTION:	% \n" direction
			format "NEW_INDEX:	% \n" new_index

			count = case direction of
			(
				#DOWN:	if current_index == items_count	then items_count else new_index - current_index
				#UP:	if current_index == 1	           then items_count else current_index - new_index
			)

			for i = 1 to count do
				if direction == #DOWN then
					max prev mod
				else
					max next mod

		)
	),

	/** Select last item
	  *
	  */
	function selectLastItem state =
	(
		--format "\n"; print "CommandPanel_v.selectLastItem()"

		this.selectItem state (this.itemsCount()) clear:false
	),

	/** unselect all items
	  */
	function unselect =
	(
		--format "\n"; print "CommandPanel_v.deselect()"
		this._selectItem false -1
	),

	/** Items count
	  *
	  */
	function itemsCount =
	(
		--format "\n"; print "CommandPanel_v.itemsCount()"
		 windows.sendMessage list_box LB_GETCOUNT 0 0 --return
	),

	/** Select items
	 */
	function selectAll =
	(
		----format "\n"; print "CommandPanel_v.select()"
		windows.sendMessage this.list_box LB_SETSEL true -1
	),

	private
	/** Select item - 0 index based
	  *
	  * @param boolean 	state desired state of modifiers
	  * @param integer|-1	index of select item, if -1 then all are selected

	 */
	function _selectItem state index =
	(
		----format "\n"; print "CommandPanel_v.select()"
		----format "index = % \n" index
		if index < (this.itemsCount())  then

		windows.sendMessage this.list_box LB_SETSEL state index --return
	),

	/** Get selected modifiers
	 */
	function _getSelectedModifiers modifiers =
	(
		format "\n"; print "CommandPanel_v._getSelectedModifiers()"

		selection_states = this._getItemsSelectionStates()
		--format "SELECTION_STATES:	% \n" selection_states
		all_items = this._getAllItems()
		format "ALL_ITEMS:	% \n" all_items
		selected_items = this._getSelectedItemsInStack (modifiers) (all_items) (selection_states)

		for selected_item in selected_items collect modifiers[selected_item]
	),

	/** Find if more modifiers are ENABLED or DISABLED
	  *
	  * @return true|false|undefined return boolean by dominant state of modifiers, undefined if states are equal
	  */
	function _getDominantState modifiers =
	(
		--format "\n"; print "CommandPanel_v._getDominantState()"
		--format "modifiers.count:	% \n" modifiers.count
		--format "modifiers[1].enabled:	% \n" modifiers[1].enabled

		enabled  = for _modifier in modifiers where _modifier.enabled == true  collect _modifier
		disabled = for _modifier in modifiers where _modifier.enabled == false collect _modifier

		if enabled.count != disabled.count then
			enabled.count > disabled.count --return
	),

	/** Get selected modifiers
	  *
	  * Pair command panel tree items with modifiers by name
	 */
	function _getSelectedItemsInStack modifers all_stack_items selection_states =
	(
		--format "\n\n"; print "CommandPanel_v._getSelectedItemsInStack()"
		------format "modifers.count:	% \n" modifers.count
		--format "MODIFERS:	% \n" modifers
		--format "ALL_ITEMS:	% \n" all_stack_items
		--format "SELECTION_STATES:	% \n" selection_states
		modifier_indexes = #()

		for modifier_index = 1 to modifers.count do
		(
			--format "\n\n"
			--format "modifier_index:	% \n" modifier_index
			--format "modifers[modifier_index].name:	% \n" modifers[modifier_index].name
			item_index = findItem all_stack_items modifers[modifier_index].name
			--format "item_index:	% \n" item_index

			if item_index > 0 then
			(
				all_stack_items[item_index] = undefined -- remove item for next loop
				--format "selection_states[item_index]:	% \n" selection_states[item_index]
				if selection_states[item_index] == 1 then
					append modifier_indexes modifier_index
			)
		)
		--format "MODIFIER_INDEXES:	% \n" modifier_indexes
		modifier_indexes --return
	),


	/** Get listbox
	 */
	function _setListboxHWND =
	(
		----format "\n"; print "CommandPanel_v.getListbox()"
		list_box = for c in windows.getChildrenHWND this.hwnd where  c[4] == "ListBox" do exit with c[1] --return
	),




	/** Get items state
	  *
	  * @return array of selected items indexes
	 */
	function _getItemsSelectionStates =
	(
		----format "\n"; print "CommandPanel_v.getSlectedItems()"
		for i=0 to this.itemsCount() - 1 collect ( windows.sendMessage  this.list_box  LB_GETSEL i 0)
	),

	/** Get all modifier stack items
	 */
	function _getAllItems =
	(
		--format "\n"; print "CommandPanel_v._getAllItems()"
		for i=0 to this.itemsCount() - 1 collect ( this.getListBoxItemText i )
	),

	/**
	  */
	function getListBoxItemText i =
	(
		marshal = dotNetClass "System.Runtime.InteropServices.Marshal"

		len = windows.sendMessage this.list_box LB_GETTEXTLEN i 0

		lParam = marshal.AllocHGlobal (2 * len + 2) asDotNetObject:on

		windows.sendMessage this.list_box LB_GETTEXT i (lParam.ToInt64())

		str = (marshal.PtrToStringAuto lParam asDotNetObject:on).ToString()

		marshal.FreeHGlobal lParam

		str -- return
	),

	/** Get command panel
	 */
	function _setCommandPanelHWND =
	(
		local g = (dotNetClass "Autodesk.Max.GlobalInterface").Instance
		local r  = g.coreinterface7.CommandPanelRollup
		local dialog_hwnd = -1

		if r.Hwnd == 0 then
		(
			dialog_hwnd = r.GetPanelDlg 0

			for i = 1 to 6 do
			(
				dialog_hwnd = UIAccessor.GetParentWindow dialog_hwnd
			)
		)
		else
		(
			dialog_hwnd = r.Hwnd
			for i = 1 to 3 do
			(
				dialog_hwnd = UIAccessor.GetParentWindow dialog_hwnd
			)

		)

		this.hwnd = dialog_hwnd
	),

	/** BACKUP METHOD
	  * HERE ARE PROBLEMS TO GET COMMAND PANEL
	  * IT CAN BE HANDY IN FUTURE
	 */
	function _getFloatingCommandPanel =
	(
	   if cui.commandPanelOpen then
		(   local popUpDialogs= UIAccessor.GetPopupDialogs()
			local currentMax= (maxVersion())[1]/1000-2
			local WindowText= "Command Panel"
			local cmdPanelName= if currentMax>=18 then "CommandPanelWindow" else WindowText
			local floatingCmdPanel
			(    for i in PopUpDialogs where
				(    UIAccessor.GetWindowText i == WindowText
				)    while FloatingCmdPanel==undefined do
				(    floatingCmdPanel= i
				)
			)
			local CommandPanelHWND=
			(    if floatingCmdPanel != undefined then
				(    floatingCmdPanel
				)    else
				(    local theHWND= windows.getChildHWND #max cmdPanelName
					theHWND[1]
				)
			)
			if CommandPanelHWND== undefined then CommandPanelHWND= windows.getChildHWND intHWND WindowText --this weird line is needed because in max 18 "CommandPanelWindow" will change to "Command Panel" when we float and dock back the command panel.

			CommandPanelHWND -- return
		)
	),


	/** Get modifier items count
	 */
	function _setModifiersItemsCount =
	(
		----format "\n"; print "CommandPanel_v._getModifiersItemsCount()"
		items_count = windows.sendMessage list_box LB_GETCOUNT 0 0 --return
	),

	/**
	 */
	on create do
	(
		max modify mode

		this._setCommandPanelHWND()

		this._setListboxHWND()

		--format "\n"; print "CommandPanel.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
