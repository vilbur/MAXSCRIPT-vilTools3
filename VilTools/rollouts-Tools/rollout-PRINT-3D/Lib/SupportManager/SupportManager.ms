

/** Support manager
 */
struct SupportManager_v
(
	/* construct */
	export_size,

	/* properties */
	point_helpers_by_objects, -- 2DMATRIX of Dictionary #( "source_object_pionter", Dictionary #( integer:vertex_index, node:PointHelper   )   )

	/* dependency */
	Options,
	HelperGenerator,
	SupportGenerator,
	SupportModifiers,

	/* reference */
	/* inhered */

	/** Generate instanced point helpers from selected verts
	  *
	  */
	function generatePointHelpers source_objects reset_helpers:true =
	(
		--format "\n"; print "PlatformGenerator_v.generatePointHelpers()"
		Options.init()

		this._setPointHelpersByObject()

		--/* DEBUG */
		--for point_helpers_per_obj in point_helpers_by_objects do
		--	for point_helper_per_obj in point_helpers_per_obj.value do
		--	--format "point_helper_per_obj	= % \n" point_helper_per_obj
		--	--format "point_helpers_by_objects	= % \n" point_helpers_by_objects

		point_helpers_by_objects = for source_obj in source_objects collect
			HelperGenerator.generatePointHelpers(source_obj)(this._getHelperByObject source_obj) reset_helpers:reset_helpers

		for point_created in points_created where point_created != undefined collect point_created  -- return created points
	),


	/** Create supports
	 */
	function createSupports source_objects raft_mode:false =
	(
		--format "\n"; print "SupportManager_v.createSupports()"
		--format "this.point_helpers_by_objects	= % \n" this.point_helpers_by_objects
		Options.init()
		--format "\n\n----------------------------\n\n"
		supports_by_objects = #()

		SupportModifiers.raft_mode = raft_mode

		this._setPointHelpersByObject()

		for source_helpers in this._getSourceHelpers(source_objects) do
			append supports_by_objects (SupportGenerator.generateSupports(source_helpers))

		/* IMPORTANT - SUPPORTS OBJECT MUST BE SELECTED TO APPLY MODIFIERS */
		clearSelection()
		for supports_by_object in supports_by_objects do
			selectmore (supports_by_object)

		SupportModifiers.addModifiers() -- SUPPORT OBJECT MUST BE SELECTED TO APPLY MODIFIERS
	),


	private

	/** Get helper by object
	 */
	function _getHelperByObject source_obj =
	(
		--format "\n"; print "SupportManager_v._getHelperByObject()"
		if ( pointer_sync = this._getOriginPoiter(source_obj) ) != undefined then
			point_helpers_by_objects[pointer_sync]
	),

	/** Get point helper
	 */
	function _setPointHelpersByObject =
	(
		--format "\n"; print "SupportManager_v._setPointHelpersByObject()"
		this.point_helpers_by_objects	= Dictionary #string

		--for _helper in point_helpers_by_objects
		for _helper in helpers where classOf _helper == Point and ( source_obj_pointer = getUserPropVal _helper "pointer_sync"  asString:true ) != undefined do
			if getUserPropVal _helper "this_pointer"  == getHandleByAnim _helper then -- test if helper is original node, prevent duplicated helpers
			(
				vertex_index = getUserPropVal _helper "source_vert"

				if point_helpers_by_objects[source_obj_pointer] == undefined then
					point_helpers_by_objects[source_obj_pointer] = Dictionary #integer

				point_helpers_by_objects[source_obj_pointer][vertex_index] = _helper
			)

		--for POINT_HELPERS_BY_OBJECT in POINT_HELPERS_BY_OBJECTS do
			--format "POINT_HELPERS_BY_OBJECT	= % \n" point_helpers_by_objects
	),

	/** Get source objects
	  *
	  * @return 2Dmatrix #( Dictionary )
	 */
	function _getSourceHelpers source_objects =
	(
		--format "\n"; print "SupportManager_v._getSourceObjects()"

		source_helpers	= #()
		source_points_used	= Dictionary #string

		/* GET POINT HELPERS FROM SOURCE OBJECTS */
		source_points	= for obj in source_objects where classOf obj == Point collect obj

		/* GET OBEJCTS WITH POINT HELPERS FROM SOURCE OBJECTS */
		source_objs	= for obj in source_objects where classOf obj != Point and this._getOriginPoiter(obj) != undefined collect obj


		--format "source_points	= % \n" source_points
		--format "source_objs	= % \n" source_objs

		--for point_helpers_by_object in point_helpers_by_objects do
			--format "point_helpers_by_object	= % \n" point_helpers_by_object

		/* GET HELEPRS BY OBJECT */
		for obj in source_objs do
		(
			--format "OBJ	= % \n" obj
			helpers_by_obj = this._getHelperByObject(obj)
			--format "HELPERS_BY_OBJ	= % \n" helpers_by_obj.keys.count
			/* GET SELECTED HELEPRS OF SELECTED SOURCE OBEJCT IF BOTH IS SELECTED */
			for helper_data in helpers_by_obj do
				if (index = findItem source_points helper_data.value ) > 0 then
					deleteItem source_points index
				--else
					--RemoveDictValue helpers_by_obj helper_data.key

			append source_helpers helpers_by_obj
		)

		--format "SOURCE_HELPERS	= % \n" SOURCE_HELPERS

		--format "SOURCE_POINTS	= % \n" source_points

		/* SORT SELECTED POINT BY SOURCE OBJECT */
		for source_point in source_points do
		(
			--format "SOURCE_POINT	= % \n" source_point
			if ( sync_pointer = getUserPropVal source_point "pointer_sync" asString:true ) != undefined then
			(
				source_vert = getUserPropVal source_point "source_vert"
				--format "SOURCE_VERT	= % \n" source_vert
				if not HasDictValue source_points_used sync_pointer then
					source_points_used[sync_pointer] = Dictionary #integer

				source_points_used[sync_pointer][source_vert] = source_point

			)else
				--format "\nWARNING: Point object# % IS NOT SYNCED	= % \n" source_point.name

		)

		/* ADD VALID POINTS TO HELEPRS */
		for key in source_points_used.keys do
			append source_helpers source_points_used[key]

		source_helpers --return
	),

	/** Get origin poiter
	 */
	function _getOriginPoiter source_obj =
	(
		--format "\n"; print "SupportManager_v._getOriginPoiter()"
		 getUserPropVal source_obj "pointer_sync" asString:true --return
	),

	/**
	 */
	on create do
	(

		Options	= SupportOptions_v(export_size)

		HelperGenerator	= HelperGenerator_v	Options:Options
		SupportGenerator	= SupportGenerator_v	Options:Options
		SupportModifiers = SupportModifiers_v Options:Options
		--SupportCrossSection	= SupportCrossSection_v	Options:Options
		--SupportObjectInstance 	= SupportObject_v	Options:Options

	)

)
