
/*
 */
struct PlatformGenerator_v
(
	/* construct */
	obj, -- object to generate platforms

	/* properties */
	_shape,
	_shapes = #(), -- store created shapes
	estimated_time,
	command_panel_shown = cui.commandPanelOpen,

	/* options */
	bar_width = 10,

	bottom_layers_height = 4, -- height of base where


	extrude_bottom	= 2, -- height of base where
	extrude_top	= 2, -- height of base where

	materials	= Dictionary #( #TOP, 1 /* READ-ONLY */ ) #( #MIDDLE, 3 ) #( #BOTTOM, 2 /* READ-ONLY */ ) #( #BASE, 4 ) #( #CHMAFER, 5 ), -- #top and #bottom are read-only and they are default by Edit Spline

	verts_to_generate, -- just for timer

	/* dependency */
	/* reference */
	/* inhered */

	/** /** Generate
	  *
	  */
	function generate =
	(
		--format "\n"; print "PlatformGenerator_v.generate()"
		--format "obj:	% \n" obj
		this._getVertexToGenerate()

		if not this._askToContinue() then
			 return false

		start_time = timestamp()

		DisableSceneRedraw()

		this._toggleCommandPannel()

		this._generateLines()

		select _shapes

		this._addSweepModifier()

		/* BOTTOM OF PLATFORM */
		this._selectFace(materials[#BASE])("Select Base")

		this._taperBase()

		this._ffdBase()

		this._chamfer("Chamfer Bottom")

		/* TOP OF PLATFORM */
		this._selectFace(materials[#TOP])("Select Top Face")

		this._chamfer("Chamfer Top")

		this._selectFace(materials[#TOP])("Select Top Face")

		this._extrude(extrude_top)(100)("Extrude Top")

		this._addMeshmooth( 3 )

		this._toggleCommandPannel()

		EnableSceneRedraw()

		format "estimated_time:	% \n" estimated_time
		format "% Platforms takes: % s\n" verts_to_generate.count ( ((timestamp()) - start_time) / 1000.0 )

		_shapes --return
	),

	private

	/** Get vertex to generate
	  *
	  */
	function _getVertexToGenerate =
	(
		--format "\n"; print "PlatformGenerator_v._getVertexToGenerate()"
		vertext_count	= getNumVerts obj.mesh
		vertext_sel  	= (getVertSelection obj.mesh )	as Array

		format "vertext_count:	% \n" vertext_count
		format "vertext_sel:	% \n" vertext_sel
		verts_to_generate = if vertext_sel.count != 0 then vertext_sel else #{1..vertext_count} as Array

	),

	/** Generate lines
	  *
	  */
	function _generateLines =
	(

		/** Create line for vertex
		  *
		  */
		function _createLineForVertex vertex_index =
		(
			--format "\n"; print "PlatformGenerator_v.createLineForVertex()"
			pos = (getVert obj.mesh vertex_index) * obj.transform

			fn wirecolor  = ( _color =  this.obj.wirecolor; _color.red += 1; _color ) -- set wirecolor slightly different then obj.wirecolor

			_shape = SplineShape pos:pos name:( obj.name + "-platform-" + vertex_index as string ) wirecolor:(wirecolor())

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
		)

		--format "\n"; print "PlatformGenerator_v.generateLines()"
		--_shape      	= SplineShape pos:obj.pos name:(obj.name + "-platform") wirecolor:green
		for i = 1 to verts_to_generate.count do
			append this._shapes (_createLineForVertex (verts_to_generate[i]))
	),

	/** Add modifiers
	  *
	  */
	function _addSweepModifier =
	(
		--format "\n"; print "PlatformGenerator_v._addSweepModifier()"
		format "Adding Sweep\n"

		sweep_mod = sweep()

		modPanel.addModToSelection ( sweep_mod ) --ui:on

		sweep_mod.CurrentBuiltInShape = 2

		redrawViews() -- IMPORTANT TO UPDATE AFTER SETTING SHAPE AND BEFORE EDITING ITS PROPERTIES

		sweep_mod[#Bar_Section].length	= bar_width
		sweep_mod[#Bar_Section].width 	= bar_width

		sweep_mod[#Bar_Section].cornerRadius = 0

		/* GENERATE MATERIAL ID */
		sweep_mod.UseSectionIDs = false
		sweep_mod.UsePathIDs = true

	),

	/** Add select modifier
	  *
	  */
	function _selectFace mat_id name =
	(
		--format "\n"; print "PlatformGenerator_v._selectFace()"
		format "Adding Volume Select\n"

		volume_sel_mod = Vol__Select name:name

		volume_sel_mod.level	= 2	-- select face
		volume_sel_mod.volume	= 5	-- select by material ID
		volume_sel_mod.matID	= mat_id	-- select face by mat ID

		modPanel.addModToSelection ( volume_sel_mod ) --ui:on
	),

	/** Chamfer
	  *
	  */
	function _chamfer name =
	(
		--format "\n"; print "PlatformGenerator_v._chamfer()"
		format "Adding Chamfer\n"

		chamfer_mod = Chamfer name:name

		--chamfer_mod.amountType = 0
		chamfer_mod.amount 	 = ( bar_width / 3 ) as integer
		chamfer_mod.segments = 0

		chamfer_mod.materialoption = 1 -- different materials

		chamfer_mod.setmaterial	= true
		chamfer_mod.materialID	= materials[#CHMAFER]

		modPanel.addModToSelection ( chamfer_mod ) --ui:on
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

		modPanel.addModToSelection ( extrude_mod ) --ui:on
	),

	/** Taper base for each object individualy
	  * 	IMPORTANT:Every line MUST has its own gizmo
	  *
	  */
	function _taperBase =
	(
		--format "\n"; print "PlatformGenerator_v._taperBase()"
		taper_mod = Taper ()

		taper_mod.name = "Taper Base"

		taper_mod.amount = -5

		taper_mod.limit = true

		taper_mod.lowerlimit = -5

		select _shapes[1]

		modPanel.addModToSelection ( taper_mod ) --ui:on -- method addModifier() not work properly, it assign gizmo to whole object

		taper_mod_applied = _shapes[1].modifiers[#Taper_Base]

		adding_taper_timer = timestamp()

		for i = 2 to _shapes.count do
		(
			format "Adding Taper: % of % \n" i _shapes.count

			select _shapes[i]

			modPanel.addModToSelection ( taper_mod_applied ) --ui:on -- method addModifier() not work properly, it assign gizmo to whole object
		)

		format "\n\nAdding Taper Timer % s\n\n" ( ((timestamp()) - adding_taper_timer) / 1000.0 )

		select _shapes
	),

	/** Ffd base
	  *
	  */
	function _ffdBase =
	(
		--format "\n"; print "PlatformGenerator_v._ffdBase()"
		format "Adding FFD\n"

		addModifier _shape (FFD_2x2x2 name: "FFD Base Position")
	),

	/** Add meshmooth
	  *
	  */
	function _addMeshmooth iterations =
	(
		--format "\n"; print "PlatformGenerator_v._addMeshmooth()"
		format "Adding Meshsmooth\n"

		meshsmooth_mod = meshsmooth()

		--meshsmooth_mod.sepBySmGroups = of
		meshsmooth_mod.sepByMats	= true
		meshsmooth_mod.iterations	= iterations

		meshsmooth_mod.smoothResult = false

		modPanel.addModToSelection ( meshsmooth_mod ) --ui:on

	),


	--/** Set spline mesh
	--  *
	--  */
	--function _setSplineMesh =
	--(
	--	--format "\n"; print "PlatformGenerator_v._setSplineMesh()"
	--	--format "_shape:	% \n" _shape
	--
	--	_shape.render_displayRenderMesh  = true -- show in viewport
	--	--_shape.render_viewport_thickness   	= 5
	--	--_shape.render_viewport_sides  	= 32
	--),

	/** Toggle command pannel
	  */
	function _toggleCommandPannel =
	(
		--format "\n"; print "PlatformGenerator_v.showCommandPannel()"
		if command_panel_shown then
			max hide command panel toggle
	),

	/** Ask to continue
	  *
	  */
	function _askToContinue =
	(
		--format "\n"; print "PlatformGenerator_v._askToContinue()"
		_continue = true

		--adding_taper	= (verts_to_generate.count * 0.1667) as integer
		adding_taper	= (verts_to_generate.count * 0.185 ) as integer
		format "Estimated adding taper:	% \n" adding_taper
		adding_modifiers	= (verts_to_generate.count * 0.085 ) as integer
		format "Estimated adding modifiers:	% \n" adding_modifiers

		estimated_time = adding_taper + adding_modifiers

		format "Estimated time:	% s \n" estimated_time

		if verts_to_generate.count > 10 and not queryBox ( verts_to_generate.count as string +" platforms will be generated.\n\nEstimated time: "+ estimated_time as string +" s\n\n\tCONTINUE ?" ) title:"PLATFORMS GENERATION"  then
			 _continue =  false

		_continue --return
	),

	/**
	 */
	on create do
	(
	)
)