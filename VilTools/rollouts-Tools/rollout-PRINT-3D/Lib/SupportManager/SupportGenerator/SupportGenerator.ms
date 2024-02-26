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
		format "\n"; print "SupportGenerator_v.createSupports()"
		format "point_helpers	= % \n" point_helpers


		supportObjects = for vertex_index in point_helpers.keys collect
		(
			this._deleteSupportByHelper( point_helpers[vertex_index] )

			SupportObject.generateSupport( point_helpers[vertex_index] )
		)


		supports = for SupportObject in supportObjects collect SupportObject.support

		format "supports	= % \n" supports
		format "SUPPORTS.COUNT	= % \n" supports.count

		select (supports) -- IMPORTANT - must b selected bfore applying modifiers

		SupportModifiers.addModifiers() -- PALTFORM OBJECT MUST BE SELECTED TO APPLY MODIFIERS
	),


	private

	/** Get support by helper
	 */
	function _deleteSupportByHelper point_helper =
	(
		--format "\n"; print "SupportGenerator_v._deleteSupportByHelper()"

		--format "\n"; print "HelperGenerator_v.getPointTrees()"
		--children = #()

		--if isValidNode point_helper then
		--(
		children = #(point_helper)

		this._getAllChildren(point_helper) (children)
		--)

		for child in children where superClassOf child.baseobject == shape do
			delete child


		children --return
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
