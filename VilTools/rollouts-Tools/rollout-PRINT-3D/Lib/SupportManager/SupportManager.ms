

/** Support manager
 */
struct SupportManager_v
(
	/* construct */
	export_size,

	/* properties */
	point_helpers_all,

	/* dependency */
	Options,
	HelperGenerator,

	/* reference */
	/* inhered */

	/** Generate instanced point helpers from selected verts
	  *
	  */
	function generatePointHelpers source_objects =
	(
		format "\n"; print "PlatformGenerator_v.generatePointHelpers()"

		this._setPointHelpers()

		format "this.point_helpers_all	= % \n" this.point_helpers_all

		point_helpers = for source_obj in source_objects collect
		(
			obj_point_helpers = this._getPointHelpersByObject(source_obj)

			HelperGenerator.generatePointHelpers(source_obj)( obj_point_helpers )
		)

		#()--dev
		--for point_created in points_created where point_created != undefined collect point_created  -- return created points
	),


	/** Create supports
	 */
	function createSupports source_objects =
	(
		format "\n"; print "SupportManager_v.createSupports()"
		format "this.point_helpers_all	= % \n" this.point_helpers_all

		for source_obj in source_objects do
			(SupportGenerator_v( this._getPointHelpersByObject(source_obj) )).createSupports()
	),


	private

	/** Find point helpers
	 */
	function _setPointHelpers =
	(
		format "\n"; print "SupportManager_v.findPointHelpers()"
		--_objects = if selection > 0 then selection as Array else helpers

		this.point_helpers_all = for _helper in helpers where classOf _helper == Point and getUserPropVal _helper "helper_source" != undefined collect _helper
	),


	/** Get point helper
	 */
	function _getPointHelpersByObject source_obj =
	(
		format "\n"; print "SupportManager_v.getPointHelper()"

		point_helpers	= Dictionary #integer

		for _helper in point_helpers_all
			where getUserPropVal _helper "helper_source" == getHandleByAnim source_obj \
			and  getUserPropVal _helper "this_pointer"  == getHandleByAnim _helper \
			do
				point_helpers[getUserPropVal _helper "source_vert"] = _helper

		point_helpers --return
	),

	/**
	 */
	on create do
	(
		Options	= SupportOptions_v(export_size)

		HelperGenerator	= HelperGenerator_v	Options:Options
		--SupportModifiers	= SupportModifiers_v	Options:Options
		--SupportCrossSection	= SupportCrossSection_v	Options:Options
		--SupportObjectInstance 	= SupportObject_v	Options:Options
	)

)
