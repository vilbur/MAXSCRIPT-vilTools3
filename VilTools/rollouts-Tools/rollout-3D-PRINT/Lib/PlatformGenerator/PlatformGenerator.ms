
/*
 */
struct PlatformGenerator_v
(
	/* construct */
	obj, -- object to generate platforms

	/* properties */
	_shape,

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

		this._addModifiers()

		--this._setSplineMesh()

		updateShape _shape

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
		vertext_sel  	= getVertSelection obj.mesh

		fn makeLine obj _shape ind =
		(
			addNewSpline _shape

			splines_count = _shape.numSplines

			pos = (getVert obj.mesh ind) * obj.transform

			addKnot _shape splines_count #corner #line pos

			--normal = (getNormal obj.mesh ind) * obj.transform - obj.pos

			--pos += spnLength.value * normalize( normal )

			pos.z = 0

			format "pos:	% \n" pos

			addKnot _shape splines_count #corner #line pos
		)

		--if chkVertSel.checked and ( vertext_sel as Array ).count != 0 then
			for i in vertext_sel do
				makeLine obj _shape i

		--else
			--for i = 1 to vertext_count do
				--makeLine obj _shape i

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
	function _addModifiers =
	(
		--format "\n"; print "PlatformGenerator_v._addModifiers()"

		sweep_mod = sweep()

		addModifier _shape sweep_mod

		--_shape.modifiers[#Sweep].CurrentBuiltInShape = 4 -- cylinder shape
		--_shape.modifiers[#Sweep].CurrentBuiltInShape = 3 -- cylinder shape


		--_shape.modifiers[#Sweep][#Cylinder_Section].radius = 5.0


		--when parameters obj change id:#paramChange handleAt:#redrawViews do
		--(
		--	sweep_mod[4].radius = 5
		--	deleteAllChangeHandlers id:#paramChange
		--)

		sweep_mod.currentbuiltinshape = 4

		redrawViews()

		sweep_mod[#Cylinder_Section].radius = 5.0

	),


	/**
	 */
	on create do
	(
		--format "\n"; print "PlatformGenerator.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

	)
)
