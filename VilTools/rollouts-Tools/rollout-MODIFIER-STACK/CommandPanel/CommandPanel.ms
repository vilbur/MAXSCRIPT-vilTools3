/** Command panel
 */
struct CommandPanel_v
(
	/* construct */
	obj,

	/* properties */
	hwnd,	-- Command panel HWND
	list_box,  	-- modifier stack HWND

	/* dependency */
	/* reference */
	/* inhered */
	/** Get selected modifiers
	 */
	function getSelectedModifiers =
	(
		format "\n"; print "CommandPanel_v.getSelectedModifiers()"

		items_count = this.getModifiersItemsCount()

		selected = this.getSlectedItems(items_count)

		all_items = this._getAllModifierStackItems(items_count)

		modifers = for _mod in obj.modifiers collect _mod


		format "\n"
		print "ALL_ITEMS"

		for item in all_items do
			format "item = % \n" item


		format "\n"
		print "MODIFIERS"
		for _mod in modifers do
			format "_mod = % \n" _mod

		format "\n"
		print "SELECTED"
		for index in selected do
			format "index = % \n" index

	),


	private

	/** Get listbox
	 */
	function getListboxHWND =
	(
		--format "\n"; print "CommandPanel_v.getListbox()"
		list_box = for c in windows.getChildrenHWND this.hwnd where  c[4] == "ListBox" do exit with c[1] --return
	),

	/** Get modifier items count
	 */
	function getModifiersItemsCount =
	(
		--format "\n"; print "CommandPanel_v.getModifiersItemsCount()"
		LB_GETCOUNT	= 0x18B

		windows.SendMessage list_box LB_GETCOUNT 0 0 --return
	),

	/** Get slected items
	  *
	  * @return array of selected items indexes
	 */
	function getSlectedItems items_count =
	(
		--format "\n"; print "CommandPanel_v.getSlectedItems()"
		LB_GETSEL	= 0x187

		for i=0 to items_count-1 where (windows.SendMessage  this.list_box  LB_GETSEL i 0) == 1 collect (i+1) --returnobj,
	),

	/** Get all modifier stack items
	 */
	function _getAllModifierStackItems items_count =
	(
		--format "\n"; print "CommandPanel_v.getAllModifierStackItems()"

		items = for i=0 to items_count-1 collect ( this.getListBoxItemText i )

	),

	/**
	  *
	  */
	fn getListBoxItemText i =
	(
		local LB_GETTEXT = 0x189
		local LB_GETTEXTLEN = 0x18A
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
	function _getCommandPanelHWND =
	(
		local g = (dotNetClass "Autodesk.Max.GlobalInterface").Instance
		local r  = g.coreinterface7.CommandPanelRollup
		local dialog_hwnd = -1

		if r.Hwnd == 0 then
		(
			dialog_hwnd = r.GetPanelDlg 0

			for i = 1 to 6 do
			(
				dialog_hwnd = uiaccessor.getparentwindow dialog_hwnd
			)
		)
		else
		(
			dialog_hwnd = r.Hwnd
			for i = 1 to 3 do
			(
				dialog_hwnd = uiaccessor.getparentwindow dialog_hwnd
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
		this._getCommandPanelHWND()

		this.getListboxHWND()

		--format "\n"; print "CommandPanel.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
