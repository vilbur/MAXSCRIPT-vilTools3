filein( getFilenamePath(getSourceFileName()) + "/PlatformOptions/PlatformOptions.ms" )	-- "./PlatformOptions/PlatformOptions.ms"
filein( getFilenamePath(getSourceFileName()) + "/PlatformModifiers/PlatformModifiers.ms" )	-- "./PlatformModifiers/PlatformModifiers.ms"

/* Generate Platforms for 3D print from given Edit Poly Object or Line
 */
struct PlatformGenerator_v
(
	/* construct */
	obj, -- object to generate platforms

	/* options */

	/* properties */
	verts_to_generate, -- just for timer
	platform, -- result object
	mat_ids	= Dictionary #( #TOP, 1 /* READ-ONLY */ ) #( #MIDDLE, 3 ) #( #BOTTOM, 2 /* READ-ONLY */ ) #( #BASE, 4 ) #( #CHMAFER, 5 ), -- #top and #bottom are read-only and they are default by Edit Spline



	estimated_time,
	command_panel_shown = cui.commandPanelOpen,

	/* dependency */
	Options	= PlatformOptions_v(),
	PlatformModifiers 	= PlatformModifiers_v(Options)(mat_ids),

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

		--if not this._askToContinue() then
		--	 return platforms

		--start_time = timestamp()

		--DisableSceneRedraw()

		--this._toggleCommandPannel()

		this._generateLines()

		PlatformModifiers.addModifiers()

		--this._toggleCommandPannel()
		--
		--EnableSceneRedraw()
		--
		--redrawViews()
		--
		--format "\n"
		--format "estimated_time:	% \n" estimated_time
		--format "% Platforms takes: % s\n" verts_to_generate.count ( ((timestamp()) - start_time) / 1000.0 )
		--
		--format "Timer % s\n" ( ((timestamp()) - start_time) / 1000.0 )
		--
		--for platform in platforms do
		--	platform.pivot = obj.pivot

		this.platform --return
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

			pos.z = this.Options.base_height

			addKnot _shape spline_index #corner #line pos

			setMaterialID _shape spline_index 1 mat_ids[#MIDDLE] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID

			pos.z = 0

			addKnot _shape spline_index #corner #line pos

			setMaterialID _shape spline_index 2 mat_ids[#BASE] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID

			updateShape _shape

			_shape --return
		)


		this.platform = SplineShape pos:obj.pos name:( obj.name + "-platforms" ) wirecolor:(wirecolor()) isSelected:on

		for i = 1 to verts_to_generate.count do
		(
			vertex_index = verts_to_generate[i]

			pos = (getVert obj.mesh vertex_index) * obj.transform

			_createLineForVertex (platform) (i) (vertex_index) (pos)
		)

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