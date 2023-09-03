filein( getFilenamePath(getSourceFileName()) + "/../../../../../Lib/UIAccessorWrapper/UIAccessorWrapper.ms" )	-- "./../../../../../Lib/UIAccessorWrapper/UIAccessorWrapper.ms"


global LOFTCREATOR

global addShapePickDialogCallback

global NEXT_SHAPE_DATA

global LOFT_OBJECT

/** Wait then loft object UI will be estabilished
  *	Then continue with creation
  */
function resumeCreationCallback sender evt =
(
	--format "\n"; print "LoftRemote_v.resumeCreationCallback()"
	-- important: don't repeat this timer event
	sender.enabled = false
	-- for sanity and cleanup
	dotNet.removeEventHandler sender "Elapsed" resumeCreationCallback

	LOFTCREATOR.addShapeToLoft()
)

/** Pick shape from dialog
  *
  */
fn addShapePickDialogCallback =
(
	--format "NEXT_SHAPE_DATA:	% \n" NEXT_SHAPE_DATA
	hwnd	= DialogMonitorOPS.getWindowHandle()
	dialogTitle	= UIAccessor.getWindowText hwnd
	--format "dialogTitle:	% \n" dialogTitle
	--if (dialogTitle == "Select From Scene") then
	if (dialogTitle == "Select From Scene" or dialogTitle == "Pick Object" ) then
	(
		format "\n"; print "LoftRemote_v.addShapePickDialogCallback()"
		format "ADD SHAPE:	% \n" NEXT_SHAPE_DATA.obj.name
		EM_SETSEL  = 0x00B1

		dialog_controls = windows.getChildrenHWND hwnd

		enter_text_ctrl = dialog_controls[15][1]

		UIAccessor.SetWindowText enter_text_ctrl NEXT_SHAPE_DATA.obj.name


		windows.sendMessage enter_text_ctrl EM_SETSEL 0 NEXT_SHAPE_DATA.obj.name.count -- press ENTER key

		DOSCommand ("start \"\" \""+ ( getFilenamePath(getSourceFileName()) + "\\updatePickDialog.ahk" ) +"\" /min")

		UIAccessor.PressButtonByName hwnd "Pick"
		--UIAccessor.PressDefaultButton()

		--LOFTCREATOR.addShapeToLoft()
		LOFTCREATOR._addNextShapeAfterTimeout(1000)

	)
	true
)



/** Loft shapes
 */
struct LoftShapeData_v
(
	obj,
	pos,
	pointer,

	on create do
	(
		pointer = getHandleByAnim obj
	)
)

/** Loft remote
 */
