plugin SimpleSpline TechArch
name:	"Tech Arch"
classID:	#( 0x3083a88, 0x27add00b ) -- genClassID()
category:	"Splines"
(
	local obj

	local arches_data   = #()
	local spline_points = #() -- array of Dictionary #( #point, Point3) #( #inVec, Point3) #( #outVec, Point3)

	local initialized	= false

	local build = false

	local modes = #("Event\Odd", "Incremental", "Random" )
	/*------------------------------------------------------------------------------
		BUILD SHAPE METHODS
	--------------------------------------------------------------------------------*/

	include "buildShape.ms"

	/*------------------------------------------------------------------------------
		PARAMETERS ANGLE
	--------------------------------------------------------------------------------*/
	parameters main rollout:params_angle
	(
		wrap_angle	ui:SP_wrap_angle	type:#float	default:360

		angle_min	ui:SP_angle_min	type:#integer default:90
		angle_max	ui:SP_angle_max	type:#integer default:180

		angle_mode 	ui:RB_angle_mode	type:#radiobtnIndex	default:1

		on wrap_angle	set val do this.rebuildShape reset_shape:true

		on angle_min	set val do if initialized then this.rebuildShape reset_shape:true
		on angle_max	set val do if initialized then this.rebuildShape reset_shape:true

		on angle_mode	set val do this.rebuildShape reset_shape:true

	)

	rollout params_angle "Angles"
	(
		spinner	SP_wrap_angle	"Wrap Angle"	range:[ 1, 1e9, wrap_angle ]  scale:10.0 tooltip:"Total radius of line"
		spinner	SP_angle_min	"Angle Min"	range:[ 1, 1e9, 90 ] tooltip:"Angle of arch segment"
		spinner	SP_angle_max	"Angle Max"	range:[ 0, 1e9, 0 ]

		radiobuttons RB_angle_mode "Angle Mode" labels:#("Event\Odd", "Random" ) --offset:[-8, 16]


		/* KEEP MIN RADIUS LOWER THEN MAX */
		on SP_angle_min changed val do
			if val > angle_max then angle_max = val


		/* KEEP MAX RADIUS HIGHER THEN MIN */
		on SP_angle_max changed val do
			if val < angle_min  then angle_min = val
	)

	/*------------------------------------------------------------------------------
		PARAMETERS RADIUS
	--------------------------------------------------------------------------------*/

	parameters main rollout:params_radius
	(
		radius_min 	ui:SP_radius_min	type:#float	default:100
		radius_max 	ui:SP_radius_max	type:#float	default:100

		radius_mode 	ui:RB_radius_mode	type:#radiobtnIndex	default:1

		on radius_min	set val do if initialized then this.setValues (#RADIUS)
		on radius_max	set val do if initialized then this.setValues (#RADIUS)

		on radius_mode	set val do this.rebuildShape reset_shape:true
	)

	rollout params_radius "Radius"
	(
		spinner	SP_radius_min	"Radius Min"	range:[ 0, 1e9, radius_min ]
		spinner	SP_radius_max	"Radius Max"	range:[ 0, 1e9, radius_max ]


		radiobuttons RB_radius_mode "Radius Mode" labels:modes --offset:[-8, 16]

		/* KEEP MIN RADIUS LOWER THEN MAX */
		on SP_radius_min changed val do
			if val > radius_max  then radius_max = val

		/* KEEP MAX RADIUS HIGHER THEN MIN */
		on SP_radius_max changed val do
			if val < radius_min  then radius_min = val



	)

	/*------------------------------------------------------------------------------
		PARAMETERS HEIGHT
	--------------------------------------------------------------------------------*/
	parameters main rollout:params_height
	(
		height	ui:SP_height	type:#float default:0
		height_mode 	ui:RB_height_mode	type:#radiobtnIndex	default:1

		on height	set val do if initialized then this.setValues (#HEIGHT) min_val:0 max_val:this.height

		on height_mode	set val do this.rebuildShape reset_shape:true
	)

	rollout params_height "Height"
	(
		spinner	 SP_height	"Height"	range:[ 0, 1e9, height ]
		radiobuttons	RB_height_mode	"Height Mode"	labels:modes --offset:[-8, 16]
	)
	/*------------------------------------------------------------------------------
		PARAMETERS EXTENDS
	--------------------------------------------------------------------------------*/

	parameters main rollout:params_line
	(
		--attach_to_line	ui:SP_attach_to_line	type:#boolean	default:true
		connect_line	ui:SP_connect_line	type:#boolean	default:true
		weld_line	ui:SP_weld_line	type:#boolean	default:true
		--close_line	ui:SP_close_line	type:#boolean	default:true
	)

	rollout params_line "Line setup"
	(
		--checkbox	SP_attach_to_line 	"Attach line"
		checkbox	SP_connect_line 	"Connect"
		checkbox	SP_weld_line 	"Weld"
		--checkbox	SP_close_line	"Close"  enabled:SP_weld_line.state

		button btn_generate "Generate" width:64
		button btn_attach   "Attach"	width:64
		button btn_test      "Test"	width:64
	)

	/*------------------------------------------------------------------------------

		MODIFY ARCH DATA

	--------------------------------------------------------------------------------*/

	/** Get arch data
	  *
	  */
	function setArchData =
	(
		--format "\n"; print "TechArch.ms.setArchData()"

		/**
		  *
		  */
		function getAngle index =
		(
			--print "TechArch.ms.getAngle()"
			--format "index:	% \n" index
			--format "angle_mode:	% \n" angle_mode
			case angle_mode of
			(
				1: if ( mod index 2) != 0 then angle_min else angle_max -- odd is min, even is max
				2: random angle_min angle_max
				default:	angle_min
			)
		)

		this.arches_data = #() -- reset array for new data on rebuild


		angle_counter = 0

		/* GET DATA FOR CIRCLES */
		while angle_counter < wrap_angle do
		(
			arch_data	= Dictionary()
			--format "\n\n"

			arch_data[#ANGLE] = getAngle(this.arches_data.count +1)

			--format "angle_counter:	% \n" angle_counter
			--format "arch_data[#ANGLE]:	% \n" arch_data[#ANGLE]
			arch_data[#ROTATION]	= angle_counter

			angle_counter += arch_data[#ANGLE]

			/* Fit last arc to wrap angle value */
			if angle_counter > wrap_angle then
				arch_data[#ANGLE] -= angle_counter - wrap_angle-- remove overlap value

			append arches_data arch_data
		)

		this.setValues (#RADIUS) rebuilt:false
		this.setValues (#HEIGHT) rebuilt:false min_val:0 max_val:this.height

	)

	/** Set radius
	  *
	  */
	function setValues key min_val: max_val: rebuilt:true =
	(
		--print "TechArch.setRadius()"
		key_str = key as string

		if min_val == unsupplied then
			min_val  = getProperty this ( key_str +"_min" )

		if max_val == unsupplied then
			max_val  = getProperty this ( key_str +"_max" )

		mode_val = getProperty this ( key_str +"_mode" )

		--format "key_str:	% \n" key_str
		--format "min_val:	% \n" min_val
		--format "max_val:	% \n" max_val
		--format "mode_val:	% \n" mode_val

		arch_count = this.arches_data.count

		val_increment = (max_val - min_val) / ( arch_count -  1 )

		--/* FILL DEFAULT VALUE */
		for arch_data in this.arches_data do arch_data[key] = min_val

		if min_val != max_val then
			for i = 1 to arch_count do
			(
				arch_data =  this.arches_data[i]

				arch_data[key] = case mode_val of
				(
					1: if ( mod i 2) != 0 then min_val else max_val -- odd is min, even is max
					2: arch_data[key] + val_increment * (i - 1) --incremanetal radius from lowest to highest
					3: random min_val max_val
					--:
					default: arch_data[key] -- fallback
				)
			)

		if rebuilt then
			this.rebuildShape()
	)


	/*------------------------------------------------------------------------------

		BUILD SHAPES

	--------------------------------------------------------------------------------*/

	/*
	*/
	function rebuildShape reset_shape:false =
	(
		if not initialized then return false
		--print "TchArch.rebuildShape()"
		--format "arch_count:	% \n" this.arches_data.count
		--format "wrap_angle:	% \n" wrap_angle
		--format "height:	% \n" height
		--format "wrap_angle:	% \n" wrap_angle
		--format "angle_min:	% \n" angle_min
		--format "angle_max:	% \n" angle_max
		local spline

		local ShapeWrapper = BezierShapeClass._CreateWrapperFromFPValue BezierShape

		if this.arches_data.count == 0 or reset_shape then
			this.setArchData()

		/* DEBUG PRINT */
		--for arch_data in arches_data do (format "\n"; for key in arch_data.keys do format "%:	% \n" key arch_data[key])

		/* COVERT ARCH DATA DOTO POINTS */
		arches_points = for arch_data in arches_data collect
			this.getArcPoints (arch_data[#ANGLE]) (arch_data[#RADIUS]) (arch_data[#ROTATION]) (arch_data[#HEIGHT])  dir:-1


		/* DEBUG PRINT */
		--for arc_points in arches_points do format "arc_points:	% \n" arc_points

		arches_vectors = for arc_points in arches_points collect this.convertoDotNetVectors(arc_points)

		/* CREATE SHAPE */

		ShapeWrapper.NewShape()

		for i = 1 to arches_vectors.count do
		(
			is_line_last	= i == arches_vectors.count

			--format "\n\n"
			arc_vectors	= arches_vectors[i]
			arc_vectors_next	= if is_line_last then arches_vectors[i] else arches_vectors[1+1]
			last_knot	= arc_vectors[arc_vectors.count] -- last knot of current arc
			first_knot	= arc_vectors_next[1] -- first knot of next arc

			if i == 1 or not  (connect_line and weld_line) then
				spline = ShapeWrapper.NewSpline()

			for arc_vector in arc_vectors do
				spline.AddKnot ( getSplineKnot (arc_vector[#point]) (arc_vector[#inVec]) (arc_vector[#outVec]) BezierCornerKnot )

			if connect_line and not weld_line then
			(
				spline = ShapeWrapper.NewSpline()

				if last_knot[#point] != first_knot[#point] then
				(
					spline.AddKnot ( getSplineKnot (last_knot[#point])	(last_knot[#inVec])	(last_knot[#outVec]) bezierKnot )
					spline.AddKnot ( getSplineKnot (first_knot[#point])	(first_knot[#inVec])	(first_knot[#outVec]) bezierKnot )
				)
			)

			--format "TEST:	% \n" (last_knot[#point] != first_knot[#point])

			if is_line_last and connect_line and weld_line and last_knot[#point] != first_knot[#point] then
				spline.SetClosed()
		)

		ShapeWrapper.UpdateSels()
		ShapeWrapper.InvalidateGeomCache()

		updateShape

		this.initialized	= true
		this.build 	= true
	)


	/** Init
	  *
	  */
	function init obj: =
	(
		--if this.initialized then return true
		--format "\n"; print "TechArch.init()"

		this.obj = if obj != unsupplied then obj else refs.dependentNodes this firstOnly:on

		this.initialized = true
	)

	/*------------------------------------------------------------------------------

		EVENTS

	--------------------------------------------------------------------------------*/

	on load do
	(
		--print "TechArch.load()"
	)

	on postLoad  do
	(
		--print "TechArch.postLoad()"
		this.init()
	)

	on create do
	(
		--print "TechArch.create()"
	)

	on postCreate do
	(
		--print "TechArch.postCreate()"
	)

	on attachedToNode _node do
	(
		--print "TechArch.attachedToNode()"

		this.init obj:_node

	)

	tool create
	(
		on mousePoint click do
		(
			case click of
			(
				1: nodeTM.translation = worldPoint
			)
		)
		on mouseMove click do
		(
			case click of
			(
			--	2: radius = (gridDist.y^2+gridDist.x^2)^.5
				3: #stop
			)
		)
	)

	--on create do initialized = false
	--on postCreate do initialized = true

	on buildShape do
	(
		--if not build then
		if this.arches_data.count == 0 then
			rebuildShape()

	)
)
