plugin SimpleSpline techArch
name:	"Tech Arch"

classID:	#( 0x3083a88, 0x27add00b ) -- genClassID()
category:	"Splines"
(
	local obj

	local circles = #()

	local initialized	= false

	local build = false

	/*------------------------------------------------------------------------------
		BUILD SHAPE METHODS
	--------------------------------------------------------------------------------*/

	include "buildShape.ms"

	/*------------------------------------------------------------------------------

		PARAMETERS

	--------------------------------------------------------------------------------*/

	parameters main rollout:params
	(
		--pos_test 	type:#float	default:50

		radius 	ui:SP_radius	type:#float	default:100
		width	ui:SP_width	type:#float	default:0
		height	ui:SP_height	type:#float default:0
		gap_angle	ui:SP_gap_angle	type:#float	default:0

		on radius	set val do this.rebuildShape()
		on height	set val do this.rebuildShape()
		on width	set val do this.rebuildShape()
		--on width	set val do this.setWidth()
		--on height	set val do this.setHeight()
		--on gap_angle	set val do this.generate()
	)

	parameters main rollout:params_angle
	(
		wrap_angle	ui:SP_wrap	type:#float	default:360

		angle_min	ui:SP_angle_min	type:#integer default:90
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


	/*
	*/
	fn rebuildShape =
	(
		if not initialized then return false

		print "TechArch.rebuildShape()"
		format "height:	% \n" height
		--format "this.radius:	% \n" this.radius
		--format "wrap_angle:	% \n" wrap_angle
		--format "angle_min:	% \n" angle_min
		/** Get arch data
		  *
		  */
		function getArchData =
		(
			--format "\n"; print "TechArch.ms.getArchData()"
			arches_data = #()

			angle_counter = 0

			/* GET DATA FOR CIRCLES */
			while angle_counter < wrap_angle do
			(
				arch_data	= Dictionary()

				arch_data[#ANGLE] = angle_min

				arch_data[#ROTATION]	= angle_counter

				arch_data[#POS_Z]	= random 0 this.height

				arch_data[#RADIUS] = this.radius - ( random 0 this.width )

				angle_counter += arch_data[#ANGLE]

				--format "angle_counter:	% \n" angle_counter
				/* Fit last arc to wrap angle value */
				if angle_counter > wrap_angle then
					arch_data[#ANGLE] -= angle_counter - wrap_angle-- remove overlap value

				append arches_data arch_data
			)

			arches_data --return
		)

		arches_data = getArchData()

		ShapeWrapper = BezierShapeClass._CreateWrapperFromFPValue BezierShape

		ShapeWrapper.NewShape()

		for arch_data in arches_data do
		(
			spline = ShapeWrapper.NewSpline()

			this.make2PointArc arc_angle:arch_data[#ANGLE] arc_radius:arch_data[#RADIUS] angle_rot:arch_data[#ROTATION] dir:1 pos_z:arch_data[#POS_Z] AddKnot:spline.AddKnot
		)

		ShapeWrapper.UpdateSels()
		ShapeWrapper.InvalidateGeomCache()

		updateShape

		--this.initialized = true
		this.build = true
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

	on attachedToNode _node do
	(
		print "TechArch.attachedToNode()"

		this.obj = _node

		this.initialized = true
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
		if not build then
			rebuildShape()

	)
)
