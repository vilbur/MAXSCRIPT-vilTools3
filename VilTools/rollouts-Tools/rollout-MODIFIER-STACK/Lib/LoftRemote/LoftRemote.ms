filein( getFilenamePath(getSourceFileName()) + "/../../../../../Lib/UIAccessorWrapper/UIAccessorWrapper.ms" )	-- "./../../../../../Lib/UIAccessorWrapper/UIAccessorWrapper.ms"


global CREATING_LOFT

global addShapePickDialog

global PICK_SHAPE

/** Wait then loft object UI will be estabilished
  *	Then continue with creation
  */
function resumeCreationCallback sender evt =
(
	-- important: don't repeat this timer event
	sender.enabled = false
	-- for sanity and cleanup
	dotNet.removeEventHandler sender "Elapsed" resumeCreationCallback

	CREATING_LOFT.addShapesToLoft()
)

/** Pick shape from dialog
  *
  */
fn addShapePickDialog =
(
	format "\n"; print "LoftRemote_v.addShapePickDialog()"
	format "PICK_SHAPE:	% \n" PICK_SHAPE
	hwnd	= DialogMonitorOPS.getWindowHandle()
	dialogTitle	= UIAccessor.getWindowText hwnd

	if (dialogTitle == "Pick Object") then
	(
		dialog_controls = windows.getChildrenHWND hwnd

		enter_text_ctrl = dialog_controls[15][1]

		UIAccessor.SetWindowText enter_text_ctrl PICK_SHAPE

		PICK_SHAPE = undefined

		UIAccessor.PressDefaultButton()
	)
	true
)


/** Loft shapes
 */
struct LoftShapeData_v( obj, pos)

/** Loft remote
 */
struct LoftRemote_v
(
	/* construct */

	path_steps,
	shape_steps,

	methods = #( #PERCENTAGE, #DISTANCE, #STEPS ),

	method, -- #PERCENTAGE default

	/* properties */
	_path,
	_Shapes = #(),

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

		CREATING_LOFT = this

		this.setOptions()

		select _path

		macros.run "Objects Compounds" "Loft"

		this._setTimer(500)
	),

	/** Create
	  *
	  */
	function create =
	(
		format "\n"; print "LoftRemote_v.create()"

		CREATING_LOFT = this

		select this._path

		macros.run "Objects Compounds" "Loft"

		this._setTimer(500)
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

		append this._Shapes ( LoftShapeData_v (_shape)(pos) )
	),

	/** Set shapes
	  *
	  */
	function addShapesToLoft =
	(
		format "\n"; print "LoftRemote_v.addShapesToLoft()"
		UIAccess = UIAccessorWrapper_v( #CommandPanel )

		if this.method == undefined then this.setMethod(1)

		this._setMethodOption()

		for _Shape in this._Shapes do
			this.addShapeToLoft (_Shape)

		--UIAccess.list()

		CREATING_LOFT = undefined
	),

	/** Set shape
	  *
	  */
	function addShapeToLoft ShapeData =
	(
		format "\n"; print "LoftRemote_v.addShapeToLoft()"

		format "ShapeData:	% \n" ShapeData

		function pickDialogCallbackStart =
		(
			DialogMonitorOPS.RegisterNotification addShapePickDialog id:#GetShapePopUp
			DialogMonitorOPS.enabled = true
		)
		function pickDialogCallbackStop =
		(
			DialogMonitorOPS.unRegisterNotification id:#GetShapePopUp --not needed more
			DialogMonitorOPS.enabled = false
		)


		this._setShapePosition (ShapeData.pos)

		pickDialogCallbackStart()

		PICK_SHAPE = ShapeData.obj.name

		UIAccess.press ("Get Shape")

		max tool hlist -- open pick dialog

		pickDialogCallbackStop()

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
	function _setShapePosition pos =
	(
		format "\n"; print "LoftRemote_v._setShapePosition()"
		format "pos:	% \n" pos
		if pos == 0 then
			return true

		UIAccess.setVal "Path:" pos
	),

	/** Set timer
	  *
	  */
	function _setTimer delay_ms =
	(
		--format "\n"; print "LoftRemote_v._setTimer()"
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
