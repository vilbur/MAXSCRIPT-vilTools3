
/*
 */
struct PlatformGenerator_v
(
	/* construct */
	obj, -- object to generate platforms

	/* properties */
	_shape,
	mat_id_face_top	= 1,
	mat_id_face_bottom	= 2,

	/* options */
	bottom_layers_height = 2, -- height of base where


	extrude_bottom	= 2, -- height of base where
	extrude_top	= 2, -- height of base where


	/* dependency */
	/* reference */
	/* inhered */

	/** /** Generate
	  *
	  */
	function generate =
	(
		format "\n"; print "PlatformGenerator_v.generate()"
		format "obj:	% \n" obj

		this._generateLines()

		this._addSweepModifier()


		/* EXTREUDE TOP */
		this._selectCapFace(mat_id_face_top)

		this._chamfer()

		this._extrude(extrude_bottom)(50)

		/* EXTREUDE BOTTOM */
		this._selectCapFace(mat_id_face_bottom)

		this._extrude(extrude_bottom)(500)

		this._addMeshmooth( 3 )

		--updateShape _shape

		CompleteRedraw()

		_shape --return
	),

	private

	/** Generate lines
	  *
	  */
	function _generateLines =
	(
		format "\n"; print "PlatformGenerator_v.generateLines()"
		_shape      	= SplineShape pos:obj.pos name:(obj.name + "-platform") wirecolor:green
		vertext_count	= getNumVerts obj.mesh
		vertext_sel  	= (getVertSelection obj.mesh )	as Array

		fn makeLine obj _shape vertex_index spline_index =
		(
			format "vertex_index:	% \n" vertex_index
			addNewSpline _shape

			splines_count = _shape.numSplines

			pos = (getVert obj.mesh vertex_index) * obj.transform

			addKnot _shape splines_count #corner #line pos

			--normal = (getNormal obj.mesh vertex_index) * obj.transform - obj.pos

			--pos += spnLength.value * normalize( normal )

			pos.z = bottom_layers_height

			addKnot _shape splines_count #corner #line pos

			setMaterialID _shape spline_index 1 3 -- setMaterialID <splineShape> <spline_index> <seg_index> <matID

		)

		verts_to_generate = if vertext_sel.count != 0 then vertext_sel else #{1..vertext_count} as Array

		for i = 1 to verts_to_generate.count do
			makeLine obj _shape verts_to_generate[i] i


		updateShape _shape

		--if spnSegments.value > 1 do for i = 1 to _shape.numSplines do
		--(
		--	subdivideSegment _shape i 1 ( spnSegments.value - 1 )
		--
		--	for j = 1 to numKnots _shape i do
		--		setKnotType _shape i j #smooth
		--)
	),

	/** Set spline mesh
	  *
	  */
	function _setSplineMesh =
	(
		format "\n"; print "PlatformGenerator_v._setSplineMesh()"
		format "_shape:	% \n" _shape

		_shape.render_displayRenderMesh  = true -- show in viewport
		--_shape.render_viewport_thickness   	= 5
		--_shape.render_viewport_sides  	= 32
	),

	/** Add modifiers
	  *
	  */
	function _addSweepModifier =
	(
		--format "\n"; print "PlatformGenerator_v._addSweepModifier()"
		sweep_mod = sweep()

		addModifier _shape sweep_mod

		sweep_mod.CurrentBuiltInShape = 2

		redrawViews() -- IMPORTANT TO UPDATE AFTER SETTING SHAPE AND BEFORE EDITING ITS PROPERTIES

		--sweep_mod.CustomShapeName = ""
		sweep_mod[#Bar_Section].length	= 10
		sweep_mod[#Bar_Section].width 	= 10
		sweep_mod[#Bar_Section].cornerRadius = 0
	),

	/** Add select modifier
	  *
	  */
	function _selectCapFace mat_id =
	(
		--format "\n"; print "PlatformGenerator_v._selectCapFace()"

		volume_sel_mod = Vol__Select()

		volume_sel_mod.level	= 2	-- select face
		volume_sel_mod.volume	= 5	-- select material ID
		volume_sel_mod.matID	= mat_id	-- select bottom face

		addModifier _shape volume_sel_mod
	),

	/** Delete bottom face
	  *
	  */
	function _deleteBottomFace =
	(
		addModifier _shape (DeleteMesh ())
	),

	/** Chamfer
	  *
	  */
	function _chamfer =
	(
		--format "\n"; print "PlatformGenerator_v._chamfer()"

		chamfer_mod = Chamfer amount:amount

		chamfer_mod.amountType = 0
		chamfer_mod.amount = 3
		chamfer_mod.segments = 2

		addModifier _shape chamfer_mod

	),

	--/** Cap hole
	--  *
	--  */
	--function _capHole =
	--(
	--	--addModifier _shape (Cap_Holes ())
	--	addModifier _shape (Cap_Holes smooth:false )
	--),

	/** Add extrude modifier
	  *
	  */
	function _extrude amount _scale =
	(
		--format "\n"; print "PlatformGenerator_v._extrudeBase()"
		extrude_mod = Face_Extrude amount:amount

		extrude_mod.scale	= _scale

		addModifier _shape extrude_mod

	),

	/** Add meshmooth
	  *
	  */
	function _addMeshmooth iterations =
	(
		--format "\n"; print "PlatformGenerator_v._addMeshmooth()"

		meshsmooth_mod = meshsmooth()

		addModifier _shape meshsmooth_mod

		--meshsmooth_mod.sepBySmGroups = off
		meshsmooth_mod.sepByMats	= true
		meshsmooth_mod.iterations	= iterations
	),

	/**
	 */
	on create do
	(
	)
)