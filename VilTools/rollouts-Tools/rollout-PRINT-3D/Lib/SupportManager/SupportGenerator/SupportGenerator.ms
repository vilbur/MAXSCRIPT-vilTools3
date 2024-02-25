/** Support generator
 */
struct SupportGenerator_v
(
	/* construct */
	--point_helpers,


	/* properties */
	support_objects = #(),

	/* dependency */
	/* reference */
	/* inhered */
	Options,
	SupportObject,

	/** Create supports
	 */
	function generateSupports source_obj point_helpers =
	(
		format "\n"; print "SupportGenerator_v.createSupports()"
		format "point_helpers	= % \n" point_helpers

		support_objects = for vertex_index in point_helpers.keys collect
			append support_objects ( SupportObject.generateSupport( point_helpers[vertex_index] ) )
	),


	private


	/**
	 */
	on create do
	(
		format "\n"; print "SupportGenerator_v.onCreate()"
		format "Options	= % \n" Options
		SupportObject = SupportObject_v Options:Options
	)

)
