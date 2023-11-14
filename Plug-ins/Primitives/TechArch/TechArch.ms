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
		pieces 	ui:SP_pieces	type:#integer	default:5
		wrap	ui:SP_wrap	type:#float	default:270
		width	ui:SP_width	type:#float	default:20

		on radius	set val do if initialized then this.generate()
		on pieces	set val do if initialized then this.generate()
		on wrap		set val do if initialized then this.generate()
		on width		set val do if initialized then this.generate()
	)

	parameters main rollout:params_variation
	(
		random_radius 	ui:CBX_random_radius	type:#boolean	default:false

		on random_radius set val do if initialized then this.generate()
	)


	/*------------------------------------------------------------------------------

		ROLLOUTS

	--------------------------------------------------------------------------------*/

	rollout params "Parameters"
	(
		spinner	SP_radius	"Radius"	range:[ 0, 9999999, radius ]
		spinner	SP_pieces	"Pieces"	range:[ 1, 9999999, pieces ]	type:#integer tooltip:"Number anlge pieces"
		spinner	SP_wrap	"Wrap"	range:[ 1, 9999999, wrap ]	 tooltip:"Total radius of line"
		spinner	SP_width	"Width"	range:[ 0, 9999999, width ]
	)

	rollout params_variation "Variations"
	(
		checkbox	CBX_random_radius 	"Random Radius"

	)

	parameters main rollout:params_extended
	(
		height	ui:SP_height	type:#integer default:20
		chamfer	ui:SP_chamfer	type:#float	default:0

		connect_line	ui:SP_connect_line	type:#boolean	default:true

		on chamfer	 set val do if initialized then this.generate()
		on height		set val do if initialized then this.generate()

		--on chamfer set val do if initialized then this.generate()
	)

	rollout params_extended "Parameters Extends"
	(
		spinner	SP_height "Height"	type:#float
		spinner	SP_chamfer "Chamfer"	range:[ 0, 10, 0 ]	type:#float

		checkbox	SP_connect_line 	"Connect line"
		checkbox	SP_close_line	"Close line"

		button btn_test "Generate"

		on btn_test pressed do this.generate()
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
		--format "ROUNDS:	% \n" pieces

		--max_mode = GetCommandPanelTaskMode()

		--max create mode

		with redraw off
		(

			this.removeAllLines()

			initialized = false

			this._setNodeObject()

			this.removeAllLines()

			this.generateArches()

			if connect_line then
				this.createConnectLine()
		)
		--DisableSceneRedraw()

		initialized = true

		--SetCommandPanelTaskMode(max_mode)
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

		format "\n-----------\nARRAY:arcs_data:\n";  for _arc in this.arcs_data do format "_arc:	%\n" _arc
		/** Get angles
		  *
		  */
		function getAngles =
		(
			--format "\n"; print "TechArch.ms.getAngles()"
			angles = for i = 1 to pieces collect  wrap / pieces

			angle_increment = ( wrap / pieces )

			for i = 1 to pieces do append angles ( angle_increment * i )

			angles --return
		)

		/** Get radiuse value of arch splines
		  */
		function getRadiuses =
		(
			--format "\n"; print "TechArch.ms.getAngles()"
			/* RADIUS EQUAL */
			radiuses = for i = 1 to pieces collect radius

			if width > 0 then
			(
				--format "random_radius:	% \n" random_radius
				if random_radius == false then
				(
					/* RADIUS INCREMENT */
					radius_increment = width / ( pieces -  1 ) as float

					for i = 1 to radiuses.count do
						radiuses[i] +=  radius_increment * (i - 1)
				)
				else
					radiuses = for i = 1 to pieces collect random (radius)(radius + width)

				radiuses[1]	= radius	-- set min radius to first radius
				radiuses[radiuses.count]	= (radius + width)	-- set max radius to last radius

			)

			radiuses --return
		)

		/** Get height positions
		  *
		  */
		function getHeightPositions =
		(
			--format "\n"; print "TechArch.ms.getHeightPositions()"
			height_increment = height / ( pieces -  1 ) as float

			for i = 1 to pieces collect [ this.obj.pos.x, this.obj.pos.x, this.obj.pos.z + ( height_increment * (i - 1) ) ]
		)


		/** Create arch obejcts
		  *
		  */
		function setArcsData radiuses angles positions =
		(
			--format "\n"; print "TechArch.ms.setArcData()"

			angle_counter = 0

			for i = 1 to pieces do
			(
				arc_data	= Dictionary()

				arc_data[#RADIUS]	= radiuses[i]
				arc_data[#FROM]	= 0 + chamfer
				arc_data[#TO]	= angles[i] - chamfer
				arc_data[#POSITION]	= positions[i]
				arc_data[#ROTATION]	= angle_counter

				append this.arcs_data arc_data

				angle_counter	+= angles[i]

			)
		)

		/** Create arch obejcts
		  *
		  */
		function createArcsObjects =
		(
			--format "\n"; print "TechArch.ms.setArcData()"

			arcs_lines = #()


			for arc_data in arcs_data do
			(
				arc_line = Arc radius:arc_data[#RADIUS] from:arc_data[#FROM]  to:arc_data[#TO] pos:arc_data[#POSITION] pie:off reverse:off

				Rotate arc_line ( AngleAxis arc_data[#ROTATION] [0,0,1])

				append arcs_lines arc_line
			)

			arcs_lines --return
		)

		angles 	= getAngles()
		radiuses 	= getRadiuses()
		positions 	= getHeightPositions()


		if arcs_data.count == 0 then
			setArcsData(radiuses)(angles)(positions)

		arcs_lines = createArcsObjects()

		/* ATTACH TO OBJECT */
		this.attatchLines (this.obj) (arcs_lines)
	)



	/** Remove lines
	  *
	  */
	function removeAllLines =
	(
		--format "\n"; print "TechArch.ms.removeAllLines()"
		--format "this.obj:	% \n" this.obj
		--format "numSplines this.obj:	% \n" (numSplines this.obj)

		for spline_i = 1 to numSplines this.obj do
			deleteSpline this.obj 1
			--deleteSpline this.obj 1

		updateShape this.obj
	)
	--/** Weld all verts of splione
	--  *
	--  */
	--function weld =
	--(
	--	--format "\n"; print "TechArch.ms.weld()"
	--	weldSpline this.obj 0.01
	--)

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