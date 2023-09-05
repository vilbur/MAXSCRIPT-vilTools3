/* Import sub substructs */

/** Selection_v
 */
struct Selection_v
(

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
	function getInstances _objects type:#ALL visible:false  =
	(
		--format "\n"; print "Selection_v.getInstances()"
		instances = #()

		this.sortByPointers (&_objects)

		unique_objects = this.filterUniqueObjects( _objects )

		for obj in unique_objects do
			join instances (this._getInstances obj type:type visible:visible )

		instances --return
	),

	/** Select only Unique objects.
	  *	Deselect mutliple instances
	  *
	  * @return	array selection
	 */
	function filterUniqueObjects _objects =
	(
		unique_objects	= #()
		instances_all	= #()

		this.sortByPointers (&_objects)

		for obj in _objects where findItem instances_all obj == 0 do
		(
			local obj_instances

			InstanceMgr.GetInstances obj &obj_instances

			append unique_objects obj

			join instances_all obj_instances
		)

		--for obj in unique_objects do format "unique:	%\n" obj.name

		unique_objects
	),

	private

	/** Get instances
	  *
	  */
	function _getInstances obj type: visible:  =
	(
		--format "\n"; print "Selection_v._getInstances()"
		--format "type:	% \n" type

		/** Get references
		  *
		  * @param boolean test true == instance, false == reference
		 */
		function getReferences obj instances test =
		(
			references = #()

			for _instance in instances where  (areNodesInstances obj _instance) == test  do
				append references _instance

			references --return
		)

		local instances

		InstanceMgr.GetInstances obj &instances

		result = case type of
		(
			#INSTANCE:	getReferences obj instances true
			#REFERENCE:	getReferences obj instances false
			default:	instances
		)

		if visible == true then
			for o in result where o.isHidden == false do deleteItem result (findItem result o )  --return

		result --return

	),

	/* Sort objects by order of creation */
	function sortByPointers &_objects =
	(
		pointers = sort (for obj in _objects collect getHandleByAnim obj)

		_objects = for pointer in pointers collect getAnimByHandle pointer

		_objects --return
	),

	/**
	 */
	on create do
	(
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)
)