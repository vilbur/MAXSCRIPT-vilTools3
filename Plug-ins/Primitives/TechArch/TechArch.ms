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
		--arcs_data.count 	ui:SP_pieces	type:#integer	default:5
		width	ui:SP_width	type:#float	default:20
		height	ui:SP_height	type:#integer default:20
		chamfer	ui:SP_chamfer	type:#float	default:0


		on radius		set val do if initialized then this.generate()
		--on arcs_data.count	  set val do if initialized then this.generate()
		--on wrap_angle		set val do if initialized then this.generate()
		on width		set val do if initialized then this.generate()

	)

	parameters main rollout:params_angle
	(
		wrap_angle	ui:SP_wrap	type:#float	default:270

		angle_to	ui:SP_angle_min	type:#integer default:90
		angle_var	ui:SP_angle_var	type:#integer default:0

		random_angle 	ui:CBX_random_angle	type:#boolean	default:false

		on random_angle  set val do if initialized then this.generate()
	)

	parameters main rollout:params_variation
	(
		random_radius 	ui:CBX_random_radius	type:#boolean	default:false

		on random_radius set val do if initialized then this.generate()
	)

	parameters main rollout:params_extended
	(

		attach_to_line	ui:SP_attach_to_line	type:#boolean	default:false
		connect_line	ui:SP_connect_line	type:#boolean	default:false
	)

	/*------------------------------------------------------------------------------

		ROLLOUTS

	--------------------------------------------------------------------------------*/

	rollout params "Parameters"
	(
		spinner	SP_radius	"Radius"	range:[ 0, 9999, radius ]
		--spinner	SP_pieces	"Pieces"	range:[ 1, 9999, arcs_data.count ]	type:#integer tooltip:"Number anlge arcs_data.count"
		spinner	SP_width	"Width"	range:[ 0, 9999, width ]
		spinner	SP_height	"Height"	range:[ 0, 9999, height ]
		spinner	SP_chamfer "Chamfer"	range:[ 0, 10, 0 ]	type:#float

	)

	rollout params_angle "Anlges"
	(
		spinner	SP_angle_min	"Angle Min"	range:[ 0, 9999, 90 ] tooltip:"Angle of arch segment"
		spinner	SP_angle_var	"Angle Variation"	range:[ 0, 9999, 0 ]
		spinner	SP_wrap	"Wrap"	range:[ 1, 9999, wrap_angle ]	 tooltip:"Total radius of line"

		checkbox	CBX_random_angle "Random Angle"


	)

	rollout params_variation "Variations"
	(
		checkbox	CBX_random_radius 	"Random Radius"

	)


	rollout params_extended "Parameters Extends"
	(

		checkbox	SP_attach_to_line 	"Attach line"
		checkbox	SP_connect_line 	"Connect line"
		checkbox	SP_close_line	"Close line"

		button btn_generate "Generate"	width:64
		button btn_attach   "Attach"		width:64
		button btn_test      "Test"			width:64

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
		format "\n"; print "TechArch.ms.generate()"
		--format "ROUNDS:	% \n" arcs_data.count

		initialized = false

		with redraw off
		(
			this._setNodeObject()

			this.removeAllLines()

			this.generateArches()

			if connect_line then
				this.createConnectLine()
		)

		--DisableSceneRedraw()

		initialized = true

	)

	/** Create connect line
	  *
	  */
	function createConnectLine =
	(
		format "\n"; print "TechArch.ms.createConnectLine()"

		/** Get First And Last Vertext From Each Spline
		  *
		  */
		function getFirstAndLastVertextFromEachSpline =
		(
			format "\n"; print "TechArch.ms.getFirstAndLastVertextFromEachSpline()"
			last_knot_i = 1
			verts_pos_all = #()

			for spline_current = 1 to numSplines this.obj - 1 do
			(
				spline_next = spline_current + 1
				num_knots	= numKnots this.obj spline_current

				--format "last_knot_i:	% \n" last_knot_i
				--format "num_knots:	% \n" num_knots
				spline_current_last_vert	= getKnotPoint this.obj (spline_current) ( numKnots this.obj spline_current  )
				spline_next_first_vert	= getKnotPoint this.obj (spline_next) 1

				append verts_pos_all #( spline_current_last_vert, spline_next_first_vert )
				--append verts_pos_all #( last_knot_i, last_knot_i + num_knots - 1 )

				last_knot_i += num_knots
			)

			verts_pos_all --return
		)

		this._setNodeObject()

		verts_pos = getFirstAndLastVertextFromEachSpline()

		connect_line_shape = SplineShape()


		for i = 1 to verts_pos.count do
		(
			--format "i:	% \n" i
			--format "verts_pos:	% \n" verts_pos

			addNewSpline connect_line_shape

			addKnot connect_line_shape i #corner #line verts_pos[i][1]
			addKnot connect_line_shape i #corner #line verts_pos[i][2]
		)

		/* ATTACH TO OBJECT */
		this.attatchLines this.obj  #(connect_line_shape)
	)

	/** Remove connect line
	  *
	  */
	function removeConnectLine =
	(
		format "\n"; print "TechArch.ms.removeConnectLine()"
		for spline_i = Arcs.count + 1 to numSplines this.obj do
			deleteSpline this.obj 1

		updateShape this.obj
	)

	/** Generate arch
	  *
	  */
	function generateArches =
	(
		format "\n"; print "TechArch.ms.generateArches()"

		--format "\n-----------\nARRAY:arcs_data:\n";  for _arc in this.arcs_data do format "_arc:	%\n" _arc

		/** Set arches
		  *
		  */
		function setArchesByAngle =
		(
			format "\n"; print "TechArch.ms.setArches()"

			angle_counter = 0

			while angle_counter < wrap_angle do
			(
				arc_data	= Dictionary()

				arc_data[#FROM]	= 0 --+ chamfer
				arc_data[#TO]	= angle_to --- chamfer
				arc_data[#RADIUS]	= radius
				arc_data[#ROTATION]	= angle_counter

				angle_counter += angle_to

				append arcs_data arc_data
			)

			--format "arcs_data.count:	% \n" arcs_data.count
		)


		/** Get angles
		  *
		  */
		function getAngles =
		(
			--format "\n"; print "TechArch.ms.getAngles()"
			angles = for i = 1 to arcs_data.count collect  wrap_angle / arcs_data.count

			angle_increment = ( wrap_angle / arcs_data.count )

			for i = 1 to arcs_data.count do append angles ( angle_increment * i )

			angles --return
		)

		/** Get radiuse value of arch splines
		  */
		function setRadiusVariations =
		(
			--format "\n"; print "TechArch.ms.getAngles()"
			if width == 0 then
				return false --return

			for i = 1 to arcs_data.count do
				if random_radius == false then
				(
					/* RADIUS INCREMENTAL FROM MIN for FIRST TO MAX LAST ARCH */
					radius_increment = width / ( arcs_data.count -  1 ) as float

					arcs_data[i][#RADIUS] +=  radius_increment * (i - 1)
				)
				else
					arcs_data[i][#RADIUS] = random (radius)(radius + width)


			arcs_data[1][#RADIUS]	= radius	-- set min radius to FIRST RADIUS
			arcs_data[arcs_data.count][#RADIUS]	= (radius + width)	-- set max radius to LAST RADIUS

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
		--format "\n"; print "TechArch.ms.attachAllToObj()"
		all_arcs = for arc_data in arcs_data where isValidNode arc_data[#NODE] collect arc_data[#NODE]

		this.attatchLines (this.obj) ( all_arcs )
	)

	/** Remove lines
	  *
	  */
	function removeAllLines =
	(
		format "\n"; print "TechArch.ms.removeAllLines()"
		--format "\n-----------\nARRAY:arcs_data:\n";  for _arc in this.arcs_data do format "_arc:	%\n" _arc

		for arc_data in arcs_data where isValidNode arc_data[#NODE] do delete arc_data[#NODE]

		this.arcs_data = #()

		/* DELETE SPLINE SEGMENTS */
		for spline_i = 1 to numSplines this.obj do
			deleteSpline this.obj 1
			--deleteSpline this.obj 1

		updateShape this.obj
	)

	/*------------------------------------------------------------------------------

		PRIVATE

	--------------------------------------------------------------------------------*/

	/** Attatch lines
	  *`
	  */
	function attatchLines spline splines =
	(
		for s in splines where s != spline do addAndWeld spline ( convertToSplineShape s) -1

		weldSpline spline 0.01
	)

	/** Get node obejct
	 */
	function _setNodeObject =
	(
		nodes = for o in refs.dependents this where isValidNode o collect o

		this.obj = nodes[1] --return
	)


	--on create do generate()
	--on postCreate do generate()

	on attachedToNode _node  do
	(
		--format "\n"; print ".attachedToNode()"
		--format "_node:	% \n" _node
		this.obj = _node

		this.generate()
		--this._node.name = _node
	)
	--on postCreate do initialized = true

	--on buildShape do rebuildShape()
	--
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