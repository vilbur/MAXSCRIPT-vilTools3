/** Object renamer
 */
struct ObjectRenamer_v
(
	--__construct = #( #property_name ),

	/* construct */
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	base_name,

	_objects,

	prefix_by_parent,
	_objects_unique,

	ascii_lowercase = "abcdefghijklmnopqrstuvwxyz",
	ascii_uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",

	/** Rename
	 */
	function rename _objects  =
	(
		--prefix_by_parent	= VilTools.Tools.ROLLOUT_OBJECTSSELECTION.CHECKBOX_by_parent.checked
		--base_name	= VilTools.Tools.ROLLOUT_OBJECTSSELECTION.EDITTEXT_base_name.text

		this._objects = _objects

		_objects_unique	= this.filterUniqueObjects()

		--select _objects_unique

		for i = 1 to _objects_unique.count do
			this._renameObject ( _objects_unique[i] )( i )
	),

	private

	/** _rename object
	 */
	function _renameObject obj index =
	(
		format "\n"; print "ObjectRenamer_v._renameObject()"

		--obj = _objects_unique[index]

		--obj.name = (this._getPrefix obj) + base_name + "-" + ascii_uppercase[index]
		obj.name = base_name + "-" + (this._getSuffixNumber index )

		InstanceMgr.GetInstances obj &obj_instances

		--format "obj_instances:	% \n" obj_instances
		deleteItem obj_instances ( findItem obj_instances obj )

		for i = 1 to obj_instances.count do
			obj_instances[i].name = obj.name + ascii_uppercase[i]


		--this._renameInstances obj obj.name
	),

	/** _rename instances
	 */
	function _renameInstances obj obj_name =
	(
		if( (obj_instances = this._getInstances obj).count > 1 ) then
			for i = 1 to obj_instances.count do
				obj_instances[i].name = obj_name + "-" + this._getSuffixNumber (i) (obj_instances.count)
	),

	/** _get instances
	 */
	function _getInstances obj =
	(
		obj_instances = #()

		InstanceMgr.GetInstances obj &obj_instances
		format "obj_instances	= % \n" obj_instances
		obj_instances --return
	),

	/** _get prefix
	 */
	function _getPrefix obj =
	(
		if prefix_by_parent and obj.parent != undefined then obj.parent.name + "-" else "" --return
	),

	/** _get suffix number
	 */
	function _getSuffixNumber index =
	(

		digits_prefix	= ""
		index_length	= ( index as string ).count
		instances_length	= ( _objects_unique.count as string ).count

		if (length_difference = instances_length - index_length) > 0 then
			for d = 1 to length_difference do
				digits_prefix += "0"

		digits_prefix + index as string --return
	),


	/** Select only Unique objects.
	  *	Deselect mutliple instances
	  *
	  * @return	array selection
	 */
	function filterUniqueObjects =
	(
		unique_objects	= #()
		instances_all	= #()

		for obj in this._objects where findItem instances_all obj == 0 do
		(
			local obj_instances

			InstanceMgr.GetInstances obj &obj_instances

			append unique_objects obj

			join instances_all obj_instances
		)

		for obj in unique_objects do format "unique:	%\n" obj.name

		unique_objects
	),


	/**
	 */
	on create do
	(
		print("ObjectRenamer_v.onCreate()")
		--ConstructPropeties test:this
	)
)