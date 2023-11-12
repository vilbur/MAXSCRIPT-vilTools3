--plugin simpleSpline techArch -- superclasses: https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-B0B9C1BF-168C-47D2-A4BE-12D93116FE79
plugin shape techArch -- superclasses: https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-B0B9C1BF-168C-47D2-A4BE-12D93116FE79
name:	"Tech Arch"
category:	"Splines"
extends:	SplineShape

classID:	#( 0x3083a88, 0x27add00b ) -- genClassID() -- genrate id
version:	0.1
replaceUI:	true
(
	local obj
	local initialized = false

	--local rounds = 3
	--local
	local radius = 40
	local radius_outter = 50

	local Arcs = #()

	local chamfer_val = 2
	local angle_from = 0
	local angle_to = 0





	parameters main rollout:params
	(
		rounds default:3 type:#float ui:SP_rounds

		on rounds set val do if initialized then this.generate()

	)

	rollout params "Parameters"
	(
		spinner SP_rounds "Rounds: " range:[0, 10, 3 ] type:#integer

		button SP_reset "Reset"

		on  SP_reset pressed do this.removeLines()
			--messageBox "Yupiii" title:"Title"  beep:false
	)




	/** Generate
	  *
	  */
	function generate =
	(
		--format "\n"; print "TechArch.ms.generate()"
		--format "ROUNDS:	% \n" rounds

		max_mode = GetCommandPanelTaskMode()

		max create mode

		/** Attatch lines
		  *`
		  */
		function attatchLines spline splines =
		(
			for s in splines where s != spline do addAndWeld spline ( convertToSplineShape s) -1
		)

		/** Create connect line
		  *
		  */
		function createConnectLine connect_line verts_pos =
		(
			--format "\n"; print "TechArch.ms.createConnectLine()"

			for i = 1 to verts_pos.count do
			(
				addNewSpline connect_line

				start_pos =  verts_pos[i][2]
				end_pos   =  if  i < verts_pos.count then verts_pos[i + 1][1] else verts_pos[1][1]

				addKnot connect_line i #corner #line start_pos
				addKnot connect_line i #corner #line end_pos
			)

			connect_line --return
		)

		initialized = false

		this._setNodeObejct()

		this.removeLines()

		--format "_node:	% \n" _node
		this.generateArch()

		--format "\n"; print "TechArch.ms.generateConnectLine()"

		verts_pos = this.getVertexPositions()


		connect_line = createConnectLine(SplineShape())(verts_pos)


		--for i = 1 to verts_pos.count do
		--(
		--	addNewSpline connect_line
		--
		--	start_pos =  verts_pos[i][2]
		--	end_pos   =  if  i < verts_pos.count then verts_pos[i + 1][1] else verts_pos[1][1]
		--
		--	addKnot connect_line i #corner #line start_pos
		--	addKnot connect_line i #corner #line end_pos
		--)

		attatchLines this.obj (join #(connect_line) Arcs)

		--splines = deepCopy Arcs

		--append splines connect_line

		--for s in splines where s != this.obj do addAndWeld this.obj ( convertToSplineShape s) -1

		initialized = true

		select this.obj

		SetCommandPanelTaskMode(max_mode)

	)

	/** Remove lines
	  *
	  */
	function removeLines =
	(
		--format "\n"; print "TechArch.ms.removeLines()"
		--format "this.obj:	% \n" this.obj
		--format "numSplines this.obj:	% \n" (numSplines this.obj)

		for spline_i = 1 to numSplines this.obj do
			deleteSpline this.obj 1
			--deleteSpline this.obj 1

		updateShape this.obj
	)

	/** Generate arch
	  *
	  */
	function generateArch =
	(
		--format "\n"; print "TechArch.ms.generateArch()"

		--delete objects

		Arcs = #()

		angle_increment = ( 360 / rounds )

		radius_increment = ( radius_outter - radius ) / ( rounds -  1 ) as float

		radiuses = #(radius)

		for i = 1 to rounds - 1 do append radiuses ( radius + ( radius_increment * i ))


		for i = 1 to rounds do
		(
		--	format "radiuses[i]:	% \n" radiuses[i]
		--	format "angle_from:	% \n" angle_from
		--	format "angle_to:	% \n" angle_to

			_Arc = Arc radius:radiuses[i] from:(angle_from + chamfer_val) to:( angle_increment - chamfer_val) pie:off reverse:off pos:[0, 0, 10 * (i - 1) ] isSelected:on

			Rotate _Arc ( AngleAxis angle_to [0,0,1])
			--angle_from	+= angle_to
			angle_to	+= angle_increment

			append Arcs _Arc
		)


	)

	/** Get vertex positions
	  *
	  */
	function getVertexPositions =
	(
		--format "\n"; print "TechArch.ms.getVertexPositions()"
		verts_pos_all = #()

		for _Arc in Arcs do
			--format "_Arc:	% \n" _Arc

		for _Arc in Arcs do
		(
			convertTo _Arc SplineShape
			verts_pos = #()

			for spline_i = 1 to numSplines _Arc do
				for knot_i = 1 to numKnots _Arc spline_i do
					--format "knot_i:	% \n" knot_i
					append verts_pos ( getKnotPoint _Arc spline_i knot_i )

			append verts_pos_all #( verts_pos[1], verts_pos[verts_pos.count] )
		)
		--format "verts_pos_all:	% \n" verts_pos_all
		verts_pos_all --return
	)


	/*------------------------------------------------------------------------------

		PRIVATE

	--------------------------------------------------------------------------------*/

	/** Get node obejct
	 */
	function _setNodeObejct =
	(
		--format "\n"; print "._setNodeObejct()"
		nodes = for o in refs.dependents this where isValidNode o collect o
		--format "nodes:	% \n" nodes
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