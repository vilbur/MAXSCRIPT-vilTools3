/* Import sub substructs */

/** Selection_v
 */
struct Selection_v
(
	instances	= #(),

	/** Get instances
	  */
	function getInstancesAndReferences _objects =
	(
		this._getInstancesOrReferences _objects #ALL
	),

	/** Get instances
	  */
	function getInstances _objects =
	(
		this._getInstancesOrReferences _objects #INSTANCE
	),

	/** Get instances
	  */
	function getReferences _objects =
	(
		instances_and_references = this.getInstancesAndReferences _objects

		this._filter instances_and_references #REFERENCE
	),


	/** Filter reference
	  *
	  */
	function filterInstance _objects =
	(
		this._filter _objects #INSTANCE
	),
	/** Filter reference
	  *
	  */
	function filterReference _objects =
	(
		this._filter _objects #REFERENCE
	),

	/** Select only Unique objects.
	  *	Deselect mutliple instances
	  *
	  * @return	array selection
	 */
	function filterUnique _objects =
	(
		unique_objects	= #()
		instances_all	= #()

		this._getObjects( &_objects )

		this._sortByPointers (&_objects)

		for obj in _objects where findItem instances_all obj == 0 do
		(
			appendIfUnique unique_objects obj

			join instances_all (this._getObjInstances(obj))
		)

		unique_objects
	),

	private

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
		this.instances	= #()

		--format "\n"; print "Selection_v._getInstancesOrReferences()"
		this._getObjects( &_objects )
		--format "_objects:	% \n" _objects

		if _objects != undefined then
			for obj in _objects where findItem this.instances obj == 0 do
				for inst in this._getInstancesByType obj type where findItem this.instances inst == 0 do
					appendIfUnique this.instances inst

		this.instances--return
	),

	/** Get instances
	  *
	  */
	function _getInstancesByType obj type =
	(
		--format "\n"; print "Selection_v._getInstancesByType()"
		--format "type	% \n" type
		--format "obj:	% \n\n" obj.name

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
		--format "\n\n"; for obj in instances_all do format "obj:	%\n" obj.name
		--this._sortByPointers (&instances_all)
		--format "\n\n"; for obj in instances_all do format "obj:	%\n" obj.name

		if type != #ALL then
		(
			references = instanceReferenceTest obj instances_all false
			--format "\n\n"; for ref in references do format "ref:	%\n" ref.name

			instances_only =  for inst in instances_all where findItem references inst == 0 collect inst
			--format "\n\n"; for inst in instances_only do format "inst only:	%\n" inst.name

			case type of  --return
			(
				#INSTANCE:	if instances_only.count > 1 then instances_only else #()
				#REFERENCE:	references
			)
		)
		else
		(
			if instances_all.count > 1 then instances_all else #()
		)
			--instances_all --return
	),

	/** Get obj instances
	  *
	  */
	function _getObjInstances obj =
	(
		--format "\n"; print "Selection_v.getObjInstances()"
		local instances_obj

		InstanceMgr.GetInstances obj &instances_obj

		instances_obj
	),


	/** Filter reference
	  *
	  */
	function _filter _objects type =
	(
		this._getObjects( &_objects )

		this._sortByPointers (&_objects)

		--format "\n"; print "Selection_v._filter()"

		inst_or_ref = this._getInstancesOrReferences _objects type

		--format "\n\n"; for inst_or_ref in objects do format "inst_or_ref:	%\n" inst_or_ref.name

		for ref in inst_or_ref where findItem _objects ref > 0 collect ref
	),

	/* Sort objects by order of creation */
	function _sortByPointers &_objects =
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