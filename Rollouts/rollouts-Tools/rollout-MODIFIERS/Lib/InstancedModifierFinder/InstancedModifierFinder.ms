/** Instanced modier finder
 */
struct InstancedModierFinder_v
(
	--__construct = #( #property_name ),
	
	/* construct */
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	_objects,
	
	/** Get instanced modifiers
	 */
	function getInstancedModifiers _objects_ =
	(
		format "\n"; print "InstancedModierFinder_v.getInstancedModifiers()"
		this._objects = _objects_
		
		instances_all = this._getAllInstancedModifiers()
		format "instances_all	= % \n" instances_all
		this._getOnlySharedInstances(instances_all) --return
	),

	private
	
	/** Get all instanced modifiers
	 */
	function _getAllInstancedModifiers =
	(
		--format "\n"; print "InstancedModierFinder_v.getAllModfierOfAllObjects()"
		modifiers = #()

		for obj in _objects do 
			for _modifier in obj.modifiers where ( refhierarchy.isRefTargetInstanced _modifier ) do 
				appendIfUnique modifiers _modifier
		
		modifiers --return
	),
	
	/** Get only shared instances
	 */
	function _getOnlySharedInstances modifiers =
	(
		--format "\n"; print "InstancedModierFinder_v._getOnlySharedInstances()"
		for _modifier in modifiers where this._isModifierOnAllObjects(_modifier) collect _modifier --return
	),
	
	
	/** Test if modifier is on every given object
	 */
	function _isModifierOnAllObjects _modifier =
	(
		--format "\n"; print "InstancedModierFinder_v._isModifierOnAllObjects()"
		_objects.count == (for obj in _objects where ( modPanel.getModifierIndex obj _modifier) != undefined collect obj).count
	),
	
	/**  
	 */
	on create do
	(
		--print("InstancedModierFinder_v.onCreate()")
		--ConstructPropeties test:this
	)
	
)