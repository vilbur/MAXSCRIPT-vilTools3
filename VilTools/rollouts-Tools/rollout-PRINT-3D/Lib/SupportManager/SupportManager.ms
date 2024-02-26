

/** Support manager
 */
struct SupportManager_v
(
	/* construct */
	export_size,

	/* properties */
	point_helpers_by_object,

	/* dependency */
	Options,
	HelperGenerator,
	SupportGenerator,

	/* reference */
	/* inhered */

	/** Generate instanced point helpers from selected verts
	  *
	  */
	function generatePointHelpers source_objects reset_helpers:true =
	(
		format "\n"; print "PlatformGenerator_v.generatePointHelpers()"
		Options.init()

		/* DEBUG */
		for point_helpers_per_obj in point_helpers_by_object do
			for point_helper_per_obj in point_helpers_per_obj.value do
			format "point_helper_per_obj	= % \n" point_helper_per_obj
			--format "point_helpers_by_object	= % \n" point_helpers_by_object

		point_helpers_by_object = for source_obj in source_objects collect
			HelperGenerator.generatePointHelpers(source_obj)(this._getHelperByObject source_obj) reset_helpers:reset_helpers

		#()--dev
		--for point_created in points_created where point_created != undefined collect point_created  -- return created points
	),


	/** Create supports
	 */
	function createSupports source_objects =
	(
		format "\n"; print "SupportManager_v.createSupports()"
		format "this.point_helpers_by_object	= % \n" this.point_helpers_by_object
		Options.init()

		for source_obj in source_objects do
			SupportGenerator.generateSupports (source_obj) (this._getHelperByObject(source_obj))
	),


	private

	/** Get helper by object
	 */
	function _getHelperByObject source_obj =
	(
		--format "\n"; print "SupportManager_v._getHelperByObject()"
		point_helpers_by_object[(getHandleByAnim source_obj) as string ]
	),

	/** Get point helper
	 */
	function _setPointHelpers =
	(
		format "\n"; print "SupportManager_v.getPointHelper()"
		this.point_helpers_by_object	= Dictionary #string

		--for _helper in point_helpers_by_object
		for _helper in helpers where classOf _helper == Point and (helper_source = getUserPropVal _helper "helper_source"  asString:true ) != undefined do
			if getUserPropVal _helper "this_pointer"  == getHandleByAnim _helper then -- test if helper is original node, prevent duplicated helpers
			(
				vertex_index = getUserPropVal _helper "source_vert"

				if point_helpers_by_object[helper_source] == undefined then
					point_helpers_by_object[helper_source] = Dictionary #integer

				point_helpers_by_object[helper_source][vertex_index] = _helper
			)
	),

	/**
	 */
	on create do
	(

		Options	= SupportOptions_v(export_size)

		HelperGenerator	= HelperGenerator_v	Options:Options
		SupportGenerator	= SupportGenerator_v	Options:Options
		--SupportModifiers	= SupportModifiers_v	Options:Options
		--SupportCrossSection	= SupportCrossSection_v	Options:Options
		--SupportObjectInstance 	= SupportObject_v	Options:Options

		this._setPointHelpers()
	)

)
