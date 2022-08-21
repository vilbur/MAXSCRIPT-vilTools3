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
	_objects_unique,
	
	prefix_by_parent,
	base_name,
	
	ascii_lowercase = "abcdefghijklmnopqrstuvwxyz",
	ascii_uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",

	/** Rename
	 */
	function rename _objects =
	(
		prefix_by_parent	= VilTools.Tools.ROLLOUT_OBJECTSSELECTION.CHECKBOX_by_parent.checked
		base_name	= VilTools.Tools.ROLLOUT_OBJECTSSELECTION.EDITTEXT_base_name.text
		
		select _objects
		
		_objects_unique	= (Selection_v()).filterUniqueObjects()

		for i = 1 to _objects_unique.count do
			this._renameObject (i)
	),

	private
	
	/** _rename object
	 */
	function _renameObject  index =
	(
		obj = _objects_unique[index]
		
		obj.name = (this._getPrefix obj) + base_name + "-" + ascii_uppercase[index]
		--format "obj.name	= % \n" obj.name
		this._renameInstances obj obj.name
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
	function _getSuffixNumber index instances_count =
	(
		digits_prefix	= ""
		index_length	= ( index as string ).count
		instances_length	= ( instances_count as string ).count
		
		if (length_difference = instances_length - index_length) > 0 then 
			for d = 1 to length_difference do
				digits_prefix += "0"	
		
		digits_prefix + index as string --return
	),
	
	/**  
	 */
	on create do
	(
		print("ObjectRenamer_v.onCreate()")
		--ConstructPropeties test:this
	)
)