--plugin simpleSpline techArch -- superclasses: https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-B0B9C1BF-168C-47D2-A4BE-12D93116FE79
plugin shape techArch -- superclasses: https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-B0B9C1BF-168C-47D2-A4BE-12D93116FE79
name:	"Tech Arch"
category:	"Splines"
extends:	SplineShape

classID:	#( 0x3083a88, 0x27add00b ) -- genClassID() -- genrate id
version:	0.1
replaceUI:	true
(
	/* options */
	/* properties */

	/* properties */
	local initialized = false

	/* store */
	local obj
	local arcs_data = #()

	/*------------------------------------------------------------------------------

		PARAMETERS

	--------------------------------------------------------------------------------*/

	parameters main rollout:params
	(
		radius 	ui:SP_radius	type:#float	default:50
		width	ui:SP_width	type:#float	default:20
		height	ui:SP_height	type:#integer default:20
		gap_angle	ui:SP_gap_angle	type:#float	default:0

		on radius	set val do this.generate()
		on height	set val do this.generate()
		on gap_angle	set val do this.generate()
		on width		set val do this.generate()

	)

	parameters main rollout:params_angle
	(
		wrap_angle	ui:SP_wrap	type:#float	default:360

		angle_min	ui:SP_angle_min	type:#integer default:90
		angle_max	ui:SP_angle_max	type:#integer default:90

		on wrap_angle	set val do this.generate()
		on random_angle set val do this.generate()
		on angle_min    set val do( if val <= 0 then angle_min = 1; this.generate())

	)

	parameters main rollout:params_variation
	(
		radius_mode 	ui:RB_radius_mode	type:#integer	default:1
		angle_mode 	ui:RB_angle_mode	type:#integer	default:1

		on radius_mode set val do this.generate()

	)

	parameters main rollout:params_extended
	(
		attach_to_line	ui:SP_attach_to_line	type:#boolean	default:true
		weld_line	ui:SP_weld_line	type:#boolean	default:true
		connect_line	ui:SP_connect_line	type:#boolean	default:true
		close_line	ui:SP_close_line	type:#boolean	default:false

		on weld_line			set val do this.weldAllVerts()
		--on attach_to_line	set val do if val then this.attachAllToObj() else this.generate() -- regenerate unattached if uncheckled
		on connect_line		set val do this.createConnectLine()
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
		spinner	SP_wrap	"Wrap Angle"	range:[ 1, 9999, wrap_angle ]	 tooltip:"Total radius of line"
		spinner	SP_angle_min	"Angle Min"	range:[ 1, 9999, 90 ] tooltip:"Angle of arch segment"
		spinner	SP_angle_max	"Angle Max"	range:[ 0, 9999, 0 ]


		/* ON ANGLE MIN CHANGED -- dont allow angle_min > angle_max */
		on SP_angle_min changed val do
			if val > angle_max  then
				angle_max = val


		/* ON ANGLE MAX CHANGED -- dont allow angle_max > angle_max */
		on SP_angle_max changed val do
			if val > angle_min  then
				angle_min = val


	)

	rollout params_variation "Variations"
	(
		radiobuttons RB_radius_mode "Radius Mode"	labels:#("Random", "Incremental", "Event\Odd") --offset:[-8, 16]
		radiobuttons RB_angle_mode "Angle Mode"	labels:#("Random", /*"Incremental",*/ "Event\Odd") --offset:[-8, 16]

		/* ON RADIUS MODE CHANGED */
		on RB_angle_mode changed val do
			this.generate()

		/* ON ANGLE MODE CHANGED */
		on RB_angle_mode changed val do
			this.generate()
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


		on btn_generate pressed do this.generate()
		on btn_attach pressed do this.attachAllToObj()
		on btn_test pressed do this.removeAllLines()
	)

	/*------------------------------------------------------------------------------

		METHODS

	--------------------------------------------------------------------------------*/

	/** Generate
	  *
	  */
	function generate =
	(
		if not initialized then return false

		--format "\n"; print "TechArch.ms.generate()"
		--format "ROUNDS:	% \n" arcs_data.count

		--initialized = false

		with redraw off
		(
			this._setNodeObject()

			this.removeAllLines()

			this.generateArches()

			if connect_line then
				this.createConnectLine()

			this.weldAllVerts()
		)

		initialized = true
	)

	/** Create connect line
	  *
	  */
	function createConnectLine =
	(

		--format "\n"; print "TechArch.ms.createConnectLine()"

		/** Get First And Last Vertext From Each Spline
		  *
		  */
		function getConnectVertsPositions is_attached =
		(
			--format "\n"; print "TechArch.ms.getConnectVertsPositions()"

			last_knot_i = 1
			verts_pos_all = #()

			spline_to_get = this.obj

			if is_attached == false then
			(
				maxOps.cloneNodes (this.getArcNodes()) cloneType:#copy newNodes:&arcs_copy

				spline_to_get = convertToSplineShape arcs_copy[1]

				for s in arcs_copy where s != spline_to_get do addAndWeld spline_to_get ( convertToSplineShape s) -1
			)


			/* GET VERTICES */
			for spline_current = 1 to numSplines spline_to_get - 1 do
			(
				spline_next = spline_current + 1
				num_knots	= numKnots spline_to_get spline_current

				spline_current_last_vert	= getKnotPoint spline_to_get (spline_current) ( numKnots spline_to_get spline_current  )
				spline_next_first_vert	= getKnotPoint spline_to_get (spline_next) 1

				append verts_pos_all #( spline_current_last_vert, spline_next_first_vert )
				--append verts_pos_all #( last_knot_i, last_knot_i + num_knots - 1 )

				last_knot_i += num_knots
			)

			--format "TEST:	% \n" (connect_line and close_line and weld_line)
			/* CLOSE SPLINE SEGMENT */
			if connect_line and close_line and weld_line then
			(
				line_start_pos	= getKnotPoint	spline_to_get 1 1
				last_spline	= numSplines	spline_to_get
				line_end_pos	= getKnotPoint	spline_to_get last_spline ( numKnots spline_to_get last_spline )

				if line_start_pos != line_end_pos then
					append verts_pos_all #( line_start_pos, line_end_pos )
			)

			/* DELETE TEMP OBJECTS */
			if spline_to_get != this.obj then
				delete spline_to_get

			verts_pos_all --return
		)

		if not initialized then return false

		this._setNodeObject()

		verts_pos = getConnectVertsPositions( (this.getArcNodes()).count == 0 )


		/* CREATE CONNECT LINE */
		connect_line_shape = SplineShape()

		for i = 1 to verts_pos.count do
		(
			addNewSpline connect_line_shape

			addKnot connect_line_shape i #corner #line verts_pos[i][1]
			addKnot connect_line_shape i #corner #line verts_pos[i][2]
		)

		/* ATTACH TO OBJECT */
		this.attatchLines this.obj  #(connect_line_shape)


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

		updateShape this.obj
	)


	/** Generate arch
	  *
	  */
	function generateArches =
	(
		--format "\n"; print "TechArch.ms.generateArches()"


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

				final_angle = case angle_mode of
				(
					--2:
					3: if this.isOdd(arc_index) then angle_min else angle_max -- Even arch is min, odd is max
					default: random angle_min angle_max
				)

				arc_data[#FROM]	= 0 + gap_angle
				arc_data[#TO]	= final_angle - gap_angle
				arc_data[#ROTATION]	= angle_counter
				arc_data[#RADIUS]	= radius

				angle_counter += final_angle

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
		function setHeightPositions =
		(
			--format "\n"; print "TechArch.ms.getHeightPositions()"
			height_increment = height / ( arcs_data.count -  1 ) as float

			for i = 1 to arcs_data.count do
				arcs_data[i][#POSITION] =  [ this.obj.pos.x, this.obj.pos.x, this.obj.pos.z + ( height_increment * (i - 1) ) ]
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

		setHeightPositions()
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
		all_arcs = this.getArcNodes()

		this.attatchLines (this.obj) ( all_arcs )

		this.weldAllVerts()
	)

	/** Attatch lines
	  *`
	  */
	function attatchLines spline splines =
	(
		for s in splines where s != spline do addAndWeld spline ( convertToSplineShape s) -1
	)

	/** Remove lines
	  *
	  */
	function removeAllLines =
	(
		--format "\n"; print "TechArch.ms.removeAllLines()"
		--format "\n-----------\nARRAY:arcs_data:\n";  for _arc in this.arcs_data do format "_arc:	%\n" _arc

		for obj in this.getArcNodes() do delete obj

		/* DELETE SPLINE SEGMENTS */
		for spline_i = 1 to numSplines this.obj do
			deleteSpline this.obj 1
			--deleteSpline this.obj 1

		this.arcs_data = #()

		updateShape this.obj
	)

	/** Get arc nodes
	  *
	  */
	function getArcNodes =
	(
		--format "\n"; print "TechArch.ms.getArcNodes()"
		for arc_data in arcs_data where isValidNode arc_data[#NODE] collect arc_data[#NODE] --return
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

	/** Get node obejct
	 */
	function _setNodeObject =
	(
		nodes = for o in refs.dependents this where isValidNode o collect o

		this.obj = nodes[1] --return
	)

	fn isOdd num = ( mod num 2) != 0

	/*------------------------------------------------------------------------------

		EVENTS

	--------------------------------------------------------------------------------*/
	--on create do generate()
	--on postCreate do

	on attachedToNode _node  do
	(
		--format "\n"; print ".attachedToNode()"
		--format "_node:	% \n" _node
		this.obj = _node

		this.initialized = true

		this.generate()
		--this._node.name = _node
	)
	--on postCreate do initialized = true

	--on buildShape do rebuildShape()

	tool create numPoints:3
	(
		on mousePoint click do if click == 1 do
		(
			format "\n"; print "tech-archs.ms.onCreate()"

		)
			--nodeTM.translation = gridPoint
		--
		--on mouseMove click do case click of
		--(
		--	2: radius = (gridDist.x^2 + gridDist.y^2)^.5
		--	3: height = (gridDist.x^2 + gridDist.y^2)^.5
		--)
	)
)