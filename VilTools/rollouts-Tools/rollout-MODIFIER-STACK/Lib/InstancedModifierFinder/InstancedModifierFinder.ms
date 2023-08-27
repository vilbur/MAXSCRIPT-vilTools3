/** Find instanced modifiers on given nodes
  *
  * [Modify Panel help](https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_BAC3CC23_9D1D_44CE_B4AF_C0CEBDD7099E_htm)
  *
 */
struct InstancedModifierFinder_v
(
	--__construct = #(  ),
	/* construct */
	nodes,

	/* dependency */
	/* reference */
	/* properties */

	/** Get instanced modifiers which are on all given objects
	  *  	(modifiers which appear in modifier stack when multiple objects are selected)
	  *
	 */
	function getInstancedModifiers =
	(
		--format "\n"; print "InstancedModierFinder_v.getInstancedModifiers()"
		instances_all = this._getAllInstancedModifiers()
		--format "instances_all	= % \n" instances_all
		this._getOnlySharedInstances(instances_all)
	),

	/** Get indexes of instanced modifiers
	  *
	  * @param	class	classof_modifier	E.G.: Edit_Poly
	  *
	  * @return	array of integers
	 */
	function getIndexesOfInstances classof_modifier =
	(
		--format "\n"; print "ModifyStack_v.getInstanceIndexes()"

		instances_in_stack = this.getInstancedModifiers()
		--format "instances_in_stack	= % \n" instances_in_stack
		indexes = for i = 1 to instances_in_stack.count where classOf instances_in_stack[i] == classof_modifier collect i

		indexes --return
	),

	/** Get objects with instance of mmodifier
	  *
	  */
	function getObjectsWithInstance _modifier =
	(
		--format "\n"; print "InstancedModifierFinder.getObjectsWithInstance()"
		--format "_modifier:	% \n" _modifier.name
		objects_with_mod = #()

		for obj in nodes do
		   for _mod in obj.modifiers where refhierarchy.IsRefTargetInstanced _mod do
				if _mod == _modifier then
					append objects_with_mod obj

		objects_with_mod --return
	),

	private

	/** Get all instanced modifiers
	 */
	function _getAllInstancedModifiers =
	(
		--format "\n"; print "InstancedModierFinder_v.getAllModfierOfAllObjects()"
		modifiers = #()

		for obj in nodes do
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
		nodes.count == (for obj in nodes where ( modPanel.getModifierIndex obj _modifier) != undefined collect obj).count
	),

	/**
	 */
	on create do
	(
		--print("ModifyStack_v.onCreate()")
	)

)
