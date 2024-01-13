filein( getFilenamePath(getSourceFileName()) + "/PlatformOptions/PlatformOptions.ms" )	-- "./PlatformOptions/PlatformOptions.ms"
filein( getFilenamePath(getSourceFileName()) + "/PlatformModifiers/PlatformModifiers.ms" )	-- "./PlatformModifiers/PlatformModifiers.ms"

/* Generate Platforms for 3D print
  *
  * 1) Generate from Edit Poly Object
  * 		A) from all vertices if nothing selected
  * 		B) from selected vertices selected in Editable Poly|Edit Poly| Poly Select modifier| Volume Select modifier
  *
  * 2) Generate from Editable spline
  *
  *
  * RENAME PLATFORM OBJECT:
  * 		Remove "[-_]source" from plaftorm object name E.G.: "foo-object-platform-source" >>> "foo-object-platform"
  *
 */
struct PlatformGenerator_v
(
	/* construct */
	source_obj, -- object to generate platforms

	export_size	= 1,

	bind_to_parent = false, -- if true then platforms are bind to parent of source objects (E.G.: Export Node), otherwise are bind to source_object

	/* options */
	use_every_nth_vert_of_spline = 1,

	/* properties */
	verts_positions = #(), -- vertex positions to generate platforms

	platform, -- result object
	mat_ids	= Dictionary #( #TOP, 1 /* READ-ONLY */ ) #( #MIDDLE, 3 ) #( #BOTTOM, 2 /* READ-ONLY */ ) #( #BASE, 4 ) #( #CHMAFER, 5 ), -- #top and #bottom are read-only and they are default by Edit Spline


	estimated_time,
	command_panel_shown = cui.commandPanelOpen,

	/* dependency */
	Options,	--PlatformOptions_v(),
	PlatformModifiers,	--PlatformModifiers_v(),

	/* reference */
	/* inhered */

	/** /** Generate
	  *
	  */
	function generate source_obj =
	(
		format "\n"; print "PlatformGenerator_v.generate()"
		format "source_obj:	% \n" source_obj

		this.source_obj = source_obj

		Options.init()

		PlatformModifiers	= PlatformModifiers_v(Options)(mat_ids)

		if superClassOf source_obj == shape then
			this._getVertexPositionsFromShape()

		else
			this._getVertexPositionsFromEditablePoly()



		this._generateLines()

		PlatformModifiers.addModifiers() -- PALTFORM OBJECT MUST BE SELECTED


		/* BACKUP
			--if not this._askToContinue() then
			--	 return platforms

			--DisableSceneRedraw()

			--this._toggleCommandPannel()


			--EnableSceneRedraw()
			--redrawViews()

			--format "\n"
			--format "estimated_time:	% \n" estimated_time
			--format "% Platforms takes: % s\n" verts_to_generate.count ( ((timestamp()) - start_time) / 1000.0 )
			--
			--format "Timer % s\n" ( ((timestamp()) - start_time) / 1000.0 )
		*/

		this._setParentOfPlatforms()

		this._renamePlatform()

		--for platform in platforms do
		--	platform.pivot = source_obj.pivot

		this.platform --return
	),

	private

	/** Get vertex positions from editable poly
	  *
	  */
	function _getVertexPositionsFromEditablePoly =
	(
		format "\n"; print "PlatformGenerator_v._getVertexPositionsFromEditablePoly()"
		vertext_count	= getNumVerts source_obj.mesh
		vertext_sel  	= (getVertSelection source_obj.mesh )	as Array

		verts_to_generate = if vertext_sel.count != 0 then vertext_sel else #{1..vertext_count} as Array

		--maxOps.CollapseNodeTo source_obj 1 off

		for i = 1 to verts_to_generate.count do
			append verts_positions ( polyop.getVert source_obj verts_to_generate[i])


		format "\n-----------\nARRAY:verts_positions:\n";  for pos in verts_positions do format "pos:	%\n" pos

			/* BACKUP FOR FUTURE USE -- generate line from vertex normal

				--normal = (getNormal source_obj.mesh vertex_index) * source_obj.transform - source_obj.pos

				--pos += spnLength.value * normalize( normal )
			*/
	),

	/** Get vertex positions from spline
	  */
	function _getVertexPositionsFromShape =
	(
		--format "\n"; print "PlatformGenerator_v._getVertexPositionsFromShape()"

		/** Copy and collapse source spline
		  */
		function copyAndCollapseSourceObject =
		(
			--format "\n"; print "PlatformGenerator_v.copyAndCollapseSourceObject()"
			maxOps.cloneNodes this.source_obj cloneType:#copy newNodes:&nnl

			--format "nnl[1]:	% \n" nnl[1]
			convertTo nnl[1] SplineShape

			nnl[1] --return
		)

		/** test if vertexx index is nth vertex in spline
		  *
		  */
		function isNthVertex index =
		(
			--format "\n"; print "PlatformGenerator_v.isNthVertex"
			--format "index:	% \n" index

			--use_every_nth_vert_of_spline == 1 or ceil (test = use_every_nth_vert_of_spline/index as float ) == test
			is_nth_vertex = index == 1 or use_every_nth_vert_of_spline == 1 or ceil (test = (index - 1)/use_every_nth_vert_of_spline as float ) == test
			--format "is_nth_vertex:	% \n" is_nth_vertex

			is_nth_vertex --return
			--true --return
		)

		--format "use_every_nth_vert_of_spline:	% \n" use_every_nth_vert_of_spline

		source_obj_copy = copyAndCollapseSourceObject()

		for spline_i = 1 to numSplines source_obj_copy do
			for knot_i = 1 to numKnots source_obj_copy spline_i where isNthVertex (knot_i) do
				append verts_positions (getKnotPoint source_obj_copy spline_i knot_i)

		delete source_obj_copy
	),


	/** Generate lines
	  *
	  */
	function _generateLines =
	(
		--format "\n"; print "PlatformGenerator_v._generateLines()"

		fn wirecolor  = ( _color =  this.source_obj.wirecolor; _color.red += 1; _color ) -- set wirecolor slightly different then source_obj.wirecolor

		/** Create line for vertex
		  *
		  */
		function _createLineForVertex _shape spline_index pos =
		(
			--format "\n"; print "PlatformGenerator_v.createLineForVertex()"
			addNewSpline _shape

			addKnot _shape spline_index #corner #line pos

			pos.z = this.Options.base_height -- set knot above grount to set base height and keep last segment straight for extrude

			addKnot _shape spline_index #corner #line pos

			setMaterialID _shape spline_index 1 mat_ids[#MIDDLE] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID

			pos.z = 0 -- set platform to ground

			addKnot _shape spline_index #corner #line pos

			setMaterialID _shape spline_index 2 mat_ids[#BASE] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID

			updateShape _shape

			_shape --return
		)

		--this.platform = SplineShape pos:source_obj.pos name:( source_obj.name + "-platforms" ) wirecolor:(wirecolor()) isSelected:on
		this.platform = SplineShape name:( source_obj.name + "-platforms" ) wirecolor:(wirecolor()) isSelected:on


		for i = 1 to verts_positions.count do
			_createLineForVertex (platform) (i) (verts_positions[i])



	),

	/** Set parent of platforms
	  *
	  */
	function _setParentOfPlatforms =
	(
		format "\n"; print "PlatformGenerator_v._setParentOfPlatforms()"
		if bind_to_parent and this.source_obj.parent != undefined then
			this.platform.parent = this.source_obj.parent

		else
			this.platform.parent = this.source_obj

		--format "this.platform.parent:	% \n" this.platform.parent
	),

	/** Platform name is same as source name
	  *
	  * word "source" with prefix is removed
	  */
	function _renamePlatform =
	(
		--format "\n"; print "PlatformGenerator_v._renamePlatform()"
		/** Regex replace
		  */
		function rxReplace _string _search _replace ignore_case:true =
		(
			IgnoreCase = ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase

			RegExReplace = if ignore_case then ( dotNetObject "System.Text.RegularExpressions.Regex" _search IgnoreCase ) else ( dotNetObject "System.Text.RegularExpressions.Regex" _search )

			RegExReplace.Replace _string _replace
		)

		this.platform.name = rxReplace(this.source_obj.name)("[-_\s]+source")("")
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
		Options	= PlatformOptions_v(export_size)

	)
)