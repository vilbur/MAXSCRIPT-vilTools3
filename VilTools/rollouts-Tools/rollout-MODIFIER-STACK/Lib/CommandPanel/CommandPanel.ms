/** Command panel
 */
struct CommandPanel_v
(
	/* construct */
	hwnd,	-- Command panel HWND
	list_box,  	-- modifier stack HWND

	/* properties */
	items_count,


	/* lsitbox commands */
	LB_GETSEL	= 0x187,
	LB_SETSEL = 0x0185,
	LB_GETCOUNT	= 0x18B,
	LB_GETTEXT = 0x189,
	LB_GETTEXTLEN = 0x18A,

	/** Set state of modifiers in stack
	 *
	 *  @param obj
	 *  @param boolean|#toggle state desired state of modifiers
	 *  @param #ALL|#SELECTED
	 *
	 */
	function setStateSelectedModifiers state which =
	(
		clearListener(); print("Cleared in:"+getSourceFileName())
		format "\n"; print "CommandPanel_v.toggleModifiers()"
		_selection = selection

		if GetCommandPanelTaskMode()!= #modify then
			max modify mode

		if which == #ALL then
			this.selectAllModifiers true

		if (modifiers = selection[1].modifiers).count == 0 then
			return false

		selected_items = this._getSlectedItems()

		if selected_items.count == 0 then
			return false

		selected_modifiers = this.getSelectedModifiers(modifiers)
		--format "SELECTED_MODIFIERS:	% \n" selected_modifiers
		if state == #toggle then
			state = not ((current_state = this._getDominantState (selected_modifiers)) != undefined and current_state == true ) -- swtich state to opposite

		--format "STATE:	% \n"( this._getDominantState (selected_modifiers))

		for selected_modifier in selected_modifiers do
			selected_modifier.enabled = state

		select _selection

		this.selectItem (true) (selected_items)
	),

	/* dependency */
	/* reference */
	/* inhered */

	/** Get selected modifiers
	 */
	function getSelectedModifiers modifiers =
	(
		--format "\n"; print "CommandPanel_v.getSelectedModifiers()"

		selection_states = this._getItemsSelectionStates()
		--format "SELECTION_STATES:	% \n" selection_states
		all_items = this._getAllItems()
		--format "ALL_ITEMS:	% \n" all_items
		selected_items = this._getSelectedItemsInStack (modifiers) (all_items) (selection_states)

		for selected_item in selected_items collect modifiers[selected_item]
	),

	/** Get indexes of modifiers items in lisbox
	  *
	  * @param array modifiers in stack
	  *
	  * @return #(integer)  E.G.: #( 1, 2, 5)
	 */
	function getModifiersListboxIndex modifiers =
	(
		----format "\n"; print "CommandPanel_v.getModifiersListboxIndex()"
		modifier_indexes = #()

		all_items = this._getAllItems()

		--modifiers = for _mod in obj.modifiers collect _mod

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
	  * @index integer|#(integer)|#all	items_index	indexes of items in stack (starts at 1)
	 */
	function selectItem state items_index =
	(
		----format "\n"; print "CommandPanel_v.select()"
		----format "index = % \n" index

		if classOf items_index == Array then
			for index in items_index do
				this._selectItem state (index - 1)

		else
			this._selectItem state (if items_index == #ALL then -1 else items_index )
	),

	/** Select item
	  *
	  * @param boolean 	state desired state of modifiers
	  * @param integer|-1	index of select item, if -1 then all are selected

	 */
	function _selectItem state index =
	(
		----format "\n"; print "CommandPanel_v.select()"
		----format "index = % \n" index

		windows.sendMessage this.list_box LB_SETSEL state index
	),


	/** Select
	 */
	function selectAllModifiers state =
	(
		----format "\n"; print "CommandPanel_v.select()"
		windows.sendMessage this.list_box LB_SETSEL state -1
	),

	private

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

	/** Get modifier items count
	 */
	function _setModifiersItemsCount =
	(
		----format "\n"; print "CommandPanel_v._getModifiersItemsCount()"

		items_count = windows.sendMessage list_box LB_GETCOUNT 0 0 --return
	),

/** Get slected items
	  *
	  * @return array of selected items indexes
	 */
	function _getSlectedItems =
	(
		----format "\n"; print "CommandPanel_v._getSlectedItems()"

		for i=0 to items_count - 1 where ( windows.sendMessage this.list_box LB_GETSEL i 0) == 1 collect (i+1) --returnobj,
	),

	/** Get items state
	  *
	  * @return array of selected items indexes
	 */
	function _getItemsSelectionStates =
	(
		----format "\n"; print "CommandPanel_v._getSlectedItems()"
		for i=0 to items_count-1 collect ( windows.sendMessage  this.list_box  LB_GETSEL i 0)
	),

	/** Get all modifier stack items
	 */
	function _getAllItems =
	(
		--format "\n"; print "CommandPanel_v.getAllModifierStackItems()"

		items = for i=0 to items_count-1 collect ( this.getListBoxItemText i )

	),

	/**
	  *
	  */
	fn getListBoxItemText i =
	(
		local marshal = dotNetClass "System.Runtime.InteropServices.Marshal"

		local len = windows.sendMessage this.list_box LB_GETTEXTLEN i 0
		local lParam = marshal.AllocHGlobal (2 * len + 2) asDotNetObject:on
		windows.sendMessage this.list_box LB_GETTEXT i (lParam.ToInt64())

		local str = (marshal.PtrToStringAuto lParam asDotNetObject:on).ToString()
		marshal.FreeHGlobal lParam
		return str
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

	/**
	 */
	on create do
	(
		this._setCommandPanelHWND()

		this._setListboxHWND()

		this._setModifiersItemsCount()

		--format "\n"; print "CommandPanel.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
