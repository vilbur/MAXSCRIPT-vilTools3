filein( getFilenamePath(getSourceFileName()) + "/../../../rollout-VERTEX-COLOR/Lib/meshVertToColorVertexConvertor/MeshVertToColorVertexConvertor.ms" )	--"./../rollout-VERTEX-COLOR/Lib/meshVertToColorVertexConvertor/MeshVertToColorVertexConvertor.ms"

filein( getFilenamePath(getSourceFileName()) + "/MeshVertexGetter/MeshVertexGetter.ms" )	--"./MeshVertexGetter/MeshVertexGetter.ms"
filein( getFilenamePath(getSourceFileName()) + "/ShapeKnotGetter/ShapeKnotGetter.ms" )	--"./ShapeKnotGetter/ShapeKnotGetter.ms"

filein( getFilenamePath(getSourceFileName()) + "/SupportModifiers/SupportModifiers.ms" )	--"./SupportModifiers/SupportModifiers.ms"
filein( getFilenamePath(getSourceFileName()) + "/SupportOptions/SupportOptions.ms" )	--"./SupportOptions/SupportOptions.ms"

filein( getFilenamePath(getSourceFileName()) + "/SourceObject/SourceObject.ms" )	--"./SourceObject/SourceObject.ms"
filein( getFilenamePath(getSourceFileName()) + "/HelperObject/HelperObject.ms" )	--"./HelperObject/HelperObject.ms"
filein( getFilenamePath(getSourceFileName()) + "/SupportObject/SupportObject.ms" )	--"./SupportObject/SupportObject.ms"
--filein( getFilenamePath(getSourceFileName()) + "/BeamObject/BeamObject.ms" )	--"./BeamObject/BeamObject.ms"

filein( getFilenamePath(getSourceFileName()) + "/HelperGenerator/HelperGenerator.ms" )	--"./HelperGenerator/HelperGenerator.ms"
filein( getFilenamePath(getSourceFileName()) + "/SupportGenerator/SupportGenerator.ms" )	--"./SupportGenerator/SupportGenerator.ms"
filein( getFilenamePath(getSourceFileName()) + "/BeamGenerator/BeamGenerator.ms" )	--"./BeamGenerator/BeamGenerator.ms"


/** Support manager
  *
  *  DESCRIPTION OF SUPPORT SYSTEM:
  *			• Objects are linked for easy manipulation. LINK IS NOT REQUIRED
  *
  *			• Objects are linked via user data. Data are saved on: Source object, Master Point, Support|Raft,
  *					Master Point know source object
  *					Support|Raft know source object
  *					Beams knows his 2 supports
  *
  *
  *  HIERARCHY OF OBJECTS:
  *
  *		1) SOURCE OBJECT: Mesh object from which are support points generated. Parent of all objects:
  *					// Used vertices  1) SELECTED verts 2) ALL vertex with colors if nothing selected 3) ALL vertices if selection and colors not exists
  *
  * 			2) MASTER POINT ON TOP OF PLAFTORM - Dispalyed as: #BOX and #CROSS - Main point synced with source object by user prop data.
  *					//  Master poin knows which source object and vert has been used.
  *
  * 				3) NORMAL POINT - Dispalyed as: #BOX : Point aligned with source vertex normal
  *
  * 					3) OTHER POINTS - Dispalyed as: #CROSS - Points defining shape of support linked in chain to each other
  *						//  Support points straight to the ground from last point in chain
  *
  * 					4a) RAFT     Same as support obejct, but ends on last point in chain
  * 					4b) SUPPORT: Line connecting all points in chain.
  *
  *		 					5) BEAM: Cross lines connectnig supports
 */
