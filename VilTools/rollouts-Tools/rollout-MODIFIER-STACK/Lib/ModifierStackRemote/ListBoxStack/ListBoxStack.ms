
/**
 */
struct ListBoxStack_v
(
	/* construct */
	hwnd,	-- Command panel HWND
	list_box,  	-- modifier stack HWND

	/* properties */

	/* lsitbox commands */
	LB_GETSEL	= 0x187,
	LB_SETSEL	= 0x0185,
	LB_GETCOUNT	= 0x18B,
	LB_GETTEXT	= 0x189,
	LB_GETTEXTLEN	= 0x18A,

	/* dependency */

	/** Get slected items
	  *
	  * @return array of selected items indexes
	 */
	function getSlectedItems =
	(
		--format "\n"; print "ListBoxStack_v.getSlectedItems()"
		for i = 0 to this.itemsCount() - 1 where ( windows.sendMessage this.list_box LB_GETSEL i 0) == 1 collect (i+1) --returnobj,
	),

	/** unselect all items
	  */
	function unselect =
	(
		--format "\n"; print "ListBoxStack_v.deselect()"
		this._selectItem false -1
	),

	/** Items count
	  *
	  */
	function itemsCount =
	(
		--format "\n"; print "ListBoxStack_v.itemsCount()"
		 windows.sendMessage list_box LB_GETCOUNT 0 0 --return
	),

	/** Select items
	 */
	function selectAll =
	(
		----format "\n"; print "ListBoxStack_v.select()"
		windows.sendMessage this.list_box LB_SETSEL true -1
	),

	/** Select item - 0 index based
	  *
	  * @param boolean 	state desired state of modifiers
	  * @param integer|-1	index of select item, if -1 then all are selected

	 */
	function selectItem state index =
	(
		----format "\n"; print "ListBoxStack_v.select()"
		this._selectItem state (index - 1)
	),

	private

	/** Select item - 0 index based
	  *
	  * @param boolean 	state desired state of modifiers
	  * @param integer|-1	index of select item, if -1 then all are selected

	 */
	function _selectItem state index =
	(
		----format "\n"; print "ListBoxStack_v.select()"
		----format "index = % \n" index
		if index < (this.itemsCount())  then
			windows.sendMessage this.list_box LB_SETSEL state index --return
	),



	/** Get listbox
	 */
	function _setListboxHWND =
	(
		----format "\n"; print "ListBoxStack_v.getListbox()"
		list_box = for c in windows.getChildrenHWND this.hwnd where  c[4] == "ListBox" do exit with c[1] --return
	),

	/** Get items state
	  *
	  * @return array of selected items indexes
	 */
	function _getItemsSelectionStates =
	(
		----format "\n"; print "ListBoxStack_v.getSlectedItems()"
		for i=0 to this.itemsCount() - 1 collect ( windows.sendMessage  this.list_box  LB_GETSEL i 0)
	),

	--/** Get all modifier stack items
	-- */
	--function _getAllItems =
	--(
	--	--format "\n"; print "ListBoxStack_v._getAllItems()"
	--	for i=0 to this.itemsCount() - 1 collect ( this.getListBoxItemText i )
	--),

	/**
	  */
	function getListBoxItemText i =
	(
		Marshal = dotNetClass "System.Runtime.InteropServices.Marshal"

		len = windows.sendMessage this.list_box LB_GETTEXTLEN i 0

		lParam = Marshal.AllocHGlobal (2 * len + 2) asDotNetObject:on

		windows.sendMessage this.list_box LB_GETTEXT i (lParam.ToInt64())

		str = (Marshal.PtrToStringAuto lParam asDotNetObject:on).ToString()

		Marshal.FreeHGlobal lParam

		str -- return
	),


	/** Get command panel
	 */
	function _setCommandPanelHWND =
	(
		GlobalInterface = ( dotNetClass "Autodesk.Max.GlobalInterface").Instance
		RollUp  = GlobalInterface.coreinterface7.CommandPanelRollup

		dialog_hwnd = -1

		if RollUp.Hwnd == 0 then
		(
			dialog_hwnd = RollUp.GetPanelDlg 0

			for i = 1 to 6 do
				dialog_hwnd = UIAccessor.GetParentWindow dialog_hwnd
		)
		else
		(
			dialog_hwnd = RollUp.Hwnd

			for i = 1 to 3 do
				dialog_hwnd = UIAccessor.GetParentWindow dialog_hwnd
		)

		this.hwnd = dialog_hwnd
	),

	/** BACKUP METHOD
	  * HERE ARE PROBLEMS TO GET COMMAND PANEL
	  * IT CAN BE HANDY IN FUTURE
	 */
	function _getFloatingListBoxStack =
	(
		 if cui.commandPanelOpen then
		(
			pop_up_dialogs = UIAccessor.GetPopupDialogs()

			current_max = (maxVersion())[1]/1000-2

			WindowText = "Command Panel"

			cmd_panel_name = if current_max >= 18 then "ListBoxStackWindow" else WindowText

			floatingCmdPanel
			(
				for i in pop_up_dialogs where
				 UIAccessor.GetWindowText i == WindowText

				while FloatingCmdPanel==undefined do
				    floatingCmdPanel= i

			)

			ListBoxStackHWND =
			(
				if floatingCmdPanel != undefined then
				   floatingCmdPanel

				else
					(windows.getChildHWND #max cmd_panel_name)[1]

			)

			if ListBoxStackHWND== undefined then ListBoxStackHWND= windows.getChildHWND intHWND WindowText --this weird line is needed because in max 18 "ListBoxStackWindow" will change to "Command Panel" when we float and dock back the command panel.

			ListBoxStackHWND -- return
		)
	),


	/** Get modifier items count
	 */
	function _setModifiersItemsCount =
	(
		----format "\n"; print "ListBoxStack_v._getModifiersItemsCount()"
		items_count = windows.sendMessage list_box LB_GETCOUNT 0 0 --return
	),


	/** Get obj
	  *
	  */
	function _getObj obj =
	(
		--format "\n"; print "ListBoxStack_v._getObj()"
		--format "superClassOf obj:	% \n" (superClassOf obj)
		--format "superClassOf this.obj:	% \n" (superClassOf this.obj)
		case of
		(
			( superClassOf this.obj	!= value ) :	this.obj
			( superClassOf obj	!= value ) :	obj
			( selection.count > 0 ):	selection[1]
		)
	),

	/**
	 */
	on create do
	(
		max modify mode

		this._setCommandPanelHWND()

		this._setListboxHWND()

		--format "\n"; print "ListBoxStack.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
