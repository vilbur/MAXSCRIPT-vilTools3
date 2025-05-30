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
		--format "\n"; print "LoftRemote_v.addShapePickDialogCallback()"
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
		LOFTCREATOR._addNextShapeAfterTimeout(500)

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
	pathShape,

	/* OPTIONS */
	method, -- #PERCENTAGE default
	path_steps, -- default is intepolation of path
	shape_steps,
	last_shape_on_end = true, 	--if true then last shape is forced to be set on end of path

	/* properties */
	ShapesData = #(),

	methods = #( #PERCENTAGE, #DISTANCE, #STEPS ),

	loft_object,
	current_index = 0,

	--params_skin	= Dictionary #( "", #value1 ) #( #key2, #value2 )

	props = #( #path_steps, #shape_steps ),

	/* dependency */
	UIAccess,

	/* reference */
	/* inhered */

	/** Create loft
	  *
	  */
	function createLoft pathShape _shapes =
	(
		format "\n"; print "LoftRemote_v.createLoft()"
		format "pathShape:	% \n" pathShape
		format "_shapes:	% \n" _shapes
		this.pathShape   = pathShape
		this._shapes = _shapes

		LOFTCREASTOR = this

		this.setOptions()

		select pathShape

		macros.run "Objects Compounds" "Loft"

		this._addNextShapeAfterTimeout(500)
	),

	/** Create
	  *
	  */
	function create =
	(
		format "\n"; print "LoftRemote_v.create()"
		format "SHAPES COUNT:	% \n" this.ShapesData.count

		LOFTCREATOR = this

		NEXT_SHAPE_DATA = undefined

		if this.method == undefined then this.setMethod(1)

		--this._setMethodOption()

		select this.pathShape

		macros.run "Objects Compounds" "Loft"

		/* AFTRER LOFT IS ESTABILSHED */
		this._setUiAccessor()

		this._setupLoft()

		this.setPathSteps(this.path_steps)

		if this._setupShapes() then
			this._addNextShapeAfterTimeout(100)
	),

	/** Set path
	  *
	  */
	function setPath pathShape =
	(
		--format "\n"; print "LoftRemote_v.setPath()"
		this.pathShape = pathShape
	),

	/** Set shape
	  *
	  */
	function setShape _shape pos:undefined =
	(
		--format "\n"; print "LoftRemote_v.setShape()"

		append this.ShapesData ( LoftShapeData_v (_shape)(pos) )
	),


	/** Set loft
	  *
	  */
	function setLoft loft_object =
	(
		format "\n"; print "LoftRemote_v.setLoft()"
		--format "classOf loft_object:	% \n" (classOf loft_object)
		if classOf loft_object == Loft then
			this.loft_object = loft_object
		else
			messageBox "Added object is not Loft\n\nMethod:\n\nLoftRemote_v.setLoft()\n\n" title:"SET LOFT ERROR"
	),

	/** Set shapes
	  *
	  */
	function loftCreationStart =
	(
		--format "\n"; print "LoftRemote_v.loftCreationStart()"
		this._setUiAccessor()

		for _Shape in this.ShapesData do
			this.addShapeToLoft (_Shape)

		--UIAccess.list()

		LOFTCREASTOR = undefined
	),

	/** Setup loft
	  *
	  */
	function _setupLoft =
	(
		--format "\n"; print "LoftRemote_v._setupLoft()"
		format "this.method:	% \n" this.method

		case this.method of
		(
			#PERCENTAGE:	UIAccess.press "Percentage"
			#DISTANCE:	UIAccess.press "Distance"
			#STEPS:	UIAccess.press "Path Steps"
		)
		--UIAccess.list type:#Button
		--UIAccess.list type:#Button
		--UIAccess.list type:#static
		--UIAccess.list()
	),

	/** Set path steps
	  *
	  */
	function setPathSteps steps =
	(
		--format "\n"; print "LoftShapeData_v.setPathSteps()"

		if steps == undefined then
			this.path_steps = this.pathShape.steps

		UIAccess.suspendWarning()

		UIAccess.setVal "Path Steps:" ( this.path_steps as string )

		UIAccess.suspendWarningStop()
	),

	/** Set path steps
	  *
	  */
	function setShapeSteps steps =
	(
		--format "\n"; print "LoftShapeData_v.setPathSteps()"

		if steps != undefined then
		(
			UIAccess.suspendWarning()

			UIAccess.setVal "Shape Steps:" ( steps as string )

			UIAccess.suspendWarningStop()
		)
	),

	/** Setup shapes
	  *
	  */
	function _setupShapes =
	(
		format "\n\n"; print "LoftShapeData_v._setupShapes()"

		/** Convert to display units
		  */
		function convertToDisplayUnits val  =
		(
			val = case units.SystemType of -- convert to milimeters
			(
				#centimeters:	val * 10
				#meters:	val * 1000
				#kilometers:	val * 1000000
				default:	val -- mnilimeters or non metric units
			)

			val = case units.MetricType of -- convert to dispaly units
			(
				#centimeters:	val / 10
				#meters:	val / 1000
				#kilometers:	val / 1000000
				default:	val -- mnilimeters or non metric units
			)
			val --return
		)

		/** Set length of path in percentage, knots count or distance
		  */

		path_length = case this.method of
		(
			--#DISTANCE: units.formatValue segments_length[segments_length.count]
			#PERCENTAGE:	100

			#DISTANCE:
			(
				segments_length = getSegLengths this.pathShape 1

				convertToDisplayUnits (segments_length[segments_length.count])
			)

			#STEPS:
			(
				path_knots = numKnots this.pathShape

				segments_count = path_knots - 1
				format "segments_count:	% \n" segments_count
				format "path_knots:	% \n" path_knots

				--spline_steps = (UIAccess.getSpinnerValue "Path Steps:") as integer
				format "path_steps:	%\n" path_steps

				( ( segments_count * path_steps) + path_knots ) as integer
			)
		)

		--shapes_without_pos = for ShapeData in ShapesData where ShapeData.pos == undefined collect ShapeData
		format "PATH_LENGTH:	% \n" path_length
		--format "path_length:	% \n" (units.decodeValue ( units.formatValue path_length ) )



		/* SET POSITION TO SHAPES */
		if ShapesData.count > 1 then
		(
			for index = 1 to ShapesData.count where ShapesData[index].pos == undefined do
				ShapesData[index].pos = path_length / (ShapesData.count - 1) * (index - 1)


			if this.last_shape_on_end then
				ShapesData[ShapesData.count].pos = case this.method of
				(
					#PERCENTAGE:	100.0
					#STEPS:	path_length - 1
					default:	path_length
				)
		)
		else
			ShapesData[1].pos = (if this.method == #PERCENTAGE then 0.0 else 0)

		format "\n\n\n"
		for ShapeData in ShapesData do
		    format "ShapeData: % \n" ShapeData.pos

		if this.method == #STEPS and ShapesData.count > path_length then
		(
			messageBox "Shape is more then stemps on path" title:"LOFT ERROR"

			false --return
		)
		else
			true --return

	),

	/** Add shape to loft
	  *
	  * Adding next shape is fored in addShapePickDialogCallback()
	  */
	function addShapeToLoft =
	(
		--format "\n-------------------------------------\n\n"; print "LoftRemote_v.addShapeToLoft()"

		NEXT_SHAPE_DATA = ShapesData[this.current_index + 1]
		--format "this.current_index:	% \n" this.current_index
		--format "NEXT_SHAPE_DATA:	% \n" NEXT_SHAPE_DATA

		/* TURN OFF CREATION AFTER FIRST SHAPE */
		if this.current_index > 0 then
			UIAccess.press ("Get Shape")

		this.current_index += 1

		if NEXT_SHAPE_DATA != undefined then
			this._pickShape()

		else
			this.pickDialogCallbackStop()
	),

	/** Add shape to loft
	  *
	  * Adding next shape is fored in addShapePickDialogCallback()
	  */
	function _pickShape =
	(
		format "\n-------------------------------------\n\n"; print "LoftRemote_v._pickShape()"

		this._setUiAccessor()

		this._setShapePosition()

		UIAccess.press ("Get Shape")

		this.pickDialogCallbackStart()

		max tool hlist -- open pick dialog
	),

	/**
	  */
	function pickDialogCallbackStart =
	(
		--format "\n"; print "LoftRemote_v.pickDialogCallbackStart()"
		DialogMonitorOPS.RegisterNotification addShapePickDialogCallback id:#GetShapePopUp
		DialogMonitorOPS.enabled = true
	),

	/**
	  */
	function pickDialogCallbackStop =
	(
		--format "\n"; print "LoftRemote_v.pickDialogCallbackStop()"
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



	/** List options
	  *
	  */
	function listOptions =
	(
		--format "\n"; print "LoftShapeData_v.listOptions()"
		this._setUiAccessor()

		--UIAccess.list()
		--UIAccess.list type:#Button
		_checkbox = UIAccess.getControl("Optimize Shapes")

		UIAccess.getCeckboxVal _checkbox[1]

	),

	--private

	--/** Set method option in ui
	--  *
	--  */
	--function _setMethodOption =
	--(
	--	format "\n"; print "LoftShapeData_v.setMethodOption()"
	--	method_control = case this.method of
	--	(
	--		#DISTANCE:	"Distance"
	--		#STEPS:	"Path Steps"
	--		default:	"Percentage"
	--	)
	--
	--	UIAccess.press (method_control)
	--),


	/** Set value to spinner of shape position
	  */
	function _setShapePosition =
	(
		--format "\n"; print "LoftRemote_v._setShapePosition()"
		format "SHAPE POSITION:	% \n" NEXT_SHAPE_DATA.pos

		if NEXT_SHAPE_DATA.pos == 0 then
			return true

		--UIAccess.setVal "Path:"( (NEXT_SHAPE_DATA.pos as string ) + ",0")
		UIAccess.setVal "Path:" ( NEXT_SHAPE_DATA.pos as string )
	),

	/** Set timer
	  *
	  */
	function _addNextShapeAfterTimeout delay_ms =
	(
		--format "\n"; print "LoftRemote_v._addNextShapeAfterTimeout()"

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
		--this._setUiAccessor()
	)
)
