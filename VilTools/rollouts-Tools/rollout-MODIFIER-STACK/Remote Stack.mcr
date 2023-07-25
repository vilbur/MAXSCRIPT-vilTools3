filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/autoEndResult.ms" )	-- "./Lib/Callbacks/autoEndResult.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/disableModifiersOnEdit.ms" )	-- "./Lib/Callbacks/disableModifiersOnEdit.ms"

filein( getFilenamePath(getSourceFileName()) + "/CommandPanel/CommandPanel.ms" ) -- "./CommandPanel/CommandPanel.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Lib/Callbacks/onSelectionMaxModifyMode.ms" )


/**
  * 1) Activate modify panel if not active
  * 2) If modify panel is active, then select next enabled modifier
 */
macroscript	modifier_stack_smart_circle
category:	"_Modifier-Stack"
buttontext:	"Cyrcle Stack"
toolTip:	"Cyrcle Max modify panel > Edit Poly > Show End Result"
--toolTip:	"Turn off \"Show end result\" on subobject edit"
--icon:	"control:checkbox"
(
	--messageBox "Yupiii" title:"Title"  beep:false
	/**
	 */
	function selectNextEnabledModifier =
	(
		format "\n"; print ".selectNextEnabledModifier()"

		while superClassOf (next_mod = modPanel.getCurrentObject()) == modifier and next_mod.enabled == false do
				macros.run "Ribbon - Modeling" "PreviousModifier"

	)

	_selection = selection

	if selection.count > 0 then
	(
		if( GetCommandPanelTaskMode() != #modify ) then
		(
			max modify mode

			selectNextEnabledModifier()
		)

		else if ( current_mod = modPanel.getCurrentObject() ) != undefined then
		(
			if superClassOf current_mod == modifier then
			(
				--macros.run "Ribbon - Modeling" "PreviousModifier"
				index = modPanel.getModifierIndex _selection[1] current_mod

				try(
					modPanel.setCurrentObject _selection[1].modifiers[index +1]

					selectNextEnabledModifier()

				)catch(
					--format "*** % ***\n" (getCurrentException())
					modPanel.setCurrentObject _selection[1].baseObject
				)

			)
			else /* If baseobject is selected then select first enabled modifier */
			(
				modPanel.setCurrentObject _selection[1].modifiers[1]

				selectNextEnabledModifier()
			)

		)
	)
)


/**
 */
macroscript	modifiers_auto_end_result
category:	"_Modifiers"
buttontext:	"End result"
toolTip:	"Show end result if subobject == 0"
--toolTip:	"Turn off \"Show end result\" on subobject edit"
icon:	"control:checkbox"
(
	if( EventFired.val ) then
		callbacks.addScript #ModPanelSubObjectLevelChanged "autoEndResult()" id:#autoEndResult

	else

		try(callbacks.removeScripts #ModPanelSubObjectLevelChanged id:#autoEndResult)catch()
)

/**
 */
macroscript	modifiers_disable_on_edit
category:	"_Modifiers"
buttontext:	"Disable above on edit"
toolTip:	"Disable modifiers above active modifier when subobject is entered"
icon:	"control:checkbox|enabled:false"
(
	--format "modifier_stack.disable_modifiers.state = % \n" modifier_stack.disable_modifiers.state

	--messageBox "mAKE THIS WORKING" title:"Title"  beep:false

	if( EventFired.val ) then
		callbacks.addScript #ModPanelSubObjectLevelChanged "disableModifiersOnEdit()" id:#disableModifiersOnEdit

	else

		try(callbacks.removeScripts #ModPanelSubObjectLevelChanged id:#disableModifiersOnEdit)catch()

)

/**
 */
macroscript	modifiers_get_selected_modifiers
category:	"_Modifiers"
buttontext:	"Get selected"
--toolTip:	"Disable modifiers above active modifier when subobject is entered"
--icon:	"control:checkbox|enabled:false"
(
	clearListener()
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\Remote Stack.mcr"
	filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-vilTools3\VilTools\rollouts-Tools\rollout-MODIFIER-STACK\CommandPanel\CommandPanel.ms"

	CommandPanel 	= CommandPanel_v( selection[1] )

	CommandPanel.getSelectedModifiers()

	--fn getListBoxItemText hWnd i =
	--(
	--	local LB_GETTEXT = 0x189
	--	local LB_GETTEXTLEN = 0x18A
	--	local marshal = dotNetClass "System.Runtime.InteropServices.Marshal"
	--
	--	local len = windows.sendMessage hWnd LB_GETTEXTLEN i 0
	--	local lParam = marshal.AllocHGlobal (2 * len + 2) asDotNetObject:on
	--	windows.sendMessage hWnd LB_GETTEXT i (lParam.ToInt64())
	--
	--	local str = (marshal.PtrToStringAuto lParam asDotNetObject:on).ToString()
	--	marshal.FreeHGlobal lParam
	--	return str
	--)
	--
	--function _getCommandPanelHWND =
	--(
	--	local g = (dotNetClass "Autodesk.Max.GlobalInterface").Instance
	--	local r  = g.coreinterface7.CommandPanelRollup
	--	local dialog_hwnd = -1
	--
	--	if r.Hwnd == 0 then
	--	(
	--		dialog_hwnd = r.GetPanelDlg 0
	--
	--		for i = 1 to 6 do
	--		(
	--			dialog_hwnd = uiaccessor.getparentwindow dialog_hwnd
	--		)
	--	)
	--	else
	--	(
	--		dialog_hwnd = r.Hwnd
	--		for i = 1 to 3 do
	--		(
	--			dialog_hwnd = uiaccessor.getparentwindow dialog_hwnd
	--		)
	--
	--	)
	--
	--
	--	dialog_hwnd
	--)
	--
	--obj = selection[1]
	--
	--LB_GETCOUNT	= 0x18B
	--LB_GETSEL	= 0x187
	--
	--
	--hwnd = _getCommandPanelHWND()
	----hwnd = ( windows.getChildHWND #max "Command Panel")
	----
	----if ( hwnd ) != undefined then
	----	hwnd = hwnd[1]
	----else
	----	hwnd = 9116234P
	----
	----
	----format "classOf hwnd = % \n" (classOf hwnd)
	----format "hwnd = % \n" hwnd
	--
	--
	--list_box = for c in windows.getChildrenHWND hwnd   where  c[4] == "ListBox" do exit with c[1]
	--
	--	--format "list_box = % \n" list_box
	--
	--count = windows.SendMessage list_box LB_GETCOUNT 0 0
	--
	--items = for i=0 to count-1 collect ( getListBoxItemText list_box i )
	--
	--selected = for i=0 to count-1 where (windows.SendMessage  list_box  LB_GETSEL i 0) == 1 collect (i+1)
	--
	--
	--modifers = for _mod in obj.modifiers collect _mod
	--
	--format "\n"
	--print "SELECTED"
	--for index in selected do
	--	format "index = % \n" index
	--
	--format "\n"
	--print "MODIFIERS"
	--for _mod in modifers do
	--	format "_mod = % \n" _mod
	--
	--
	--format "\n"
	--print "items"
	--
	--if items != undefined then
	--	for item in items do
	--		format "item = % \n" item

)
