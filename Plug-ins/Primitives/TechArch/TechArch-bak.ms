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
	local arcs_data = #()
	local sketch

	local circles = #()

	/*------------------------------------------------------------------------------

		PARAMETERS

	--------------------------------------------------------------------------------*/

	parameters main rollout:params
	(
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

		--on radius_mode set val do this.generateWholeObject()

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
		--	this.generateWholeObject()
		--
		--/* ON ANGLE MODE CHANGED */
		--on RB_angle_mode changed val do
		--	this.generateWholeObject()
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


		on SP_connect_line changed val do
			SP_close_line.enabled = val


		on btn_generate pressed do this.generateWholeObject()
		on btn_attach pressed do this.attachAllToObj()
		on btn_test pressed do this.removeAllLines()
	)

	/*------------------------------------------------------------------------------

		METHODS

	--------------------------------------------------------------------------------*/

	/** Generate whole object
	  *
	  */
	function generateWholeObject =
	(
		format "\n"; print "TechArch.ms.generateWholeObject()"
		this.generateCircles(this.obj.pos)

		this.setRadius()
		this.setWidth()
		this.setHeight()

		this.finishCurve()
	)

	/** Generate circles
	  *
	  */
	function generateCircles position =
	(
		if circles.count > 0 or position == undefined then
			return true

		format "\n"; print "TechArch.ms.generateCircles()"

		circles_data = #()

		angle_counter = 0

		/* GET DATA FOR CIRCLES */
		while angle_counter < wrap_angle do
		(
			circle_data	= Dictionary()

			arc_index = arcs_data.count+1

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
			circle = Arc radius:0 from:circle_data[#FROM] to:circle_data[#TO] pos:position pie:off reverse:off wirecolor:green

			Rotate circle ( AngleAxis circle_data[#ROTATION] [0,0,1])

			append circles circle
		)
		--format "CIRCLES.COUNT:	% \n" CIRCLES.COUNT
		redrawViews()
	)

	/** Set radius
	  *
	  */
	function setRadius =
	(
		--format "\n"; print "TechArch.ms.setRadius()"

		for circle in this.circles do circle.radius = radius
	)

	/** Set width of circle to create "tube" effect
	  */
	function setWidth =
	(
		if not initialized then return false
		--format "\n"; print "TechArch.ms.setWidth()"

		this.circles[circles.count].radius = radius - width
	)

	/** Set height of circles to create "cylinder" effect
	  */
	function setHeight =
	(
		--format "this.obj:	% \n" this.obj
		if not initialized then return false
		--format "\n"; print "TechArch.ms.setHeight()"

		this.circles[circles.count].pos.z = this.obj.pos.z + height
	)

	/** Finish curve
	  *
	  */
	function finishCurve =
	(
		format "\n"; print "TechArch.ms.finishCurve()"

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
		/** Get First And Last Vertext From Each Spline
		  *
		  */
		function getConnectVertsPositions is_attached =
		(
			format "\n"; print "TechArch.ms.getConnectVertsPositions()"
			format "IS_ATTACHED:	% \n" is_attached

			last_knot_i = 1
			verts_pos_all = #()

			obj_temp = this.obj
			format "obj_temp:	% \n" obj_temp
			/* CREATE TEMP OBJECT OF ATTACHED SPLINE */
			if is_attached == false then
			(
				maxOps.cloneNodes (this.getCircleNodes()) cloneType:#copy newNodes:&arcs_copy

				obj_temp = convertToSplineShape arcs_copy[1]

				for s in arcs_copy where s != obj_temp do addAndWeld obj_temp ( convertToSplineShape s) -1
			)
			format "obj_temp:	% \n" obj_temp


			/* GET VERTICES */
			for spline = 1 to numSplines obj_temp - 1 do
			(
				spline_next = spline + 1
				num_knots	= numKnots obj_temp spline

				spline_current_last_vert	= getKnotPoint obj_temp (spline) ( numKnots obj_temp spline  )
				spline_next_first_vert	= getKnotPoint obj_temp (spline_next) 1

				append verts_pos_all #( spline_current_last_vert, spline_next_first_vert )
				--append verts_pos_all #( last_knot_i, last_knot_i + num_knots - 1 )

				last_knot_i += num_knots
			)


			/* CREATE CLOSE SPLINE SEGMENT */
			if connect_line and close_line and weld_line then
			(
				line_start_pos	= getKnotPoint	obj_temp 1 1
				last_spline	= numSplines	obj_temp
				line_end_pos	= getKnotPoint	obj_temp last_spline ( numKnots obj_temp last_spline )

				if line_start_pos != line_end_pos then
					append verts_pos_all #( line_start_pos, line_end_pos )
			)

			format "\n-----------\nARRAY:verts_pos_all:\n";  for verts in verts_pos_all do format "verts:	%\n" verts

			/* DELETE TEMP OBJECTS */
			if obj_temp != this.obj then
				delete obj_temp

			verts_pos_all --return
		)

		if not initialized then return false
		--format "\n"; print "TechArch.ms.createConnectLine()"

		verts_pos = getConnectVertsPositions( (this.getCircleNodes()).count == 0 )


		/* CREATE CONNECT LINE */
		--connect_line_shape = SplineShape()

		--for i = 1 to verts_pos.count do
		--(
		--	addNewSpline this.obj
		--
		--	addKnot this.obj i #corner #line verts_pos[i][1]
		--	addKnot this.obj i #corner #line verts_pos[i][2]
		--
		--	updateShape this.obj
		--)

		--this.attatchLines (this.obj) (connect_line_shape)


		--format "numSplines	this.obj:	% \n" (numSplines	this.obj)

		--/* CLOSE LINE IF ALLOWED */
		--if close_line then
		--	this.closeSpline()
	)



	/** Remove connect line
	  *
	  */
	function removeConnectLine =
	(
		--format "\n"; print "TechArch.ms.removeConnectLine()"
		for spline_i = arcs_data.count + 1 to numSplines this.obj do
			deleteSpline this.obj 1

		updateShape this.ob
	)

	/** Generate arch
	  *
	  */
	function generateArches =
	(
		format "\n"; print "TechArch.ms.generateArches()"
		/** Set arches
		  *
		  */
		function setArchesByAngle =
		(
			--format "\n"; print "TechArch.ms.setArches()"
			angle_counter = 0

			while angle_counter < wrap_angle do
			(
				arc_data	= Dictionary()

				arc_index = arcs_data.count+1

				angle_used = case angle_mode of
				(
					--2:
					3: if this.isOdd(arc_index) then angle_min else angle_max -- Even arch is min, odd is max
					default: random angle_min angle_max
				)

				arc_data[#FROM]	= 0 + gap_angle
				arc_data[#TO]	= angle_used - gap_angle
				arc_data[#ROTATION]	= angle_counter
				arc_data[#RADIUS]	= radius

				angle_counter += angle_used

				append arcs_data arc_data
			)
		)

		/** Get radiuse value of arch splines
		  */
		function setRadiusVariations =
		(
			--format "\n"; print "TechArch.ms.getAngles()"
			--format "radius_mode:	% \n" radius_mode
			if width == 0 then return false --return

			for i = 1 to arcs_data.count do
			(
				arcs_data[i][#RADIUS] = case radius_mode of
				(
					1: random (radius)(radius + width)
					2: arcs_data[i][#RADIUS] +  (width / ( arcs_data.count -  1 ) * (i - 1) ) --increemanetal radius from lowest to highest
					3: if this.isOdd(i) then radius else radius + width -- Even arch is min, odd is max
				)
			)

			--arcs_data[i][#RADIUS] = radius
			--arcs_data[1][#RADIUS]	= radius	-- set min radius to FIRST RADIUS
		)

		/** Get height positions
		  *
		  */
		function setArcPositions =
		(
			--format "\n"; print "TechArch.ms.getHeightPositions()"
			height_increment = height / ( arcs_data.count -  1 ) as float

			for i = 1 to arcs_data.count do arcs_data[i][#POSITION] = this.obj.pos


			for i = 1 to arcs_data.count do
				arcs_data[i][#POSITION].z = this.obj.pos.z + ( height_increment * (i - 1) )
		)

		/** Create arch obejcts
		  *
		  */
		function createArcsObjects =
		(
			format "\n"; print "TechArch.ms.createArcsObjects()"

			for arc_data in arcs_data do
			(
				arc_obj = Arc radius:arc_data[#RADIUS] from:arc_data[#FROM] to:arc_data[#TO] pos:arc_data[#POSITION] pie:off reverse:off wirecolor:green name:( this.obj.name + "-arc" )

				Rotate arc_obj ( AngleAxis arc_data[#ROTATION] [0,0,1])

				arc_data[#NODE] = arc_obj

				--arc_obj.parent = this.obj
			)
		)

		setArchesByAngle()

		setArcPositions()
		setRadiusVariations()

		createArcsObjects()

		/* ATTACH TO OBJECT */
		if attach_to_line then
			this.attatchLines (this.obj) ( for arc_data in arcs_data collect arc_data[#NODE] )
	)

	/** Attach to obj
	  *
	  */
	function attachAllToObj =
	(
		if not initialized then return false
		--format "\n"; print "TechArch.ms.attachAllToObj()"
		all_arcs = this.getCircleNodes()

		this.attatchLines (this.obj) ( all_arcs )

		this.weldAllVerts()
	)

	/** Attatch lines
	  *`
	  */
	function attatchLines spline splines =
	(
		format "\n"; print "TechArch.ms.attatchLines()"
		--format "spline:	% \n" spline
		--format "superclassOf spline:	% \n" (superclassOf spline)
		--format "superclassOf splines:	% \n" (superclassOf splines)

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
		--format "\n"; print "TechArch.ms.removeAllLines()"
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
		--format "\n"; print "TechArch.ms.getCircleNodes()"
		for circle in circles where isValidNode circle collect circle --return
	)

	/** Weld all verts
	  *
	  */
	function weldAllVerts =
	(
		--format "\n"; print "TechArch.ms.weldAllVerts()"
		if not initialized then return false

		if weld_line  then
			weldSpline this.obj 0.001
	)

	/** Get this.obj obejct
	 */
	function _setNodeObject =
	(
		--nodes = for o in refs.dependents this where isValidNode o collect o

		--this.obj = nodes[1] --return
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
		format "\n"; print "TechArch.ms.init()"

		this.obj = if obj != unsupplied then obj else (for o in refs.dependents this where isValidNode o collect o)[1]

		this.initialized = true

		/* GENERATE OBJECT IF NOT CREATED MANUALY */
		if circles.count == 0 then
			this.generateWholeObject()
	)

	/*------------------------------------------------------------------------------

		EVENTS

	--------------------------------------------------------------------------------*/

	on load do
	(
		format "\n"; print ".load()"
	)

	on postLoad  do
	(
		format "\n"; print ".postLoad()"
		--this.init()
	)

	on attachedToNode obj  do
	(
		format "\n"; print ".attachedToNode()"

		obj.name = uniqueName "TechHelix"

		this.init obj:obj
	)

	/* Mouse events: https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-619AF4D3-A347-4155-943B-707D421BC460
	*/
	tool create numPoints:4
	(
		local view_point

		on mousePoint click do
		  case click of
		  (
			1: (
				nodeTM.translation = gridPoint

				this.generateCircles(gridPoint)
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
			--4: format "\nmouseMove 4"
		  )

		 --on mouseAbort click do <expr>
	)

	on create do
	(
		format "\n"; print ".create()"
	)

	on postCreate do
	(
		format "\n"; print ".postCreate()"
	)

)
