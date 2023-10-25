
/*
 */
struct PlatformGenerator_v
(
	/* construct */
	obj, -- object to generate platforms

	/* properties */
	_shape,
	_shapes = #(), -- store created shapes

	/* options */
	bar_width = 10,

	bottom_layers_height = 4, -- height of base where


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

		DisableSceneRedraw()

		this._generateLines()

		select _shapes

		this._addSweepModifier()

		/* EXTREUDE BOTTOM */
		this._selectFace(materials[#BASE])("Select Base")

		--this._extrude(extrude_bottom)(500)("Extrude Base")

		this._taperBase()

		this._ffdBase()

		this._chamfer("Chamfer Bottom")

		/* EXTREUDE TOP */
		this._selectFace(materials[#TOP])("Select Top Face")

		this._chamfer("Chamfer Top")

		this._selectFace(materials[#TOP])("Select Top Face")

		this._extrude(extrude_top)(100)("Extrude Top")

		this._addMeshmooth( 3 )

		EnableSceneRedraw()

		--CompleteRedraw()

		_shapes --return
	),

	private

	/** Generate lines
	  *
	  */
	function _generateLines =
	(
		format "\n"; print "PlatformGenerator_v.generateLines()"
		--_shape      	= SplineShape pos:obj.pos name:(obj.name + "-platform") wirecolor:green
		vertext_count	= getNumVerts obj.mesh
		vertext_sel  	= (getVertSelection obj.mesh )	as Array

		verts_to_generate = if vertext_sel.count != 0 then vertext_sel else #{1..vertext_count} as Array

		for i = 1 to verts_to_generate.count do
			append this._shapes (this._createLineForVertex (verts_to_generate[i]))
	),

	/** Create line for vertex
	  *
	  */
	function _createLineForVertex vertex_index =
	(
		--format "\n"; print "PlatformGenerator_v.createLineForVertex()"
		pos = (getVert obj.mesh vertex_index) * obj.transform

		fn wirecolor  = ( _color =  this.obj.wirecolor; _color.red += 1; _color ) -- set wirecolor slightly different then obj.wirecolor

		_shape = SplineShape pos:pos name:( obj.name + "-platform-" + i as string ) wirecolor:(wirecolor())

		addNewSpline _shape

		addKnot _shape 1 #corner #line pos

		/* BACKUP FOR FUTURE USE -- generate line from vertex normal

			--normal = (getNormal obj.mesh vertex_index) * obj.transform - obj.pos

			--pos += spnLength.value * normalize( normal )
		*/

		pos.z = bottom_layers_height

		addKnot _shape 1 #corner #line pos

		setMaterialID _shape 1 1 materials[#MIDDLE] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID

		pos.z = 0

		addKnot _shape 1 #corner #line pos

		setMaterialID _shape 1 2 materials[#BASE] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID

		updateShape _shape

		_shape --return
	),


	/** Add modifiers
	  *
	  */
	function _addSweepModifier =
	(
		--format "\n"; print "PlatformGenerator_v._addSweepModifier()"
		sweep_mod = sweep()

		modPanel.addModToSelection ( sweep_mod ) ui:on

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

		modPanel.addModToSelection ( volume_sel_mod ) ui:on
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

		chamfer_mod.materialoption = 1 -- different materials

		chamfer_mod.setmaterial	= true
		chamfer_mod.materialID	= materials[#CHMAFER]

		modPanel.addModToSelection ( chamfer_mod ) ui:on

	),


	/** Add extrude modifier
	  *
	  */
	function _extrude amount _scale name =
	(
		--format "\n"; print "PlatformGenerator_v._extrudeBase()"
		extrude_mod = Face_Extrude name:name

		extrude_mod.amount	= amount

		extrude_mod.scale	= _scale

		modPanel.addModToSelection ( extrude_mod ) ui:on
	),

	/** Taper base for each object individualy
	  *
	  * Every line MUST has its own gizmo
	  */
	function _taperBase =
	(
		--format "\n"; print "PlatformGenerator_v._taperBase()"

		for _shape in this._shapes do
		(
			select _shape

			taper_mod = Taper ()

			taper_mod.name = "Taper Base"

			taper_mod.amount = -5

			taper_mod.limit = on

			taper_mod.lowerlimit = -5

			modPanel.addModToSelection ( taper_mod ) ui:on -- method addModifier() not work properly, it assign gizmo to whole object

		)

		select _shapes

	),

	/** Ffd base
	  *
	  */
	function _ffdBase =
	(
		--format "\n"; print "PlatformGenerator_v._ffdBase()"
		addModifier _shape (FFD_2x2x2 name: "FFD Base Position")
	),

	/** Add meshmooth
	  *
	  */
	function _addMeshmooth iterations =
	(
		--format "\n"; print "PlatformGenerator_v._addMeshmooth()"
		meshsmooth_mod = meshsmooth()

		--meshsmooth_mod.sepBySmGroups = of
		meshsmooth_mod.sepByMats	= true
		meshsmooth_mod.iterations	= iterations

		meshsmooth_mod.smoothResult = false

		modPanel.addModToSelection ( meshsmooth_mod ) ui:on

	),


	--/** Set spline mesh
	--  *
	--  */
	--function _setSplineMesh =
	--(
	--	format "\n"; print "PlatformGenerator_v._setSplineMesh()"
	--	format "_shape:	% \n" _shape
	--
	--	_shape.render_displayRenderMesh  = true -- show in viewport
	--	--_shape.render_viewport_thickness   	= 5
	--	--_shape.render_viewport_sides  	= 32
	--),

	/**
	 */
	on create do
	(
	)
)