struct SupportManager_v
(
	/* construct */
	export_size,

	/* properties */
	point_helpers_by_objects = Dictionary #string, -- 2DMATRIX - Array of Dictionary #( "source_object_pionter", Dictionary #( integer:vertex_index, node:PointHelper   )   )

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
	  *  I LOVE spagetti
	  *
	  */
	function generatePointHelpers source_objects reset_helpers:true =
	(
		format "\n"; print "SupportManager_v.generatePointHelpers()"

		local new_points_by_objects
		--local selected_helpers_by_objects

        local new_points = #()
        local source_object_valid	= #()
        local verts_to_generate	= #{}

		/* GET  */
		local source_object_valid = this.getSourceObjects(source_objects)

	        /* TRY GET SOURCE LINE  */
		--if source_object_valid.count == 0 then
		--	source_object_valid = this._getSourceLines(source_objects)


		/* IF NEW SOURCE OBJECT IS USED */
		if source_object_valid.count == 0 then
			 source_object_valid = for source_obj in source_objects where superClassOf source_obj == GeometryClass or superClassOf source_obj == shape collect source_obj

		format "SOURCE_OBJECT_VALID: %\n" source_object_valid
		/* GET SELECTED POINT HELPERS and their source obejcts */
		selected_helpers_by_objects =  this.getSourceHelpers (source_objects)

		for pointer in selected_helpers_by_objects.keys where ( source_obj = this._getSourceObjectBySyncPointer(pointer) ) != undefined do
			appendIfUnique source_object_valid source_obj


		/* GENEARTE POINTS FOR EACH OBJECT - BUG !!!!!!!!!!!!!! - if multiuple objects are selected, then normal does not work properly, coord system should be checked probably */
		if source_object_valid.count > 0 then
			new_points_by_objects = for source_obj in source_object_valid collect
			(
				this._manageNameAndLayer(source_obj)


				if ( pointer = this._getPointerOfSourceObject(source_obj) ) != undefined then
				(
					if ( selected_helpers_of_obj = selected_helpers_by_objects[ pointer ] ) != undefined then
					   verts_to_generate = selected_helpers_of_obj.keys as BitArray -- get vertex indexes of selected helpers - for each source object
				)

				all_points_of_object = this.getAllPointsOfObject source_obj

				select source_obj -- QUICK WORKAROUND: created Points has differenet direction along vertex normals - IF MUTLIPLE OBJECTS SELECTED, something with "coordsys"

				HelperGenerator.generatePointHelpers(source_obj)(all_points_of_object) verts_to_generate:verts_to_generate reset_helpers:reset_helpers
			)

		else
			messageBox "ERROR CREATE SUPPORTS \n\nNot any valid source object is selected" title:"SupportManager"  beep:false


		/* FLATTERN ARRAY OF DISTIONARY VALUES */
		--if new_points_by_objects != undefined then
		--	for point_helpers in new_points_by_objects where point_helpers.count > 0 do join new_points point_helpers

		new_points --return
	),

	/** Create supports
	 */
	function createSupports source_objects raft_mode:false =
	(
		--format "\n"; print "SupportManager_v.createSupports()"

		SupportGenerator.SupportObject.raft_mode = raft_mode
		SupportModifiers.raft_mode = raft_mode

		helpers_by_source_obj = this.getSourceHelpers(source_objects)

		source_points_valid = for key in helpers_by_source_obj.keys collect helpers_by_source_obj[key]  --return

		if source_points_valid.count > 0 then
		(
			new_supports_by_obj = for source_helpers in source_points_valid collect
				(SupportGenerator.generateSupports(source_helpers))

			supports_per_objects = this.getSupports pointer_sync:(Options.getProp new_supports_by_obj[1][1] #pointer_sync)

			for new_supports in new_supports_by_obj do
			(
				supports_per_objects = this.getSupports pointer_sync:(Options.getProp new_supports[1] #pointer_sync)

				/* BUG IN getSupports() - NEW SUPPORTS ARE NOT FOUND IN SCENE by userprop */
				join supports_per_objects new_supports

				SupportModifiers.addModifiers(supports_per_objects) -- SUPPORT OBJECT MUST BE SELECTED TO APPLY MODIFIERS
			)
		)
		else
			messageBox "ERROR CREATE SUPPORTS \n\nNot any valid source object selected" title:"SupportManager.ms"  beep:false
	),

	/** Create Beams
	 */
	function createBeams source_objects =
	(
		format "\n"; print "SupportManager_v.rebuildSupports()"


		if ( supports_valid = this.getSupports source_objects:source_objects ).count > 0 then
		(
			beams_created = BeamGenerator.create (supports_valid)
		)else
			messageBox "ERROR CREATE BEAMS\n\nNot any valid source object selected" title:"SupportManager.ms"  beep:false

	),


	/*------------------------------------------------------------------------------

		FIND OBEJCTS BY OBEJCTS OR IN SCENE

	--------------------------------------------------------------------------------*/

	/** GET SOURCE OBJECTS by objects
	 */
	function getSourceObjects source_objects =
	(
		--format "\n"; print "SupportManager_v.getSourceObjects()"
		for obj in source_objects where this._getPointerOfSourceObject(obj) != undefined collect obj
	),


	--/** Get source line
	-- */
	--function _getSourceLines source_objects =
	--(
	--	--format "\n"; print "SupportManager_v._getSourceLine()"
	--	for obj in source_objects where superClassOf obj == shape collect obj
	--),

	/** GET ALL MASTER POINTS USED BY OBJECT
	  *
	  * @return 2DMATRIX - Array of Dictionares or undefined if source object has no points
	 */
	function getAllPointsOfObject source_obj =
	(
		format "\n"; print "SupportManager_v.getAllPointsOfObject()"
		if classOf source_obj == Array then source_obj = source_obj[1]

		/* INIT SET POINTS IF NOT SET */
		if point_helpers_by_objects.keys.count == 0 then
			this._setPointHelpersByObject()

		if ( pointer_sync = this._getPointerOfSourceObject(source_obj) ) != undefined then
			point_helpers_by_objects[pointer_sync]
	),


	/** GET MASTER POINTS in scene by objects
	  *
	  * @return Array of 2D Dictionaries #( KEY:sourec_object_pointer VALUE: #( KEY:vertex_index VALUE:helper_point ) ) )
	 */
	function getSourceHelpers objects_array =
	(
		format "\n"; print "SupportManager_v.getSourceObjects()"

        --SupportObject	= SupportObject_v()
        helpers_of_source_obj	= Dictionary #string

		/* 1)  GET POINT HELPERS FROM SELECTED SOURCE OBJECTS */
		for source_obj in source_objs = this.getSourceObjects(objects_array) do
			helpers_of_source_obj[this._getPointerOfSourceObject(source_obj)] = this.getAllPointsOfObject(source_obj)


		/* 2) GET HELPERS FROM SELECTED OBJECTS */
		for obj in objects_array where (master_point = HelperGenerator.getMasterPointByObj(obj)) != undefined do
		(
			sync_pointer = Options.getProp master_point #pointer_sync

			if not HasDictValue helpers_of_source_obj sync_pointer then
				helpers_of_source_obj[sync_pointer] = Dictionary #integer

			helpers_of_source_obj[sync_pointer][Options.getProp master_point #source_vert as integer ] = master_point
		)

		--for key in helpers_of_source_obj.keys collect helpers_of_source_obj[key]  --return
		helpers_of_source_obj --return
	),


	/** GET SUPPORTS by objects or scene if source_objects:unsupplied
	 */
	function getSupports source_objects: pointer_sync: =
	(
		--format "\n"; print "SupportManager_v.getSupportsBySyncInter()"
		--for _shape in shapes where Options.getProp _shape "pointer_sync" == pointer_sync as string collect _shape
		if source_objects == unsupplied then
			source_objects = geometry

		if pointer_sync == unsupplied then
			for _shape in source_objects where superClassOf _shape.baseobject == shape and Options.getProp _shape #pointer_sync != undefined collect _shape

		else
			for _shape in source_objects where superClassOf _shape.baseobject == shape and Options.getProp _shape #pointer_sync == pointer_sync collect _shape
	),

	/*------------------------------------------------------------------------------

		VISIBILITY

	--------------------------------------------------------------------------------*/
	/** Toggle visibility DOESN'T WORK YET
	  *
	  *  @param #POINT|#SUPPORT|##RAFT|#BEAM type
	  *
	 */
	function toggleVisibility type staOf =
	(
		--format "\n"; print "SupportManager_v.toggleVisibility()"
	--
	--	source_objects = if selection.count > 0 then selection as Array else for obj in objects where not obj.isHidden collect obj
	--
	--
	--	source_objects_valid = this.getSourceObjects(source_objects)
	--
	--	for source_obj in source_objects_valid do
	--format "this.getAllPointsByObject source_ob	= % \n" (this.getAllPointsByObject source_ob)

	),


	private

	/** Get source object by sync pointer
	  *
	  * @return node
	 */
	function _getSourceObjectBySyncPointer sync_pointer =
	(
		--format "\n"; print "SupportManager_v._getSourceObjectBySyncPointer()"

		source_objects = this.getSourceObjects( geometry )
		source_shapes  = this.getSourceObjects( shapes )

		join source_objects source_shapes

		/* FIND OBJECT MATCHI STRING IN USER PROPS */
		source_objects_by_pointer = for source_obj in source_objects where this._getPointerOfSourceObject (source_obj) == sync_pointer as string collect source_obj


		source_objects_by_pointer[1] --return
	),


	/** FIND MASTER POINTS IN SCENE AND SAVE THEM BY OBJECT POINTER TO DICTIONARY
	 */
	function _setPointHelpersByObject =
	(
		format "\n"; print "SupportManager_v._setPointHelpersByObject()"

		for _helper in helpers where classOf _helper == Point and ( source_obj_pointer = Options.getProp _helper #pointer_sync  ) != undefined do
			--if Options.getProp _helper #this  == getHandleByAnim _helper then -- test if helper is original node, prevent duplicated helpers
		(

			if point_helpers_by_objects[source_obj_pointer] == undefined then
				point_helpers_by_objects[source_obj_pointer] = Dictionary #integer

			if ( vertex_index = Options.getProp _helper #source_vert ) != undefined then
				point_helpers_by_objects[source_obj_pointer][ vertex_index as integer ] = _helper
		)
	),

	/** Get origin poiter
	 */
	function _getPointerOfSourceObject source_obj =
	(
		--format "\n"; print "SupportManager_v._getPointerOfSourceObject()"
		 Options.getProp source_obj #source_object --return
	),


	/** Manage name and layer
	 */
	function _manageNameAndLayer source_obj =
	(
		--format "\n"; print "SupportManager_v._manageNameAndLayer()"

		local layer
		source_obj_suffix = "-support-source"
		layer_name_suffix = "-support"

	new_name	= source_obj.name + source_obj_suffix
	layer_name	= (substituteString source_obj.name source_obj_suffix "" ) + layer_name_suffix -- remove object suffix and add layer suffix


		if not matchPattern source_obj.name pattern:("*"+source_obj_suffix) and \
			queryBox ("Rename source object ?\n\nFROM:\n\n"+source_obj.name + "\n\nTO:\n\n" + new_name ) title:"SupportManager.ms"  then
				source_obj.name = new_name


		if source_obj.layer.name != layer_name and \
			queryBox ("MOVE\n\n"+source_obj.name + "\n\nTO LAYER\n\n" + layer_name +" ? " ) title:"SupportManager.ms"  then
			(
				if ( layer = LayerManager.getLayerFromName layer_name ) == undefined then
				(
					layer = LayerManager.newLayerFromName layer_name

					layer.setParent source_obj.layer
				)

				layer.addnode (source_obj)

			)

	),

	/**
	*/
	on create do
	(
		Options = SupportOptions_v(export_size)

        HelperGenerator  = HelperGenerator_v Options:Options
        SupportGenerator = SupportGenerator_v Options:Options
        SupportModifiers = SupportModifiers_v Options:Options
        BeamGenerator    = BeamGenerator_v Options:Options

	)
)


/** GET INSTANCE OF SUPPORT GENERATOR
  *
  */
function getSupportManagerInstance =
(
	/** Reg ex replace
	 */
	function regExReplace _string search _replace = ( dotNetObject "System.Text.RegularExpressions.Regex" search ).Replace ( _string as string ) _replace

	SupportManager = SupportManager_v export_size:ROLLOUT_export.SPIN_export_size.value --use_every_nth_vert_of_spline:ROLLOUT_print_3d.SPIN_use_nth_vertex.value

	--Options	= SupportManager.Options

	/** FILL SupportManager PROPERTIES WITH DATA FROM UI
	  *
	  * Perform kind of this in loop:
	  *   Options.base_extrude	= roll.SPIN_base_width.value
	  */
	for ctrl in ROLLOUT_print_3d.controls where (prop_key = regExReplace ctrl.name "^(SPIN|CBX)_" "") != undefined and hasProperty SupportManager.Options prop_key do
		setProperty SupportManager.Options prop_key ( if classOf ctrl == CheckBoxControl then ctrl.state else ctrl.value )

    SupportManager.BeamGenerator.same_height	= ROLLOUT_print_3d.CBX_same_height.state

	SupportManager.Options.init()

	SupportManager --return
)
