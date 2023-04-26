filein( getFilenamePath(getSourceFileName()) + "/../Modifiers/Modifiers.ms" )

/** Modifier
  * 
  * @property	_modifier|name	_modifier	_modifier or class of _modifier E.g.: #chamfer
  * 
  * https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_DB496ACA_1506_4FB1_B8F8_EECC7D9794DD_htm  
 */
struct Modifier_v
(
	_modifier,

	Modifiers = Modifiers_v(),

	/** Set current _modifier
	 */
	function getCurrent =
	(
		max modify mode

		_modifier = modPanel.getCurrentObject()
	),

	/** Get objects with instance of given _modifier
	  *
	  * @property	array	_objects	where to serch for instance of _modifier
	  * @property	_modifier	_modifier	for search
	  *
	  * @return	array	
	 */
	function getObjectsWithInstance _objects =
	(
		objects_with_instance	= #()

		if( refhierarchy.isRefTargetInstanced _modifier ) then 
			objects_with_instance = for obj in _objects where (Modifiers.search obj _modifier) != undefined collect obj

		objects_with_instance --return
	),

	/** Select only Unique objects.
	  *	Deselect mutliple instances
	  *
	  * @return	array selection	
	 */
	function _selectUniqueObjects =
	(		
		for obj in selection do 
		(
			local obj_instances
			InstanceMgr.GetInstances obj &obj_instances

			if( obj_instances.count > 1 ) then
			(
				deleteItem obj_instances (findItem obj_instances obj)
				deselect obj_instances
			)
		)
	),

	on create do
	(
		format "\n"; print "Modifier_v.create()"

		if _modifier == undefined then
			this.getCurrent()
	)
)