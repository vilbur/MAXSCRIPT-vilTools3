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
	local radius = 40
	local radius_outter = 50

	/* properties */
	local initialized = false


	/* store */
	local obj

	--local pieces = 3
	--local

	local Arcs = #()

	--local chamfer_val = 2
	local angle_from = 0
	local angle_to = 0


	parameters main rollout:params
	(
		pieces  default:3 type:#integer	ui:SP_pices
		chamfer_val default:0 type:#float	ui:SP_chamfer
		connect_line default:true type:#boolean	ui:SP_connect_line

		on pieces set val do if initialized then this.generate()
		on chamfer_val set val do if initialized then this.generate()

	)

	rollout params "Parameters"
	(
		--spinner	SP_pices  "Rounds: "   range:[ 2, 10, 3 ] type:#integer
		spinner	SP_pices  "Rounds: "   range:[ 3, 10, 3 ] type:#integer
		spinner	SP_chamfer "Chamfer: " range:[ 0, 10, 3 ] type:#float

		button	SP_generate "Generate"
		button	SP_reset "Reset"
		checkbox	SP_connect_line 	"Connect line"
		checkbox	SP_close_line	"Close line"

		button	BTN_test "Test"

		on SP_reset	    pressed do	this.removeAllLines()
		--on SP_generate	pressed do this.generate()

		on SP_connect_line changed val do if initialized do if val then this.createConnectLine() else this.removeConnectLine()
		--this.removeAllLines()

		--on BTN_test pressed do	--this.removeAllLines()
			--messageBox "Yupiii" title:"Title"  beep:false
	)

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

			--this.attatchLines this.obj  #(connect_line)

			--format "CONNECT_LINE:	% \n" connect_line
			if connect_line then
				this.createConnectLine()
		)
		--DisableSceneRedraw()

		initialized = true

		--if selection[1] != this.obj then
			--select this.obj

		--SetCommandPanelTaskMode(max_mode)
	)

	/** Attatch lines
	  *`
	  */
	function attatchLines spline splines =
	(
		for s in splines where s != spline do addAndWeld spline ( convertToSplineShape s) -1

		weldSpline spline 0.01
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
			--format "\n"; print "TechArch.ms.getFirstAndLastVertextFromEachSpline()"
			last_knot_i = 1
			verts_pos_all = #()

			for spline_current = 1 to numSplines this.obj - 1 do
			(
				--format "\n"
				--format "spline_current:	% \n" spline_current

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
			format "i:	% \n" i

			addNewSpline connect_line_shape

			addKnot connect_line_shape i #corner #line verts_pos[i][1]
			addKnot connect_line_shape i #corner #line verts_pos[i][2]
		)

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
		--format "\n"; print "TechArch.ms.generateArches()"

		--delete objects

		this.Arcs = #()

		angle_increment = ( 360 / pieces )

		radius_increment = ( radius_outter - radius ) / ( pieces -  1 ) as float

		radiuses = #(radius)

		for i = 1 to pieces - 1 do append radiuses ( radius + ( radius_increment * i ))

		for i = 1 to pieces do
		(
			_Arc = Arc radius:radiuses[i] from:(angle_from + chamfer_val) to:( angle_increment - chamfer_val ) pie:off reverse:off pos:[0, 0, 10 * (i - 1) ]

			Rotate _Arc ( AngleAxis angle_to [0,0,1])
			--angle_from	+= angle_to
			angle_to	+= angle_increment

			append Arcs _Arc
		)

		this.attatchLines (this.obj) (this.Arcs)
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