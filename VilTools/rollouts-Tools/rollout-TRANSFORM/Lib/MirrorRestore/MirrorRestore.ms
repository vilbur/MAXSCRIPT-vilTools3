
/** Mirror restore
 */
struct MirrorRestore_v
(
	/* construct */
	mirrored_objects,
	re_mirrored_objects = #(),


	/* dependency */
	MirrorByGizmo = MirrorByGizmo_v(),

	/* properties */
	mirror_sources = Dictionary( #string ), -- #( "objectPointerOfSourceObject", #(mirrored_nodes) )

	/* reference */
	/* inhered */

	/** Restore mirrors
	  *
	  * @param ObjectSet mirrored_objects obejcts with userprop user_prop_key
	  */
	function restoreMirrors objects_to_search_for_restore =
	(
		format "\n"; print "MirrorRestore_v.restoreMirrors()"

		this.mirrored_objects = this._getMirroredObjects (objects_to_search_for_restore)

		this._setMirrorSources()

		for  mirrored_obj in this.mirrored_objects do
			append (this.re_mirrored_objects) (this._restoreObject (mirrored_obj))


		if re_mirrored_objects.count == 0 then
			messageBox "Nothing to restore" title:"RESTORE MIRRORED OBJECTS"  beep:false

		else
			print "MIRRORS RESTORED"


		re_mirrored_objects --return
	),


	private


	/** Restore object
	  *
	  */
	function _restoreObject mirrored_old  =
	(
		--format "\n"; print "MirrorByGizmo_v._restoreObject()"

		mirror_setup = this._getMirrorSetupData (mirrored_old)

		if (source_object = this._getSourceObject (mirror_setup) ) != undefined  then
		(
			/* SAVE OTHER PROPERTIES */
			saved_data = this._getObjectStateData (mirrored_old)

			/* DELETE OLD MIRRORED OBEJCT */
			delete mirrored_old

			/* CONFIGURE MIRRORING */
			this._configureMirrorByGizmo (mirror_setup)

			/* REMIRROR */
			mirrored_new = MirrorByGizmo.mirrorObj (source_object)

			/* KEEP MIRRORING CHAIN */
			this._replaceSourceInObjects (saved_data[#pointer]) (getHandleByAnim mirrored_new)

			/* RESTORE OTHER PROPERTIES */
			this._restoreObjectStateData (mirrored_new) (saved_data)
		)

		mirrored_new --return
	),

	/** Configure mirror by gizmo
	  *
	  */
	function _configureMirrorByGizmo mirror_setup =
	(
		--format "\n"; print "MirrorRestore_v.configureMirrorByGizmo()"
		for key in mirror_setup.keys where key != #source do
			setProperty MirrorByGizmo key mirror_setup[key]
	),

	/** Get object state
	  *
	  */
	function _getObjectStateData mirrored_old =
	(
		--format "\n"; print "MirrorRestore_v._getObjectStateData()"
		--format "mirrored_old.children:	% \n" mirrored_old.children
		saved_data = Dictionary()

		saved_data[#transform]	= mirrored_old.transform
		saved_data[#wirecolor]	= mirrored_old.wirecolor
		saved_data[#parent]	= mirrored_old.parent
		saved_data[#children]	= for child in mirrored_old.children collect child
		saved_data[#pointer]	= getHandleByAnim mirrored_old

		saved_data --return
	),

	/** Get object state
	  *
	  */
	function _restoreObjectStateData mirrored_new saved_data =
	(
		--format "\n"; print "MirrorRestore_v._getObjectStateData()"
		for key in saved_data.keys do
			case key of
			(
				#transform:	mirrored_new.transform	= saved_data[#transform]
				#parent:	mirrored_new.parent	= saved_data[#parent]
				#wirecolor:	mirrored_new.wirecolor = saved_data[#wirecolor]
				#children:	 for child in saved_data[#children] where isValidNode child do child.parent = mirrored_new
			)

	),
	/** Get source object
	  *
	  */
	function _getSourceObject mirror_setup =
	(
		--format "\n"; print "MirrorRestore_v.getSourceObjects()"
		source_obj = getAnimByHandle mirror_setup[#source]

		if isValidNode source_obj then
			source_obj --return
	),

	/** 1) Get mirrored objects in scene
	  * 2) Set them to dictionary by its mirror source object
	  */
	function _setMirrorSources =
	(
		--format "\n"; print "MirrorRestore_v._setMirrorSources()"
		mirrored_objects_in_scene = this._getMirroredObjects ( objects )

		for obj in this.mirrored_objects do
		(
			mirror_setup = this._getMirrorSetupData(obj)
			--format "mirror_setup:	% \n" mirror_setup
			source_pointer = mirror_setup[#source] as string
			--format "source_pointer:	% \n" source_pointer
			if mirror_sources[source_pointer] == undefined then
				mirror_sources[source_pointer] = #()

			append mirror_sources[source_pointer] obj
		)

		format "MIRROR_SOURCES:	% \n" mirror_sources
	),

	/** Get mirrored objects
	  *
	  */
	function _getMirroredObjects _objects =
	(
		--format "\n"; print "MirrorRestore_v._getMirroredObjects()"
		if classOf _objects == ObjectSet then
			_objects = _objects as Array

		mirrored_objects_temp = for obj in _objects where this._getMirrorSetupData(obj) != undefined collect obj

		if mirrored_objects_temp.count > 0 then
			mirrored_objects_temp --return
		else
			#() -- fallback
	),

	/** Keep mirror chain
	  *
	  * Remmirrored object can be source object of othe mirrored objects
	  *
	  * This will replace mirror source in user properties
	  */
	function _replaceSourceInObjects mirrored_pointer remirrored_pointer =
	(
		format "\n"; print "MirrorByGizmo_v._replaceSourceInObjects()"
		for mirror_source_pointer in mirror_sources.keys where mirror_source_pointer == mirrored_pointer as string do
			for mirrored_old in mirror_sources[mirror_source_pointer] where isValidNode mirrored_old do
			(
				mirror_setup = this._getMirrorSetupData (mirrored_old)

				mirror_setup[#source] = remirrored_pointer

				this._setUserProps (mirrored_old) (mirror_setup)
			)
	),

	/** Get mirror setup data
	  *
	  */
	function _getMirrorSetupData mirrored_obj =
	(
		--format "\n"; print "MirrorByGizmo_v._getMirrorSetupData()"

		mirror_setup = getUserProp mirrored_obj MirrorByGizmo.user_prop_key
		--format "mirror_setup:	% \n" mirror_setup
		if mirror_setup != undefined  then
			execute mirror_setup --return
	),

	/**
	 */
	on create do
	(
	)
)
