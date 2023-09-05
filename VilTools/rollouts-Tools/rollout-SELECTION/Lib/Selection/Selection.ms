/* Import sub substructs */

/** Selection_v
 */
struct Selection_v
(
	instances	= #(),
	references 	= #(),


	/** Get instances
	  */
	function getInstancesAll _objects visible:false =
	(
		if classOf _objects != Array then _objects = #(_objects)

		for obj in _objects do
			for inst in this._getObjInstances(obj) do
				appendIfUnique this.instances inst

		 this.instances--return
	),

	/** Get instances
	  */
	function getInstances _objects visible:false =
	(
		this._getInstancesOrReferences _objects #INSTANCE

		this.instances--return
	),

	/** Get instances
	  */
	function getReferences _objects visible:false =
	(
		this._getInstancesOrReferences _objects #REFERENCE

		this.instances--return
	),

	/** Get instances
	  *
	  * @param	node	_objects	for get instances
	  * @param	boolean	visible	if true only visible objects are returned
	  *
	  * @param	#ALL|#INSTANCE|#REFERENCE type mode for selecting instances or references
	  * 	#All:	Default, get instances & references of obj
	  * 	#INSTANCE:	Get only instances  of obj without references
	  * 	#REFERENCE:	Get only references of obj without instances
	 */
	function _getInstancesOrReferences _objects type  =
	(
		--format "\n"; print "Selection_v.getInstances()"
		--format "classOf _objects:	% \n" (classOf _objects)
		--if classOf _objects != Array and classOf _objects != ObjectSet then _objects = #(_objects)
		this._getObjects( &_objects )

		format "classOf _objects:	% \n" (classOf _objects)

		for obj in _objects do
			for inst in this._setInstances obj type:type do
				appendIfUnique this.instances inst
	),

	/** Select only Unique objects.
	  *	Deselect mutliple instances
	  *
	  * @return	array selection
	 */
	function filterUniqueObjects _objects =
	(
		this._getObjects( &_objects )


		unique_objects	= #()
		instances_all	= #()

		this.sortByPointers (&_objects)

		for obj in _objects where findItem instances_all obj == 0 do
		(
			local obj_instances

			InstanceMgr.GetInstances obj &obj_instances

			appendIfUnique unique_objects obj

			join instances_all obj_instances
		)

		--for obj in unique_objects do format "unique:	%\n" obj.name

		unique_objects
	),

	private

	/** Get instances
	  *
	  */
	function _setInstances obj type: =
	(
		format "\n"; print "Selection_v._setInstances()"
		--format "type:	% \n" type
		format "obj:	% \n\n" obj.name

		/** Get references
		  *
		  * @param boolean test true == instance, false == reference
		 */
		function instanceReferenceTest obj instances_obj test =
		(
			references = #()

			for obj_inst in instances_obj where  (areNodesInstances obj obj_inst) == test  do
				appendIfUnique references obj_inst

			references --return
		)

		instances_all = this._getObjInstances(obj)
		format "\n\n"; for inst in instances_all do format "inst:	%\n" inst.name

		references = instanceReferenceTest obj instances_all false
		format "\n\n"; for ref in references do format "ref:	%\n" ref.name

		instances_only =  for inst in instances_all where findItem references inst == 0 collect inst
		format "\n\n"; for inst in instances_only do format "inst only:	%\n" inst.name

		case type of
		(
			#INSTANCE:	instances_only
			#REFERENCE:	references
		)

	),

	/** Get obj instances
	  *
	  */
	function _getObjInstances obj =
	(
		--format "\n"; print "Selection_v.getObjInstances()"
		local instances_obj

		InstanceMgr.GetInstances obj &instances_obj

		instances_obj --return
	),

	/* Sort objects by order of creation */
	function sortByPointers &_objects =
	(
		pointers = sort (for obj in _objects collect getHandleByAnim obj)

		_objects = for pointer in pointers collect getAnimByHandle pointer

		_objects --return
	),

	/** Get objects
	  *
	  */
	function _getObjects &_objects =
	(
		--format "\n"; print "Selection_v._getObjects()"
		if classOf _objects != Array and classOf _objects != ObjectSet then #(_objects) else _objects
	),

	/**
	 */
	on create do
	(
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)
)