struct LoftRemote_v
(
	/* construct */

	path_steps,
	shape_steps,

	methods = #( #PERCENTAGE, #DISTANCE, #STEPS ),

	method, -- #PERCENTAGE default

	loft_object,
	current_index = 0,

	/* properties */
	_path,
	ShapeData = #(),

	props = #( #path_steps, #shape_steps ),

	/* dependency */
	UIAccess,

	/* reference */
	/* inhered */

	/** Create loft
	  *
	  */
	function createLoft _path _shapes =
	(
		format "\n"; print "LoftRemote_v.createLoft()"
		format "_path:	% \n" _path
		format "_shapes:	% \n" _shapes
		this._path   = _path
		this._shapes = _shapes

		LOFTCREASTOR = this

		this.setOptions()

		select _path

		macros.run "Objects Compounds" "Loft"

		this._addNextShapeAfterTimeout(500)
	),

	/** Create
	  *
	  */
	function create =
	(
		format "\n"; print "LoftRemote_v.create()"

		LOFTCREATOR = this

		NEXT_SHAPE_DATA = undefined

		select this._path

		macros.run "Objects Compounds" "Loft"

		this._addNextShapeAfterTimeout(100)
	),

	/** Set path
	  *
	  */
	function setPath _path =
	(
		--format "\n"; print "LoftRemote_v.setPath()"
		this._path = _path
	),

	/** Set shape
	  *
	  */
	function setShape _shape pos: =
	(
		--format "\n"; print "LoftRemote_v.setShape()"

		append this.ShapeData ( LoftShapeData_v (_shape)(pos) )
	),

	/** Set shapes
	  *
	  */
	function loftCreationStart =
	(
		format "\n"; print "LoftRemote_v.loftCreationStart()"
		UIAccess = UIAccessorWrapper_v( #CommandPanel )

		if this.method == undefined then this.setMethod(1)

		this._setMethodOption()

		for _Shape in this.ShapeData do
			this.addShapeToLoft (_Shape)

		--UIAccess.list()

		LOFTCREASTOR = undefined
	),


	/** Add shape to loft
	  *
	  * Adding next shape is fored in addShapePickDialogCallback()
	  */
	function addShapeToLoft =
	(
		format "\n-------------------------------------\n\n"; print "LoftRemote_v.addShapeToLoft()"

		NEXT_SHAPE_DATA = ShapeData[this.current_index + 1]
		format "this.current_index:	% \n" this.current_index
		format "NEXT_SHAPE_DATA:	% \n" NEXT_SHAPE_DATA


		/* TURN OFF CREATION AFTER FIRST SHAPE */
		if this.current_index > 0 then
			UIAccess.press ("Get Shape")


		this.current_index += 1

		if NEXT_SHAPE_DATA != undefined then
			this._pickShape()




		--/* TURN OFF CREATION AFTER FIRST SHAPE */
		--if this.current_index > 0 then
		--(
		--	print "=========== ADD NEXT SHAPE ==========="
		--
		--	this.current_index += 1
		--
		--	UIAccess.press ("Get Shape")
		--
		--	if NEXT_SHAPE_DATA != undefined then
		--		this._pickShape()
		--)
		--else
		--
		--if NEXT_SHAPE_DATA != undefined then
		--(
		--	print "=========== ADD FIRST SHAPE ==========="
		--
		--	this.current_index += 1
		--
		--	this._pickShape() -- pick first
		--)



	),

	/** Test
	  *
	  */
	function test =
	(
		format "\n"; print "LoftRemote_v.test()"
		format "this.current_index:	% \n" this.current_index
		format "NEXT_SHAPE_DATA:	% \n" NEXT_SHAPE_DATA

	),

	/** Add shape to loft
	  *
	  * Adding next shape is fored in addShapePickDialogCallback()
	  */
	function _pickShape =
	(
		--format "\n"; print "LoftRemote_v._pickShape()"

		function pickDialogCallbackStart =
		(
			--format "\n"; print "LoftRemote_v.pickDialogCallbackStart()"
			DialogMonitorOPS.RegisterNotification addShapePickDialogCallback id:#GetShapePopUp
			DialogMonitorOPS.enabled = true
		)
		function pickDialogCallbackStop =
		(
			format "\n"; print "LoftRemote_v.pickDialogCallbackStop()"
			DialogMonitorOPS.unRegisterNotification id:#GetShapePopUp --not needed more
			DialogMonitorOPS.enabled = false
		)

		this._setUiAccessor()

		this._setShapePosition()

		UIAccess.press ("Get Shape")

		pickDialogCallbackStart()

		max tool hlist -- open pick dialog

		--pickDialogCallbackStop()
	),
	function pickDialogCallbackStart =
	(
		--format "\n"; print "LoftRemote_v.pickDialogCallbackStart()"
		DialogMonitorOPS.RegisterNotification addShapePickDialogCallback id:#GetShapePopUp
		DialogMonitorOPS.enabled = true
	),
	function pickDialogCallbackStop =
	(
		format "\n"; print "LoftRemote_v.pickDialogCallbackStop()"
		DialogMonitorOPS.unRegisterNotification id:#GetShapePopUp --not needed more
		DialogMonitorOPS.enabled = false
	),


	/** Set method of adding shapes to loft
	  *
	  * @param integer|#PERCENTAGE|#DISTANCE|#STEPS method index of method adding shapes, integer is fool proof
	  */
	function setMethod method =
	(
		format "\n"; print "LoftRemote_v.setMethod()"

		this.method = if classOf method == name then method else this.methods[method]
	),

	/** Set option
	  *
	  */
	function setOptions =
	(
		format "\n"; print "LoftRemote_v.setOption()"

		--for prop in props where (val = getProperty this prop) = undefined do

		--this.suspendWarning()

	),


	private

	/** Set method option in ui
	  *
	  */
	function _setMethodOption =
	(
		format "\n"; print "LoftShapeData_v.setMethodOption()"
		method_control = case this.method of
		(
			#DISTANCE:	"Distance"
			#STEPS:	"Path Steps"
			default:	"Percentage"
		)

		UIAccess.press (method_control)
	),


	/** Set value to spinner of shape position
	  */
	function _setShapePosition =
	(
		format "\n"; print "LoftRemote_v._setShapePosition()"
		format "NEXT_SHAPE_DATA.pos:	% \n" NEXT_SHAPE_DATA.pos

		if NEXT_SHAPE_DATA.pos == 0 then
			return true

		UIAccess.setVal "Path:"( (NEXT_SHAPE_DATA.pos as string ) + ",0")
	),

	/** Set timer
	  *
	  */
	function _addNextShapeAfterTimeout delay_ms =
	(
		format "\n"; print "LoftRemote_v._addNextShapeAfterTimeout()"

		delay_timer = dotNetObject "Windows.Forms.Timer"

		delay_timer.Interval = delay_ms

		dotNet.addEventHandler delay_timer "Tick" resumeCreationCallback

		delay_timer.enabled = true
	),

	/** Set ui accessor
	  *
	  */
	function _setUiAccessor =
	(
		--format "\n"; print "LoftRemote_v.setUiAccessor()"
		this.UIAccess = UIAccessorWrapper_v( #CommandPanel )
	),

	/**
	 */
	on create do
	(
		this._setUiAccessor()
	)
)
