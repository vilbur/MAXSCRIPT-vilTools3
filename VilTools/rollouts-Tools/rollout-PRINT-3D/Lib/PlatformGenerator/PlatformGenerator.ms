filein( getFilenamePath(getSourceFileName()) + "/PlatformOptions/PlatformOptions.ms" )	-- "./PlatformOptions/PlatformOptions.ms"
filein( getFilenamePath(getSourceFileName()) + "/PlatformModifiers/PlatformModifiers.ms" )	-- "./PlatformModifiers/PlatformModifiers.ms"
filein( getFilenamePath(getSourceFileName()) + "/PlatformObject/PlatformObject.ms" )	-- "./PlatformObject/PlatformObject.ms"

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
	export_size	= 1,

	------bind_to_parent = true, -- if true then platforms are bind to parent of source objects (E.G.: Export Node), otherwise are bind to source_object

	/* options */
	use_every_nth_vert_of_spline = 1,

	/* properties */
	PlatformObjects = #(),

	mat_ids	= Dictionary #( #TOP, 1 /* READ-ONLY */ ) #( #MIDDLE, 3 ) #( #BASE, 4 ) #( #BOTTOM, 2 /* READ-ONLY */ ) #( #CHMAFER, 5 ), -- #top and #bottom are read-only and they are default by Edit Spline

	/* dependency */
	Options,	--PlatformOptions_v(),
	PlatformModifiers,	--PlatformModifiers_v(),

	/* reference */
	/* inhered */

	/** /** Generate
	  *
	  */
	function generate source_objects =
	(
		format "\n"; print "PlatformGenerator_v.generate()"
		format "source_objects:	% \n" source_objects

		/* SETUP */
		max create mode

		--DisableSceneRedraw() -- disable for development

		Options.init()

		PlatformModifiers	= PlatformModifiers_v(Options)(mat_ids)

		/* GENERATE PLATFORMS FOR EACH OBJECT */
		for source_obj in source_objects do
			this.getVertexPositions( source_obj )


		for PlatformObject in PlatformObjects do
			PlatformObject.generatePlatform()
			--format "PlatformObject:	% \n" PlatformObject

		--	this._setParentOfPlatforms()
		--
		--	this._renamePlatform()
		--)
		--
		select (this._getPlatformObjects())

		PlatformModifiers.addModifiers() -- PALTFORM OBJECT MUST BE SELECTED TO APPLY MODIFIERS
		--
		--EnableSceneRedraw()
		--
		--this.platforms --return
	),

	/** Rebuild Existing platforms
	  *
	  * Get "Editable Spline" obejcts with parent
	  *
	  */
	function rebuild platform_objects =
	(
		format "\n"; print "PlatformGenerator_v.rebuild()"

		platforms_to_rebuild	=  for obj in platform_objects where superClassOf obj.baseobject == shape and obj.parent != undefined collect obj

		source_objects = for obj in platforms_to_rebuild collect obj.parent


		delete platforms_to_rebuild

		this.generate (source_objects)
	),

	/** Get platform positions from:
	  * 	A) From point helper
	  * 	B) From Line
	  * 	C) From Mesh Object
	  */
	function getVertexPositions source_obj =
	(
		/* POINT HELPER */
		if classOf source_obj == Point then
			this._getPointHelperPositions(source_obj)

		/* LINE */
		else if superClassOf source_obj == shape then
			this._getVertexPositionsFromShape(source_obj)

		/* OBJECT */
		else
			this._getVertexPositionsFromEditablePoly(source_obj)

		--this.verts_positions --return
	),

	private


	/** Get vertex positions from editable poly
	  *
	  */
	function _getVertexPositionsFromEditablePoly source_obj =
	(
		format "\n"; print "PlatformGenerator_v._getVertexPositionsFromEditablePoly()"
		--format "classOf source_obj:	% \n" (classOf source_obj)
		--format "classOf source_obj:	% \n" (classOf source_obj.mesh)
		vertext_count	= getNumVerts source_obj.mesh
		vertext_sel  	= (getVertSelection source_obj.mesh )	as Array

		verts_to_generate = if vertext_sel.count != 0 then vertext_sel else #{1..vertext_count} as Array  -- get all verts if nothing selected

		--hidden_verts = ( polyop.getHiddenVerts source_obj.baseobject ) -- DOESN'T WORK ON NO EDITABLE POLY
		--for i = 1 to verts_to_generate.count where findItem hidden_verts verts_to_generate[i] == 0 do
		for i = 1 to verts_to_generate.count do
		(
			vertex_index = verts_to_generate[i]

			wirecolor = if (_vertex_color = getvertcolor source_obj.mesh vertex_index) != white then _vertex_color else source_obj.wirecolor

			--format "_vertex_color:	% \n" _vertex_color
			--format "\n\nvertex_index:	% \n" vertex_index

			PlatformObject = PlatformObject_v source_obj:source_obj wirecolor:wirecolor layer_height:Options.base_height mat_ids:mat_ids

			append PlatformObject.verts_positions ( polyop.getVert source_obj vertex_index)

			PlatformObject.normal = ( getnormal source_obj.mesh vertex_index) * source_obj.transform - source_obj.pos


			append PlatformObjects PlatformObject


			--append verts_positions ( polyop.getVert source_obj vertex_index)
		)

		--format "\n-----------\nARRAY:verts_positions:\n";  for pos in verts_positions do format "pos:	%\n" pos

			/* BACKUP FOR FUTURE USE -- generate line from vertex normal


				--pos += spnLength.value * normalize( normal )
			*/
	),

	/** Get vertex positions from spline
	  */
	function _getVertexPositionsFromShape source_obj =
	(
		--format "\n"; print "PlatformGenerator_v._getVertexPositionsFromShape()"
		/** Copy and collapse source spline
		  */
		function copyAndCollapseSourceObject source_obj =
		(
			nnl = #()

			maxOps.cloneNodes source_obj cloneType:#copy newNodes:&nnl

			convertTo nnl[1] SplineShape

			nnl[1] --return
		)

		/** test if vertexx index is nth vertex in spline
		  */
		function isNthVertex index =
		(
			--format "\n"; print "PlatformGenerator_v.isNthVertex"
			is_nth_vertex = index == 1 or use_every_nth_vert_of_spline == 1 or ceil (test = (index - 1)/use_every_nth_vert_of_spline as float ) == test

			is_nth_vertex --return
		)

		source_obj_copy = copyAndCollapseSourceObject(source_obj)

		for spline_i = 1 to numSplines source_obj_copy do
			for knot_i = 1 to numKnots source_obj_copy spline_i where isNthVertex (knot_i) do
				append verts_positions (getKnotPoint source_obj_copy spline_i knot_i)

		delete source_obj_copy
	),

	/** Get vertex positions from editable poly
	  *
	  */
	function _getPointHelperPositions source_obj =
	(
		fn getChildPoint parent_point = (for i = 1 to parent_point.children.count where classOf parent_point.children[i] == Point collect parent_point.children[i] ) [1]

		--	if classOf ( parent_point = source_obj ) == Point then
		--		while (child_point = getChildPoint (parent_point)) != undefined do
		--		(
		--			pos = child_point.pos
		--
		--			addKnot _shape spline_index #corner #line pos
		--
		--			parent_point = child_point
		--		)


		append verts_positions source_obj.pos

	),




	/** Get platform objects
	  *
	  */
	function _getPlatformObjects =
	(
		--format "\n"; print "PlatformGenerator_v.getPlatformObjects()"

		for PlatformObject in PlatformObjects collect PlatformObject.platform
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