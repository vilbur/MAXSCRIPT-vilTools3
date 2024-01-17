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
	PlatformObjectInstance,
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

		PlatformObjectInstance = PlatformObject_v layer_height:Options.base_height mat_ids:mat_ids


		/* GENERATE PLATFORMS FOR EACH OBJECT */
		for source_obj in source_objects do
			this.getVertexPositions( source_obj )


		for PlatformObject in PlatformObjects do
			PlatformObject.generatePlatform()


		--	this._setParentOfPlatforms()
		--
		--	this._renamePlatform()
		--)
		--
		select (this._getPlatformObjects()) -- IMPORTANT - must b selected bfore applying modifiers

		PlatformModifiers.addModifiers() -- PALTFORM OBJECT MUST BE SELECTED TO APPLY MODIFIERS

		--EnableSceneRedraw()

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

		/* EDITABLE POLY OBJECT */
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



			wirecolor = if getNumCPVVerts source_obj.mesh > 0 and  (_vertex_color = getvertcolor source_obj.mesh vertex_index) != white then _vertex_color else source_obj.wirecolor

			PlatformObject = this._getPlatformObject(source_obj)(wirecolor)

			--append PlatformObjects PlatformObject

			PlatformObject.normal = ( getnormal source_obj.mesh vertex_index) * source_obj.transform - source_obj.pos

			append PlatformObject.verts_positions ( polyop.getVert source_obj vertex_index)
		)

	),

	/** Get vertex positions from spline
	  */
	function _getVertexPositionsFromShape source_obj =
	(
		--format "\n"; print "PlatformGenerator_v._getVertexPositionsFromShape()"
		/** Copy and collapse source spline
		  */
		function copyAndCollapseSourceObject source_objects =
		(
			nnl = #()

			maxOps.cloneNodes source_objects cloneType:#copy newNodes:&nnl

			convertTo nnl SplineShape

			nnl --return
		)

		/** test if vertexx index is nth vertex in spline
		  */
		function isNthVertex index =
		(
			--format "\n"; print "PlatformGenerator_v.isNthVertex"
			is_nth_vertex = index == 1 or use_every_nth_vert_of_spline == 1 or ceil (test = (index - 1)/use_every_nth_vert_of_spline as float ) == test

			is_nth_vertex --return
		)

		source_splines = copyAndCollapseSourceObject( this._getSameChildren (source_obj) )

		/* Get platform object for each pline vertex */
		for spline_i = 1 to numSplines source_splines[1] do
			for knot_i = 1 to numKnots source_splines[1] spline_i where isNthVertex (knot_i) do
			(
				PlatformObject = this._getPlatformObject(source_obj)(source_obj.wirecolor)

				for shape_i = 1 to source_splines.count do
					PlatformObject.addVert (getKnotPoint source_splines[shape_i] spline_i knot_i)
			)


		delete source_splines
	),

	/** Get vertex positions from editable poly
	  *
	  */
	function _getPointHelperPositions source_obj =
	(
		point_helpers = this._getSameChildren (source_obj)

		PlatformObject = this._getPlatformObject(source_obj)(source_obj.wirecolor)

		for point_helper in point_helpers do
			PlatformObject.addVert (point_helper.pos)

	),

	/** Get children of given object with same class
	  */
	function _getSameChildren obj =
	(
		format "\n"; print "PlatformGenerator_v.getChildren()"

		fn getChildPoint parent_obj = (for i = 1 to parent_obj.children.count where classOf parent_obj.children[i] == classOf parent_obj collect parent_obj.children[i] ) [1]

		children = #(obj)


		if classOf ( parent_obj = obj ) == classOf obj then
			while (child_obj = getChildPoint (parent_obj)) != undefined do
			(
				append children child_obj

				parent_obj = child_obj
			)

		children --return
	),

	/** Set platform object
	  *
	  */
	function _getPlatformObject source_obj wirecolor =
	(
		--format "\n"; print "PlatformGenerator_v._getPlatformObject()"
		PlatformObject = deepCopy PlatformObjectInstance

		PlatformObject.source_obj	= source_obj
		PlatformObject.wirecolor	= wirecolor

		append PlatformObjects PlatformObject

		PlatformObject --return
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