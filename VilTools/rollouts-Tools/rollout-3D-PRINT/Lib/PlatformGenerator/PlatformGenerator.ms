
/*
 */
struct PlatformGenerator_v
(
	/* construct */
	obj, -- object to generate platforms

	/* properties */
	_shape,

	/* options */
	bar_width = 10,

	bottom_layers_height = 2, -- height of base where


	extrude_bottom	= 2, -- height of base where
	extrude_top	= 2, -- height of base where

	materials	= Dictionary #( #TOP, 1 ) #( #MIDDLE, 3 ) #( #BOTTOM, 2 ) #( #BASE, 4 ) #( #CHMAFER, 5 ), -- #top and #bottom are read-only and they are default by Edit Spline

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

		select _shape

		this._addSweepModifier()


		/* EXTREUDE BOTTOM */
		this._selectFace(materials[#BASE])("Select Base")

		--this._extrude(extrude_bottom)(500)("Extrude Base")

		this._taperBase()


		/* EXTREUDE TOP */
		this._selectFace(materials[#TOP])("Select Top Face")

		this._chamfer("Chamfer Top")

		this._selectFace(materials[#TOP])("Select Top Face")

		this._extrude(extrude_top)(100)("Extrude Top")

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

			setMaterialID _shape spline_index 1 materials[#MIDDLE] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID

			pos.z = 0

			addKnot _shape splines_count #corner #line pos

			setMaterialID _shape spline_index 2 materials[#BASE] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID

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

		sweep_mod[#Bar_Section].length	= bar_width
		sweep_mod[#Bar_Section].width 	= bar_width

		sweep_mod[#Bar_Section].cornerRadius = 0
	),

	/** Add select modifier
	  *
	  */
	function _selectFace mat_id name =
	(
		--format "\n"; print "PlatformGenerator_v._selectFace()"

		volume_sel_mod = Vol__Select name:name

		volume_sel_mod.level	= 2	-- select face
		volume_sel_mod.volume	= 5	-- select by material ID
		volume_sel_mod.matID	= mat_id	-- select face by mat ID

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
	function _chamfer name =
	(
		--format "\n"; print "PlatformGenerator_v._chamfer()"

		chamfer_mod = Chamfer name:name

		--chamfer_mod.amountType = 0
		chamfer_mod.amount 	 = ( bar_width / 3 ) as integer
		chamfer_mod.segments = 0


		chamfer_mod.setmaterial	= true
		chamfer_mod.materialID	= materials[#CHMAFER]


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
	function _extrude amount _scale name =
	(
		--format "\n"; print "PlatformGenerator_v._extrudeBase()"
		extrude_mod = Face_Extrude name:name

		extrude_mod.amount	= amount

		extrude_mod.scale	= _scale

		addModifier _shape extrude_mod
	),

	/** Taper base
	  *
	  */
	function _taperBase =
	(
		--format "\n"; print "PlatformGenerator_v._taperBase()"
		taper_mod = Taper ()

		taper_mod.name = "Taper Base"

		taper_mod.amount = -5

		taper_mod.limit = on

		taper_mod.lowerlimit = -5

		modPanel.addModToSelection ( taper_mod ) ui:on
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

		meshsmooth_mod.smoothResult = false
	),

	/**
	 */
	on create do
	(
	)
)