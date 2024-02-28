/** Support generator
 */
struct SupportGenerator_v
(
	/* construct */
	--point_helpers,

	/* properties */
	--support_objects = #(),

	/* dependency */
	--SupportModifiers	= SupportModifiers_v	Options:Options,

	/* reference */
	/* inhered */
	Options,
	SupportObject,
	--SupportObject = SupportObject_v Options:Options,

	/** Create supports
	  *
	  *
	  *
	 */
	function generateSupports point_helpers =
	(
		format "\n"; print "SupportGenerator_v.createSupports()"
		--format "point_helpers	= % \n" point_helpers
		format "point_helpers	= % \n" point_helpers
		format "(classOf point_helpers)	= % \n" (classOf point_helpers)

		supports_created = for vertex_index in sort point_helpers.keys collect
		(
			format "vertex_index	= % \n" vertex_index
			this._deleteSupportByHelper( point_helpers[vertex_index] )

			support = SupportObject.generateSupport( point_helpers[vertex_index] )

			this._saveUserData (point_helpers[vertex_index]) (support)

			support --return
		)

		--for SupportObject in supportObjects collect SupportObject.support

		/* GET ALL SUPPORTS GENERATED FOR OBJECT */
		--supports_by_object = for helper_data in point_helpers where ( support = this._getSupportByHelper(helper_data.value) ) != undefined collect support

		supports_created --return
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

	/**
	 */
	function _saveUserData point_helper support =
	(
		--format "\n"; print "HelperObject_v.saveUserData()"
		Options.setProp support #pointer_sync ( Options.getProp point_helper #pointer_sync )
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
	)
)