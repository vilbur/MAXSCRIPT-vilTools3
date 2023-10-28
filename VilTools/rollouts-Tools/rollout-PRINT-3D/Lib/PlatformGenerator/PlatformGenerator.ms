
/*
 */
struct PlatformGenerator_v
(
	/* construct */
	obj, -- object to generate platforms

	single_object, --

	units_multiplier = 1,

	/* properties */
	_shape,
	platforms = #(), -- store created shapes

	estimated_time,
	command_panel_shown = cui.commandPanelOpen,

	/* options */
	bar_width 	= 1.0	* units_multiplier,
	bottom_height	= 1.0	* units_multiplier, -- height of base where
	base_extrude	= 4	* units_multiplier, -- height of base where
	extrude_top	= 0.25	* units_multiplier, -- height of base where

	chamfer_base	= bar_width / 2,
	chamfer_top	= bar_width / 4,

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

		format "verts_to_generate:	% \n" verts_to_generate

		if not this._askToContinue() then
			 return platforms

		start_time = timestamp()

		DisableSceneRedraw()

		this._toggleCommandPannel()

		this._generateLines()

		select platforms

		this._addModifiers()

		this._toggleCommandPannel()

		EnableSceneRedraw()

		redrawViews()

		format "\n"
		format "estimated_time:	% \n" estimated_time
		format "% Platforms takes: % s\n" verts_to_generate.count ( ((timestamp()) - start_time) / 1000.0 )

		format "Timer % s\n" ( ((timestamp()) - start_time) / 1000.0 )

		platforms --return
	),

	private

	/** Add modifiers
	  *
	  */
	function _addModifiers =
	(
		--format "\n"; print "PlatformGenerator_v._addModifiers()"
		this._addSweepModifier()

		this._selectFace(materials[#BASE])("Select Base")

		this._extrude(base_extrude)("Extrude Base")

		this._chamfer("Chamfer Base") ( chamfer_base )

		this._chamfer("Chamfer Middle") ( chamfer_top ) selectionoption:#ALL materialoption:#DIFFERENT

		this._selectFace(materials[#TOP])("Select Top Face")

		this._extrude(extrude_top)("Extrude Top")
	),

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

		fn wirecolor  = ( _color =  this.obj.wirecolor; _color.red += 1; _color ) -- set wirecolor slightly different then obj.wirecolor

		/** Create line for vertex
		  *
		  */
		function _createLineForVertex _shape spline_index vertex_index pos =
		(
			--format "\n"; print "PlatformGenerator_v.createLineForVertex()"
			addNewSpline _shape

			addKnot _shape spline_index #corner #line pos

			/* BACKUP FOR FUTURE USE -- generate line from vertex normal

				--normal = (getNormal obj.mesh vertex_index) * obj.transform - obj.pos

				--pos += spnLength.value * normalize( normal )
			*/

			pos.z = bottom_height

			addKnot _shape spline_index #corner #line pos

			setMaterialID _shape spline_index 1 materials[#MIDDLE] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID

			pos.z = 0

			addKnot _shape spline_index #corner #line pos

			setMaterialID _shape spline_index 2 materials[#BASE] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID

			updateShape _shape

			_shape --return
		)

		if this.single_object then
		(
			_shape = SplineShape pos:obj.pos name:( obj.name + "-platforms" ) wirecolor:(wirecolor())

			for i = 1 to verts_to_generate.count do
			(
				vertex_index = verts_to_generate[i]

				pos = (getVert obj.mesh vertex_index) * obj.transform

				_createLineForVertex (_shape) (i) (vertex_index) (pos)
			)

			append this.platforms _shape
		)
		else
			for i = 1 to verts_to_generate.count do
			(
				vertex_index = verts_to_generate[i]

				pos = (getVert obj.mesh vertex_index) * obj.transform

				_shape = SplineShape pos:pos name:( obj.name + "-platform-" + i as string ) wirecolor:(wirecolor())


				platform = _createLineForVertex (_shape) (1) (vertex_index) (pos)

				append this.platforms platform
			)

	),

	/** ifiers
	  *
	  */
	function _addSweepModifier =
	(
		--format "\n"; print "PlatformGenerator_v._addSweepModifier()"
		format "Adding Sweep\n"
		format "bar_width:	% \n" bar_width
		format "bar_width:	% \n" (bar_width / 2)

		sweep_mod = sweep()

		modPanel.addModToSelection ( sweep_mod ) --ui:on

		sweep_mod.CurrentBuiltInShape = 4 -- Set cylinder

		redrawViews() -- IMPORTANT TO UPDATE AFTER SETTING SHAPE AND BEFORE EDITING ITS PROPERTIES

		sweep_mod[#Cylinder_Section].radius = bar_width / 2

		--sweep_mod[#Bar_Section].cornerRadius = 0

		/* GENERATE MATERIAL ID */
		sweep_mod.UseSectionIDs	= false
		sweep_mod.UsePathIDs	= true

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
	function _chamfer name amount minangle: selectionoption:#STACK materialoption:#OFF =
	(
		--format "\n"; print "PlatformGenerator_v._chamfer()"
		format "Adding %\n" name

		chamfer_mod = Chamfer name:name

		chamfer_mod.selectionoption = case selectionoption of
		(
			#STACK:	0 -- from stack
			#ALL:	5 -- all edges
		)

		/* SET CHAMFER VALUES */
		chamfer_mod.amount 	 = amount

		chamfer_mod.segments = 0

		--chamfer_mod.minangle = minangle

		/* CHAMFER MATERIAL */
		chamfer_mod.materialoption = case materialoption of
		(
			#OFF:	0 -- materials off
			#DIFFERENT:	1 -- different materials
		)

		--chamfer_mod.materialoption = 0 -- materials off
		--chamfer_mod.materialoption = 1 -- different materials

		--chamfer_mod.setmaterial	= true

		--chamfer_mod.materialID	= materials[#CHMAFER]


		/* UNSMOOTH OBJECT */
		chamfer_mod.smooth 	= true

		chamfer_mod.SmoothType = 0

		chamfer_mod.smooththreshold = 0


		modPanel.addModToSelection ( chamfer_mod ) --ui:on
	),

	/** Add extrude modifier
	  *
	  */
	function _extrude amount name scale: =
	(
		--format "\n"; print "PlatformGenerator_v._extrudeBase()"
		extrude_mod = Face_Extrude name:name

		extrude_mod.amount	= amount

		--if scale != unsupplied then
			--extrude_mod.scale	= scale

		modPanel.addModToSelection ( extrude_mod ) --ui:on
	),

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

		--if verts_to_generate.count > 500 and not queryBox ( verts_to_generate.count as string +" platforms will be generated.\n\nEstimated time: "+ estimated_time as string +" s\n\n   CONTINUE ?" ) title:"PLATFORMS GENERATION"  then
		if verts_to_generate.count > 100 and not queryBox ( verts_to_generate.count as string +" platforms will be generated.\n\n  CONTINUE ?" ) title:"PLATFORMS GENERATION"  then
			 _continue =  false

		_continue --return
	),

	/**
	 */
	on create do
	(
	)
)