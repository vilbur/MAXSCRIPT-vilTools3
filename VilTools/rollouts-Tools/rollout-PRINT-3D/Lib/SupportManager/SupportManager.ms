

/** Support manager
 */
struct SupportManager_v
(
	/* construct */
	export_size,

	/* properties */
	point_helpers_by_objects	= Dictionary #string, -- 2DMATRIX of Dictionary #( "source_object_pionter", Dictionary #( integer:vertex_index, node:PointHelper   )   )

	/* dependency */
	Options,

	HelperGenerator,
	SupportGenerator,
	BeamGenerator,

	SupportModifiers,

	SupportObject = SupportObject_v(),

	/* reference */
	/* inhered */

	/** Generate instanced point helpers from selected verts
	  *
	  */
	function generatePointHelpers source_objects reset_helpers:true =
	(
		format "\n"; print "SupportManager_v.generatePointHelpers()"
		--Options.init()

		--this._setPointHelpersByObject()

		--new_points_by_objects = #()

		--/* DEBUG */
		--for point_helpers_per_obj in point_helpers_by_objects do
		--	for point_helper_per_obj in point_helpers_per_obj.value do
		--	--format "point_helper_per_obj	= % \n" point_helper_per_obj
		--	--format "point_helpers_by_objects	= % \n" point_helpers_by_objects

		source_objects_valid = this._getSourceObjects(source_objects)

		if ( source_objects_valid = this._getSourceObjects(source_objects) ) != undefined then
			new_points_by_objects = for source_obj in source_objects_valid collect
				HelperGenerator.generatePointHelpers(source_obj)(this._getHelpersByObject source_obj) reset_helpers:reset_helpers

		else
			messageBox "ERROR CREATE SUPPORTS \n\nNot any valid source object is selected" title:"SupportManager"  beep:false
			--format "\nERROR CREATE SUPPORTS - Not any valid source object is selected\n"

		--for point_created in points_created where point_created != undefined collect point_created  -- return created points

		if new_points_by_objects != undefined then
		(
			new_ponts_arr = #()

			for dict in new_points_by_objects do
				for key in dict.keys do append new_ponts_arr dict[key]

			new_ponts_arr --return
		)
		else
			#()
	),


	/** Create supports
	 */
	function createSupports source_objects raft_mode:false =
	(
		--format "\n"; print "SupportManager_v.createSupports()"
		--format "this.point_helpers_by_objects	= % \n" this.point_helpers_by_objects
		--Options.init()

		SupportGenerator.SupportObject.raft_mode = raft_mode
		SupportModifiers.raft_mode = raft_mode

		--this._setPointHelpersByObject()

		if ( source_objects_valid = this._getSourceHelpers(source_objects) ).count > 0 then
		(
			--format "SOURCE_OBJECTS_VALID	= % \n" source_objects_valid
			new_supports_by_obj = for source_helpers in source_objects_valid collect
				(SupportGenerator.generateSupports(source_helpers))

			supports_per_objects = this._getSupports pointer_sync:(getUserPropVal new_supports_by_obj[1][1] "pointer_sync" asString:true)


			for new_supports in new_supports_by_obj do
			(
				--format "new_supports	= % \n" new_supports

				supports_per_objects = this._getSupports pointer_sync:(getUserPropVal new_supports[1] "pointer_sync" asString:true)

				/* BUG IN _getSupports() - NEW SUPPORTS ARE NOT FOUND IN SCENE by userprop */
				join supports_per_objects new_supports

				SupportModifiers.addModifiers(supports_per_objects) -- SUPPORT OBJECT MUST BE SELECTED TO APPLY MODIFIERS
			)
		)
		else
			messageBox "ERROR CREATE SUPPORTS \n\nNot any valid source object selected" title:"SupportManager.ms"  beep:false
			--format "\nERROR CREATE SUPPORTS - Not any valid source object is selected\n"[]
	),

	/** Create Beams
	 */
	function createBeams source_objects =
	(
		format "\n"; print "SupportManager_v.rebuildSupports()"
		if ( supports_valid = this._getSupports source_objects:source_objects ).count > 0 then
			BeamGenerator.create (supports_valid)

		else
			messageBox "ERROR CREATE BEAMS\n\nNot any valid source object selected" title:"SupportManager.ms"  beep:false

	),

	private

	/** Get helper by object
	 */
	function _getHelpersByObject source_obj =
	(
		format "\n"; print "SupportManager_v._getHelpersByObject()"

		if point_helpers_by_objects.keys.count == 0 then
			this._setPointHelpersByObject()

		format "POINT_HELPERS_BY_OBJECTS	= % \n" POINT_HELPERS_BY_OBJECTS

		if ( pointer_sync = this._getOriginPoiter(source_obj) ) != undefined then
			point_helpers_by_objects[pointer_sync]
	),

	/** Get point helper
	 */
	function _setPointHelpersByObject =
	(
		--format "\n"; print "SupportManager_v._setPointHelpersByObject()"
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
	function _getSourceHelpers objects_array =
	(
		format "\n"; print "SupportManager_v._getSourceObjects()"
		format "objects_array	= % \n" objects_array
		--source_helpers	= #()
		SupportObject	= SupportObject_v()
		source_helpers	= Dictionary #string

		/* GET POINT HELPERS FROM SELECTED SOURCE OBJECTS */
		for source_obj in source_objs = this._getSourceObjects(objects_array) do
			source_helpers[this._getOriginPoiter(source_obj)] = this._getHelpersByObject(source_obj)


		/* GET HELPERS FROM SELECTED OBJECTS */
		for obj in objects_array where (master_point = HelperGenerator.getMasterPointByObj(obj)) != undefined do
		(
			sync_pointer = getUserPropVal master_point "pointer_sync" asString:true

			if not HasDictValue source_helpers sync_pointer then
				source_helpers[sync_pointer] = Dictionary #integer

			source_helpers[sync_pointer][getUserPropVal master_point "source_vert"] = master_point
		)

		for key in source_helpers.keys collect source_helpers[key]  --return
	),


	/** Get supports by sync inter
	 */
	function _getSupports source_objects: pointer_sync: =
	(
		--format "\n"; print "SupportManager_v.getSupportsBySyncInter()"
		--for _shape in shapes where getUserPropVal _shape "pointer_sync" asString:true == pointer_sync as string collect _shape
		if source_objects == unsupplied then
			source_objects = geometry

		if pointer_sync == unsupplied then
			for _shape in source_objects where superClassOf _shape.baseobject == shape and getUserPropVal _shape "pointer_sync" asString:true != undefined collect _shape

		else
			for _shape in source_objects where superClassOf _shape.baseobject == shape and getUserPropVal _shape "pointer_sync" asString:true == pointer_sync collect _shape

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
		SupportModifiers	= SupportModifiers_v	Options:Options
		BeamGenerator	= BeamGenerator_v	Options:Options

		--SupportObjectInstance 	= SupportObject_v	Options:Options

	)

)
