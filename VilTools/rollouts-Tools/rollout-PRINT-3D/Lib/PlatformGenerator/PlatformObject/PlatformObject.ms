/** Create platform object from given data
 */
struct PlatformObject_v
(
	/* construct */
	source_obj,

	layer_height,

	mat_ids,

	/* properties */
	platform, -- save node of platform

	wirecolor, -- wirecolor of platform get from source object or vertex color

	--normal,

	/* dependency */

	/* reference */
	/* inhered */
	Options,	--PlatformOptions_v(),

	/* store */
	verts_positions = #(), -- vertex positions to generate platforms

	/** Generate platform
	  *
	  */
	function generatePlatform =
	(
		--format "\n"; print "PlatformObject_v.generatePlatform()"
		--format "this.normal:	% \n" this.normal
		--format "this.wirecolor:	% \n" this.wirecolor

		platform = SplineShape name:( source_obj.name + "-platform" ) wirecolor:wirecolor

		--format "verts_positions:	% \n" verts_positions

		this._createLineFromPoints()

		platform --return
	),

	/** Add vert pos
	  *
	  */
	function addVert pos =
	(
		--format "\n"; print "PlatformObject_v.addVertPos()"
		append this.verts_positions pos
	),

	private

	/** Create line for vertex
	  *
	  */
	function _createLineFromPoints =
	(
		--format "\n"; print "PlatformObject_v._createLineForVertex()"
		spline_index = 1

		addNewSpline platform


		/*------------------------------------------------------------------------------
			ADD KNOTS FROM TOP TO BOTTOM
		--------------------------------------------------------------------------------*/
		for pos in verts_positions do
			addKnot platform spline_index #corner #line pos


		/*------------------------------------------------------------------------------
			ABOVE GROUND POINT
		--------------------------------------------------------------------------------*/
		pos = verts_positions[verts_positions.count]

		pos.z = layer_height -- set knot above grount to set base height and keep last segment straight for extrude

		addKnot platform spline_index #corner #line pos

		pos.z = 0 -- set platform to ground


		/*------------------------------------------------------------------------------
			GROUND POINT
		--------------------------------------------------------------------------------*/
		addKnot platform spline_index #corner #line pos


		/*------ SET MATERIAL TO SEGMENTS ------*/
		num_of_segments = numSegments platform ( numSplines platform)

		for segment_i = 1 to num_of_segments do
			setMaterialID platform spline_index segment_i mat_ids[#MIDDLE] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID>

		/*------ SET MATERIAL TO BOTTOM SEGMENT ------*/

		setMaterialID platform spline_index num_of_segments mat_ids[#BASE] -- setMaterialID <splineShape> <spline_index> <seg_index> <matID>

		updateShape platform
	),


	on create do ()
)
