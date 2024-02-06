filein( getFilenamePath(getSourceFileName()) + "/PlatformOptions/PlatformOptions.ms" )	-- "./PlatformOptions/PlatformOptions.ms"
filein( getFilenamePath(getSourceFileName()) + "/PlatformModifiers/PlatformModifiers.ms" )	-- "./PlatformModifiers/PlatformModifiers.ms"
filein( getFilenamePath(getSourceFileName()) + "/PlatformObject/PlatformObject.ms" )	-- "./PlatformObject/PlatformObject.ms"
filein( getFilenamePath(getSourceFileName()) + "/PlatformCrossSection/PlatformCrossSection.ms" )	-- "./PlatformCrossSection/PlatformCrossSection.ms"
filein( getFilenamePath(getSourceFileName()) + "/EditablePolyVertexGetter/EditablePolyVertexGetter.ms" )	-- "./EditablePolyVertexGetter/EditablePolyVertexGetter.ms"

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
  *
  * PLATFORM HIERARCHY:
  * 	1) Print object
  * 		2) Point Helper ( Top of platform )
  * 			3) Cross section between plafroms
 */
struct PlatformGenerator_v
(
	/* construct */
	export_size	= 1,

	/* options */
	use_every_nth_vert_of_spline = 1,

	/* properties */
	--source_objects	 = #(),
	PlatformObjects = #(),

	/* dependency */
	Options,	--PlatformOptions_v(),
	PlatformVertInstance,
	PlatformModifiers,	--PlatformModifiers_v(),
	PlatformCrossSection,
	EditablePolyVertexGetter = EditablePolyVertexGetter_v(),

	/* reference */
	/* inhered */

	/** /** Generate
	  *
	  */
	function generate source_objects =
	(
		format "\n"; print "PlatformGenerator_v.generate()"
		--format "source_objects:	% \n" source_objects

		--this._setSourceObjects(source_objects)
		Options.init()

		/* SETUP */
		max create mode

		--DisableSceneRedraw() -- disable for development
		for source_obj in source_objects do
			this._setPlatformObjects( source_obj )

		if PlatformObjects.count > 0 then
		(
			for PlatformObject in PlatformObjects do
				PlatformObject.generatePlatform()

			platforms = this.getPlatforms()

			if this.Options.cross_section then
				PlatformCrossSection.create(platforms)

			select (platforms) -- IMPORTANT - must b selected bfore applying modifiers

			PlatformModifiers.addModifiers() -- PALTFORM OBJECT MUST BE SELECTED TO APPLY MODIFIERS

		)


		/* ADD TO LAYERS */
		for PlatformObject in PlatformObjects where PlatformObject.source_obj.parent != undefined do
			this._addToLayer (PlatformObject.source_obj.parent) (PlatformObject.platform)

		----EnableSceneRedraw()

		--this.platforms --return
	),

	/** Rebuild Existing platforms
	  *
	  * Get "Editable Spline" obejcts with parent
	  *
	  */
	function rebuild platform_objects =
	(
		--format "\n"; print "PlatformGenerator_v.rebuild()"

		platforms_to_rebuild	=  for obj in platform_objects where superClassOf obj.baseobject == shape and obj.parent != undefined collect obj

		source_objects = for obj in platforms_to_rebuild collect obj.parent


		delete platforms_to_rebuild

		this.generate (source_objects)
	),

	/** Generate instanced point helpers from selected verts
	  *
	  */
	function generatePointHelpers source_objects =
	(
		format "\n"; print "PlatformGenerator_v.generatePointHelpers()"


		--format "source_objects:	% \n" source_objects
		for source_obj in source_objects do
			this._setPlatformObjects( source_obj )

		Options.init()

		points_created	= #()

		--max create mode

		for PlatformObject in PlatformObjects collect
		(
			PlatformObject.generatePointHelper()

			EditablePolyVertexGetter.addPointHelper(PlatformObject)

			--EditablePolyVertexGetter.verts_data[PlatformObject.vertex_index][4] = PlatformObject.point_helper

			PlatformObject.point_helper
		)

	),

	/** Get platform objects
	  *
	  */
	function getPlatforms =
	(
		--format "\n"; print "PlatformGenerator_v.getPlatformObjects()"

		for PlatformObject in PlatformObjects collect PlatformObject.platform
	),


	private

	/** Add to layer
	 */
	function _addToLayer source_obj obj =
	(
		layer_name = source_obj.name + "-platforms"

		if ( layer = LayerManager.getLayerFromName (layer_name) ) == undefined then
			layer = LayerManager.newLayerFromName (layer_name)

		layer.setParent (source_obj.layer)

		layer.addNode obj
	),

	--/** Set source objects
	-- */
	--function _setSourceObjects source_objects =
	--(
	--	--format "\n"; print "PlatformGenerator_v._setSourceObjects()"
	--
	--
	--	this.source_objects = for obj in source_objects where superClassOf obj == GeometryClass or classOf source_obj == Point do
	--
	--),


	/** Get vertex positions from:
	  * 	A) From point helper
	  * 	B) From Line
	  * 	C) From Mesh Object
	  */
	function _setPlatformObjects source_obj =
	(
		/* POINT HELPER */
		if classOf source_obj == Point then
			this._getPointHelperPositions(source_obj)

		/* LINE */
		else if superClassOf source_obj == shape then
			this._getVertexPositionsFromShape(source_obj)

		/* EDITABLE POLY OBJECT */
		else
			this._getVertexPositionsFromEditblePolyObject(source_obj)


		--this.verts_positions --return
	),

	/** Get vertex positions from editble poly object
	 */
	function _getVertexPositionsFromEditblePolyObject source_obj =
	(
		--format "\n"; print "PlatformGenerator_v._getVertexPositionsFromEditblePolyObject()"
		for vert_data in (verts_data = EditablePolyVertexGetter.getVertsData(source_obj)) do
			append PlatformObjects ((PlatformObject_v	Options:Options source_obj:source_obj).fillVertData(vert_data))
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

		if source_obj.parent != undefined and classOf source_obj.parent == Point then -- do not ge child points as platform source
			return false

		point_helpers = this._getSameChildren (source_obj)

		PlatformObject = this._getPlatformObject(source_obj)(source_obj.wirecolor)


		for point_helper in point_helpers do
		(
			point_helper.showLinks = true

			PlatformObject.addVert (point_helper.pos)
		)

	),

	/** Get children of given object with same class
	  */
	function _getSameChildren obj =
	(
		--format "\n"; print "PlatformGenerator_v.getChildren()"

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
		PlatformObject = deepCopy PlatformVertInstance

		PlatformObject.source_obj	= source_obj
		PlatformObject.wirecolor	= wirecolor

		append PlatformObjects PlatformObject

		PlatformObject --return
	),


	--/** Ask to continue
	--  *
	--  */
	--function _askToContinue =
	--(
	--	--format "\n"; print "PlatformGenerator_v._askToContinue()"
	--	_continue = true
	--
	--	--if verts_to_generate.count > 500 and not queryBox ( verts_to_generate.count as string +" platforms will be generated.\n\nEstimated time: "+ estimated_time as string +" s\n\n   CONTINUE ?" ) title:"PLATFORMS GENERATION"  then
	--	if verts_to_generate.count > 100 and not queryBox ( verts_to_generate.count as string +" platforms will be generated.\n\n  CONTINUE ?" ) title:"PLATFORMS GENERATION"  then
	--		 _continue =  false
	--
	--	_continue --return
	--),

	/**
	 */
	on create do
	(
		Options	= PlatformOptions_v(export_size)

		PlatformModifiers	= PlatformModifiers_v	Options:Options
		PlatformCrossSection	= PlatformCrossSection_v	Options:Options
		--PlatformVertInstance 	= PlatformObject_v	Options:Options
		--EditablePolyVertexGetter 	= EditablePolyVertexGetter_v	normal_length:this.Options.normal_length
	)
)