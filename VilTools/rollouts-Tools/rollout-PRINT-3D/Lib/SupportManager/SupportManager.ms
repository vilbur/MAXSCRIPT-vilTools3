

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
		format "\n"; print "SupportManager_v.generatePointHelpers()"
		Options.init()

		this._setPointHelpersByObject()

		point_helpers_by_objects = #()

		--/* DEBUG */
		--for point_helpers_per_obj in point_helpers_by_objects do
		--	for point_helper_per_obj in point_helpers_per_obj.value do
		--	--format "point_helper_per_obj	= % \n" point_helper_per_obj
		--	--format "point_helpers_by_objects	= % \n" point_helpers_by_objects

		source_objects_valid = this._getSourceObjects(source_objects)

		if ( source_objects_valid = this._getSourceObjects(source_objects) ) != undefined then
			point_helpers_by_objects = for source_obj in source_objects_valid collect
				HelperGenerator.generatePointHelpers(source_obj)(this._getHelperByObject source_obj) reset_helpers:reset_helpers

		else
			messageBox "ERROR CREATE SUPPORTS \n\nNot any valid source object is selected" title:"SupportManager"  beep:false
			--format "\nERROR CREATE SUPPORTS - Not any valid source object is selected\n"

		--for point_created in points_created where point_created != undefined collect point_created  -- return created points
		point_helpers_by_objects --return
	),


	/** Create supports
	 */
	function createSupports source_objects raft_mode:false =
	(
		--format "\n"; print "SupportManager_v.createSupports()"
		--format "this.point_helpers_by_objects	= % \n" this.point_helpers_by_objects
		Options.init()

		SupportGenerator.SupportObject.raft_mode = raft_mode
		SupportModifiers.raft_mode = raft_mode

		this._setPointHelpersByObject()

		if ( source_objects_valid = this._getSourceHelpers(source_objects) ).count > 0 then
		(
			--format "SOURCE_OBJECTS_VALID	= % \n" source_objects_valid
			new_supports_by_obj = for source_helpers in source_objects_valid collect
				(SupportGenerator.generateSupports(source_helpers))

			supports_per_objects = this._getSupportsBySyncPointer (getUserPropVal new_supports_by_obj[1][1] "pointer_sync" asString:true)


			for new_supports in new_supports_by_obj do
			(
				--format "new_supports	= % \n" new_supports

				supports_per_objects = this._getSupportsBySyncPointer (getUserPropVal new_supports[1] "pointer_sync" asString:true)

				/* BUG IN _getSupportsBySyncPointer() - NEW SUPPORTS ARE NOT FOUND IN SCENE by userprop */
				join supports_per_objects new_supports

				SupportModifiers.addModifiers(supports_per_objects) -- SUPPORT OBJECT MUST BE SELECTED TO APPLY MODIFIERS
			)
		)
		else
			messageBox "ERROR CREATE SUPPORTS \n\nNot any valid source object selected" title:"Title"  beep:false
			--format "\nERROR CREATE SUPPORTS - Not any valid source object is selected\n"
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
	),

	/** Get source objects
	 */
	function _getSourceObjects source_objects =
	(
		--format "\n"; print "SupportManager_v._getSourceObjects()"
		for obj in source_objects where this._getOriginPoiter(obj) != undefined collect obj
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

			append source_helpers helpers_by_obj
		)

		/* SORT SELECTED POINT BY SOURCE OBJECT */
		for source_point in source_points do
		(
			if ( sync_pointer = getUserPropVal source_point "pointer_sync" asString:true ) != undefined then
			(
				source_vert = getUserPropVal source_point "source_vert"
				--format "SOURCE_VERT	= % \n" source_vert
				if not HasDictValue source_points_used sync_pointer then
					source_points_used[sync_pointer] = Dictionary #integer

				source_points_used[sync_pointer][source_vert] = source_point

			)else
				format "\nWARNING: Point object IS NOT SYNCED	= % \n" source_point.name
		)
		/* ADD VALID POINTS TO HELEPRS */
		for key in source_points_used.keys do
			append source_helpers source_points_used[key]

		source_helpers --return
	),


	/** Get supports by sync inter
	 */
	function _getSupportsBySyncPointer pointer_sync =
	(
		--format "\n"; print "SupportManager_v.getSupportsBySyncInter()"
		--for _shape in shapes where getUserPropVal _shape "pointer_sync" asString:true == pointer_sync as string collect _shape
		for _shape in geometry where superClassOf _shape.baseobject == shape and getUserPropVal _shape "pointer_sync" asString:true == pointer_sync collect _shape
	),

	/** Get origin poiter
	 */
	function _getOriginPoiter source_obj =
	(
		--format "\n"; print "SupportManager_v._getOriginPoiter()"
		 getUserPropVal source_obj "pointer_sync_source" asString:true --return
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
