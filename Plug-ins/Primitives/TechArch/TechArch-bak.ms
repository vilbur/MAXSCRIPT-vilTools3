plugin shape techArch -- superclasses: https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-B0B9C1BF-168C-47D2-A4BE-12D93116FE79
name:	"Tech Arch"
extends:	SplineShape
category:	"Splines"
classID:	#( 0x3083a88, 0x27add00b ) -- genClassID()
replaceUI:	true
(
	/* options */
	/* properties */

	/* properties */
	local initialized = false

	/* store */
	local obj

	local circles = #()

	/*------------------------------------------------------------------------------

		PARAMETERS

	--------------------------------------------------------------------------------*/

	parameters main rollout:params
	(
		--pos_test 	type:#float	default:50

		radius 	ui:SP_radius	type:#float	default:50
		width	ui:SP_width	type:#float	default:0
		height	ui:SP_height	type:#float default:0
		gap_angle	ui:SP_gap_angle	type:#float	default:0

		on radius	set val do this.setRadius()
		on width	set val do this.setWidth()
		on height	set val do this.setHeight()
		--on gap_angle	set val do this.generate()

	)

	parameters main rollout:params_angle
	(
		wrap_angle	ui:SP_wrap	type:#float	default:360

		angle_min	ui:SP_angle_min	type:#integer default:180
		angle_max	ui:SP_angle_max	type:#integer default:180

		--on wrap_angle	set val do this.generate()
		--on random_angle set val do this.generate()
		--on angle_min    set val do( if val <= 0 then angle_min = 1; this.generate())

	)

	parameters main rollout:params_variation
	(
		radius_mode 	ui:RB_radius_mode	type:#integer	default:1
		angle_mode 	ui:RB_angle_mode	type:#integer	default:1

		--on radius_mode set val do this.createdByScript()

	)

	parameters main rollout:params_extended
	(
		attach_to_line	ui:SP_attach_to_line	type:#boolean	default:true
		weld_line	ui:SP_weld_line	type:#boolean	default:true
		connect_line	ui:SP_connect_line	type:#boolean	default:true
		close_line	ui:SP_close_line	type:#boolean	default:true

		--on weld_line			set val do this.weldAllVerts()
		--on attach_to_line	set val do if val then this.attachAllToObj() else this.generate() -- regenerate unattached if uncheckled
		--on connect_line		set val do this.createConnectLine()
	)

	/*------------------------------------------------------------------------------

		ROLLOUTS

	--------------------------------------------------------------------------------*/

	rollout params "Parameters"
	(
		spinner	SP_radius	"Radius"	range:[ 0, 9999, radius ]
		spinner	SP_width	"Width"	range:[ -9999, 9999, width ]
		spinner	SP_height	"Height"	range:[ 0, 9999, height ]
		spinner	SP_gap_angle	"Gap Angle"	range:[ 0, 10, 0 ]	type:#float tooltip:"Gap angle between segments"
	)

	rollout params_angle "Angles"
	(
		spinner	SP_wrap	"Wrap Angle"	range:[ 1, 9999, wrap_angle ]  scale:10.0 tooltip:"Total radius of line"
		spinner	SP_angle_min	"Angle Min"	range:[ 1, 9999, 90 ] tooltip:"Angle of arch segment"
		spinner	SP_angle_max	"Angle Max"	range:[ 0, 9999, 0 ]


		/* ON ANGLE MIN CHANGED -- dont allow angle_min > angle_max */
		--on SP_angle_min changed val do
		--	if val > angle_max  then
		--		angle_max = val


		/* ON ANGLE MAX CHANGED -- dont allow angle_max > angle_max */
		--on SP_angle_max changed val do
		--	if val > angle_min  then
		--		angle_min = val
	)

	rollout params_variation "Variations"
	(
		radiobuttons RB_radius_mode "Radius Mode"	labels:#("Event\Odd", "Random", "Incremental" ) --offset:[-8, 16]
		radiobuttons RB_angle_mode "Angle Mode"		labels:#("Event\Odd", "Random" /*", Incremental"*/ ) --offset:[-8, 16]

		--/* ON RADIUS MODE CHANGED */
		--on RB_angle_mode changed val do
		--	this.createdByScript()
		--
		--/* ON ANGLE MODE CHANGED */
		--on RB_angle_mode changed val do
		--	this.createdByScript()
	)

	rollout params_extended "Parameters Extends"
	(
		checkbox	SP_attach_to_line 	"Attach line"
		checkbox	SP_connect_line 	"Connect line"
		checkbox	SP_weld_line 	"Weld"
		checkbox	SP_close_line	"Close line"  enabled:SP_weld_line.state

		button btn_generate "Generate"	width:64
		button btn_attach   "Attach"		width:64
		button btn_test      "Test"			width:64


		--on SP_connect_line changed val do
			--SP_close_line.enabled = val


		--on btn_generate pressed do this.createdByScript()
		--on btn_attach pressed do this.attachAllToObj()
		--on btn_test pressed do this.removeAllLines()
	)

	/*------------------------------------------------------------------------------

		METHODS

	--------------------------------------------------------------------------------*/

	/** Generate circles
	  *
	  */
	function generateCircles =
	(
		print "TechArch.generateCircles()"
		format "this.obj:	% \n" this.obj
		format "this.obj.pos:	% \n" this.obj.pos

		circles_data = #()

		angle_counter = 0

		/* GET DATA FOR CIRCLES */
		while angle_counter < wrap_angle do
		(
			circle_data	= Dictionary()

			arc_index = circles_data.count+1

			angle_used = angle_min

			circle_data[#ROTATION]	= angle_counter

			angle_counter += angle_used

			/* Fit last arc to wrap angle value */
			if angle_counter > wrap_angle then
				angle_used = wrap_angle - angle_counter


			circle_data[#FROM]	= 0 + gap_angle
			circle_data[#TO]	= angle_used - gap_angle
			circle_data[#RADIUS]	= radius
			--circle_data[#POSITION]	= position

			append circles_data circle_data
		)

		/* CREATE CIRCLES */
		for circle_data in circles_data do
		(
			--arc_obj = Arc radius:circle_data[#RADIUS] from:circle_data[#FROM] to:circle_data[#TO] pos:circle_data[#POSITION] pie:off reverse:off wirecolor:green name:( this.obj.name + "-arc" )
			--circle = Arc radius:circle_data[#RADIUS] from:circle_data[#FROM] to:circle_data[#TO] pos:position pie:off reverse:off wirecolor:green
			circle = Arc radius:0 from:circle_data[#FROM] to:circle_data[#TO] pos:this.obj.pos pie:off reverse:off wirecolor:green

			Rotate circle ( AngleAxis circle_data[#ROTATION] [0,0,1])

			append this.circles circle
		)

		format "RESULT CIRCLES:	% \n" this.circles.count
	)

	/** Set radius
	  *
	  */
	function setRadius =
	(
		if not initialized then return false
		print "TechArch.setRadius()"

		for circle in this.circles do circle.radius = radius
	)

	/** Set width of circle to create "tube" effect
	  */
	function setWidth =
	(
		if not initialized then return false
		print "TechArch.setWidth()"

		this.circles[circles.count].radius = radius - width
	)

	/** Set height of circles to create "cylinder" effect
	  */
	function setHeight =
	(
		if not initialized then return false
		print "TechArch.setHeight()"

		this.circles[circles.count].pos.z = this.obj.pos.z + height
	)

	/** Finish curve
	  *
	  */
	function finishCurve =
	(
		format "\n"; print "TechArch.finishCurve()"
		 format "this.obj.pos:	% \n" this.obj.pos

		/* CONNECT CIRCLES */
		if connect_line then
			this.createConnectLine()

		/* ATTACH TO SINGLE OBJECT */
		--if attach_to_line then
			--this.attatchLines (this.obj) (this.circles)


		/* WELD */
		--if weld_line then
			--this.weldAllVerts()

	)

	/** Create connect line
	  *
	  */
	function createConnectLine =
	(
		print "TechArch.createConnectLine()"

		child = SplineShape()

		addNewSpline child

		addKnot child 1 #corner #line [ 0, 0, 50]
		addKnot child 1 #corner #line [ 0, 100, 50]
		updateShape child


		addAndWeld this.obj child -1

		updateShape this.obj

	)

	/** Remove connect line
	  *
	  */
	function removeConnectLine =
	(
		--format "\n"; print "TechArch.removeConnectLine()"
		for spline_i = arcs_data.count + 1 to numSplines this.obj do
			deleteSpline this.obj 1

		updateShape this.ob
	)

	/** Attach to obj
	  *
	  */
	function attachAllToObj =
	(
		if not initialized then return false
		--format "\n"; print "TechArch.attachAllToObj()"
		all_arcs = this.getCircleNodes()

		this.attatchLines (this.obj) ( all_arcs )

		this.weldAllVerts()
	)

	/** Attatch lines
	  *`
	  */
	function attatchLines spline splines =
	(
		print "TechArch.attatchLines()"

		if classOf splines != Array then
			splines = #(splines)

		for s in splines where s != spline do addAndWeld spline ( convertToSplineShape s) -1

		updateShape spline
	)

	/** Remove lines
	  *
	  */
	function removeAllLines =
	(
		--format "\n"; print "TechArch.removeAllLines()"
		--format "\n-----------\nARRAY:arcs_data:\n";  for _arc in this.arcs_data do format "_arc:	%\n" _arc

		for obj in this.getCircleNodes() do delete obj

		/* DELETE SPLINE SEGMENTS */
		for spline_i = 1 to numSplines this.obj do
			deleteSpline this.obj 1
			--deleteSpline this.obj 1

		this.circles = #()

		updateShape this.obj
	)

	/** Get arc nodes
	  *
	  */
	function getCircleNodes =
	(
		--format "\n"; print "TechArch.getCircleNodes()"
		for circle in circles where isValidNode circle collect circle --return
	)

	/** Weld all verts
	  *
	  */
	function weldAllVerts =
	(
		--format "\n"; print "TechArch.weldAllVerts()"
		if not initialized then return false

		if weld_line  then
			weldSpline this.obj 0.001
	)


	function isOdd num = ( mod num 2) != 0

	/*------------------------------------------------------------------------------

		PRIVATE

	--------------------------------------------------------------------------------*/

	/** Init
	  *
	  */
	function init obj: =
	(
		if this.initialized then return true
		format "\n"; print "TechArch.init()"

		this.obj = if obj != unsupplied then obj else refs.dependentNodes this firstOnly:on



		 --this.obj.pos = [ 30, 30, 0]
		 format "this.obj.pos:	% \n" this.obj.pos

		this.initialized = true


		/* GENERATE OBJECT IF NOT CREATED MANUALY */
		if not isCreatingObject(techArch) then
			this.createdByScript()
	)

	/*------------------------------------------------------------------------------

		EVENTS

	--------------------------------------------------------------------------------*/

	on load do
	(
		print "TechArch.load()"
	)

	on postLoad  do
	(
		print "TechArch.postLoad()"
		this.init()
	)

	on create do
	(
		print "TechArch.create()"
	)

	on postCreate do
	(
		print "TechArch.postCreate()"
	)

	on attachedToNode _node  do
	(
		print "TechArch.attachedToNode()"

		 format "_node.pos:	% \n" _node.pos

		_node.name = uniqueName "TechHelix"



		this.init obj:_node
	)

	/* CREATE OBJECT BY MOUSE
	 *
	 * Mouse events: https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-619AF4D3-A347-4155-943B-707D421BC460
	*/
	tool create numPoints:4
	(
		on mousePoint click do
		  case click of
		  (
			1: (
				nodeTM.translation = gridPoint

				this.generateCircles()
			)
			4: (
				#stop

				this.finishCurve()
			)
		  )

		on mouseMove click do
		  case click of
		  (
			2: this.radius 	= gridDist.x
			3: this.width	= gridDist.x
			4: this.height	= gridDist.z
		  )
	)


	/** CREATE OBJECT BY SCRIPT
	  *
	  */
	function createdByScript =
	(
		format "\n"; print "TechArch.createdByScript()"
		this.generateCircles()

		this.setRadius()
		this.setWidth()
		this.setHeight()

		this.finishCurve()
	)

)
