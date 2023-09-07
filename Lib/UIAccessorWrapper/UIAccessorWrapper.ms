

global suspendWarningDialog

/** Press "YES" if dialog with title "Warning" appears
  *
  */
function suspendWarningDialog =
(
	local hwnd = dialogMonitorOps.getWindowHandle()
	local dialogTitle = uiAccessor.getWindowText hwnd

	if (dialogTitle == "Warning") then
		UIAccessor.PressDefaultButton()

	true
) --end fn suspendWarningDialog =


/** U i accessor wrapper
 */
struct UIAccessorWrapper_v
(
	/* construct */
	dialog_name, -- #CommandPanel

	/* properties */
	dialog_hwnd,
	controls,

	control_types	= Dictionary #( #RADIO, #Button ) #( #BUTTON, #CustButton ) #( #CHECKBOX, #Button ) #( #LABEL, #Static ),

	/* dependency */
	/* reference */
	/* inhered */

	/** Press buttin, radio button or checkbox
	  *
	  */
	function press ui_text type: =
	(
		--format "\n"; print "UIAccessorWrapper_v.press()"
		/** Press button
		  */
		function pressButton ctrl_pointer =
		(
			--format "\n"; print "LoftRemote_v.pressButton()"
			UIAccessor.pressButton ctrl_pointer
		)

		/** Click
		  */
		function click ctrl_pointer =
		(
			BM_CLICK = 0x00F5

			windows.sendMessage ctrl_pointer BM_CLICK 0 0
		)

		if (ctrl_hwnd = this.getControl(ui_text) type:type ) != undefined then
		(
			--format "CTRL_HWND:	% \n" ctrl_hwnd

			case ctrl_hwnd[4] as name of
			(
				#CustButton:	pressButton(ctrl_hwnd[1])
				#Button:	click(ctrl_hwnd[1]) -- click radio button
				--default:
			)
		)
	),

	/** Set value to spinner, or edit text
		CTRL:	#(12721864P, 75110928P, 75110928P, "Edit", "5", 0P, 10753942P, 10753942P)
		CTRL:	#(63972520P, 16517688P, 16517688P, "SpinnerControl", "", 0P, 10753942P, 10753942P)
		CTRL:	#(17501894P, 16517688P, 16517688P, "Static", "Path Steps:", 0P, 10753942P, 10753942P)

	  *
	  */
	function setVal ui_text val =
	(
		--format "\n"; print "UIAccessorWrapper_v.setVal()"

		function isLabel ctrl_hwnd = ctrl_hwnd[4] as name == #static

		function isSpinner ctrl_hwnd = ctrl_hwnd[4] as name == #SpinnerControl

		function setEditvalue ctrl_pointer val =
		(
			--format "\n"; print "LoftRemote_v.setEditvalue()"
			WM_CHAR 	= 0x0102
			VK_RETURN 	= 0x000D

			UIAccessor.setWindowText ctrl_pointer ( val as string ) -- set value

			windows.sendMessage ctrl_pointer WM_CHAR VK_RETURN 0 -- press ENTER key
		)


		if (ctrl_hwnd = this.getControl(ui_text) ) != undefined then
		(
			if isLabel ctrl_hwnd then
			(
				control_index = findItem controls ctrl_hwnd

				if isSpinner controls[control_index + 4] then
				(
					ctrl_edit = controls[control_index + 3]

					setEditvalue(ctrl_edit[1])(val)

					--format "ctrl_edit:	% \n" ctrl_edit
				)
			)
		)

		this.suspendWarningStop()
	),




	/** Get controls
	  *
	  */
	function getControls type =
	(
		format "\n"; print "UIAccessorWrapper_v.getControls()"
		--if classOf controls != Array then controls = #( controls )

		controls_by_type = #()

		for ctrl in this.controls do
			if ctrl[4] as name == type as name then
				append controls_by_type ctrl

		controls_by_type --return
	),

	/** Get control from ui
	  *
	  */
	function getControl ui_text type: =
	(
		--format "\n"; print "LoftRemote_v.getButton()"
		--format "ui_text:	% \n" ui_text

		ctrl_hwnd = undefined

		--for ctrl in this.controls where ctrl[4] as name == control_types[type] and ctrl[5] == ui_text do ctrl_hwnd = ctrl
		for ctrl in this.controls do
			if type == unsupplied and ctrl[5] == ui_text then
				ctrl_hwnd = ctrl

		ctrl_hwnd --return
	),


	/** Get spinner value
	  *
	  */
	function getSpinnerValue ui_text =
	(
		--format "\n"; print "UIAccessorWrapper_v.getSpinnerValue()"
		label_index = this.getControlIndex(ui_text)

		--format "label_index:	% \n" label_index

		if label_index != undefined then
			spinner_value = this.controls[label_index + 3][5]

		--format "spinner_edit:	% \n" spinner_edit
		spinner_value --return
	),

	/** Get values
	  *
	  */
	function getVal controls_get =
	(
		--format "\n"; print "UIAccessorWrapper_v.getValues()"

		/** Get Button type value
		  * @return 0|1|2  false|true|tristate
		  */
		function getNuttonVal ctrl_pointer =
		(
			--format "\n"; print "UIAccessorWrapper_v.getNuttonVal()"
			BM_GETCHECK	=0x00F0

			windows.sendMessage ctrl_pointer BM_GETCHECK 0 0
		)


		if classOf controls_get != Array then controls_get = #( controls_get )

		values = Dictionary (#string)

		for ctrl_get in controls_get where (ctrl = this.getControlByPointer ctrl_get[1] ) != undefined do

			--format "ctrl_get[1]:	% \n" ctrl_get[1]
			values[ctrl[5]] = case ctrl[4] as name of
				(
				--	--#Edit:	pressButton(ctrl_hwnd[1])
					#BUTTON:	getNuttonVal(ctrl[1]) -- click radio button
				--	--default:
				)

		values --return
	),

	/** Get control by pointer
	  *
	  */
	function getControlByPointer ctrl_pointer =
	(
		--format "\n"; print "UIAccessorWrapper_v.getControlByPointer()"

		for ctrl in this.controls where ctrl[1] == ctrl_pointer do
			return ctrl
	),



	/** Get control from ui
	  *
	  */
	function getControlIndex ui_text =
	(
		--format "\n"; print "LoftRemote_v.getButton()"
		--format "ui_text:	% \n" ui_text

		index = undefined

		for i = 1 to this.controls.count where this.controls[i][5]  == ui_text do
			index = i

		index --return
	),

	/** Add callback to Suspend warning dialog
	  */
	function suspendWarning =
	(
		--format "\n"; print "UIAccessorWrapper_v.suspendWarning()"
		DialogMonitorOPS.RegisterNotification suspendWarningDialog id:#suspendWarningDialog
		DialogMonitorOPS.enabled = true
	),

	/** Suspend warning dialog
	  */
	function suspendWarningStop =
	(
		DialogMonitorOPS.unRegisterNotification id:#suspendWarningDialog --not needed more
		DialogMonitorOPS.enabled = false
	),

	/** List controls of UI
	  *
	  * @param #name type
	  *
	  */
	function list type: =
	(
		--clearListener(); print("Cleared in:"+getSourceFileName())
		format "\n"; print "UIAccessorWrapper_v.list()"

		--for ctrl in windows.getChildrenHWnd this.commandPanelHWnd where ctrl[4] == control_types[#RADIO] as string do

		for ctrl in this.controls do
			if type == unsupplied or (type != unsupplied and ctrl[4] as name == type as name ) then
				format "CTRL:	% \n" ctrl
	),

	private

	/** Set win hwnd
	  *
	  */
	function _setWinHwnd =
	(
		--format "\n"; print "UIAccessorWrapper_v._setWinHwnd()"
		case dialog_name of
		(
			#CommandPanel:
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

				this.dialog_hwnd = dialog_hwnd
			)
		)

	),

	/**
	 */
	on create do
	(
		this._setWinHwnd()

		this.controls = windows.getChildrenHWnd this.dialog_hwnd
	)
)
