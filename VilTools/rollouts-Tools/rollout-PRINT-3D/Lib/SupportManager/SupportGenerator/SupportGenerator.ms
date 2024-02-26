/** Support generator
 */
struct SupportGenerator_v
(
	/* construct */
	--point_helpers,


	/* properties */
	--support_objects = #(),

	/* dependency */
	SupportModifiers,
	--SupportModifiers	= SupportModifiers_v	Options:Options,

	/* reference */
	/* inhered */
	Options,
	SupportObject,
	--SupportObject = SupportObject_v Options:Options,

	/** Create supports
	 */
	function generateSupports source_obj point_helpers =
	(
		--format "\n"; print "SupportGenerator_v.createSupports()"
		--format "point_helpers	= % \n" point_helpers


		supportObjects = for vertex_index in point_helpers.keys collect
		(
			this._deleteSupportByHelper( point_helpers[vertex_index] )

			SupportObject.generateSupport( point_helpers[vertex_index] )
		)

		--for SupportObject in supportObjects collect SupportObject.support

		/* GET ALL SUPPORTS GENERATED FOR OBJECT */
		supports_by_object = for helper_data in point_helpers where ( support = this._getSupportByHelper(helper_data.value) ) != undefined collect support


		select (supports_by_object) -- IMPORTANT - SUPPORTS OBJECT MUST BE SELECTED TO APPLY MODIFIERS

		SupportModifiers.addModifiers() -- SUPPORT OBJECT MUST BE SELECTED TO APPLY MODIFIERS
	),


	private

	/** Get support by helper
	 */
	function _deleteSupportByHelper point_helper =
	(
		--format "\n"; print "SupportGenerator_v._deleteSupportByHelper()"
		if ( support = this._getSupportByHelper(point_helper) ) != undefined then
			delete support
	),

	/** Get support by helper
	 */
	function _getSupportByHelper point_helper =
	(
		--format "\n"; print "SupportGenerator_v._getSupportByHelper()"

		children = #(point_helper)

		this._getAllChildren(point_helper) (children)

		--supports = for child_data in children where superClassOf child_data.value.baseobject == shape collect child_data.value
		supports = for child in children where superClassOf child.baseobject == shape collect child

		supports[1] --return
	),

	mapped function _getAllChildren _node &children = ( join children _node.children; if _node.children.count > 0 then this._getAllChildren _node.children &children ),

	/**
	 */
	on create do
	(
		--format "\n"; print "SupportGenerator_v.onCreate()"
		--format "Options	= % \n" Options
		SupportObject = SupportObject_v Options:Options
		SupportModifiers = SupportModifiers_v Options:Options
	)
)