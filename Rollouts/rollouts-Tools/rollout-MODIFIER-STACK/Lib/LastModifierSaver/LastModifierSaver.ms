/** Last active modifier
 *
 * 1) Save node and index of modifier to LastModifierSaver
 *
 * TODO:
 * 	1) Reset after file open
 *
 */
struct LastModifierSaver_v
(
	/* required */
	/* dependency */
	/* reference */
	/* properties */
	nodes     = #(),
	modifiers = #(),
	
	/** Add
	 */
	function saveModifier =
	(
		--format "\n\n"; print "LastModifierSaver_v.saveModifier()"

		for obj in selection do
			this._saveModifierForEachNode(obj)
	),
	
		
	private
	
	
	/** Save modifier for each node
	 */
	function _saveModifierForEachNode _node =
	(
		--format "\n";
		--print "LastModifierSaver_v._saveModifierForEachNode()"
		index_of_modifier = modPanel.getModifierIndex _node ( modPanel.getCurrentObject() )
		
		if (index_of_node = findItem nodes _node) == 0 then;
			this._saveNewModifier(_node)(index_of_modifier)
		
		else
			this._replaceModifier(index_of_node)(index_of_modifier)
	),
	
	/** Save new modifier
	 */
	function _saveNewModifier _node index_of_modifier =
	(
		--format "\n"; print "LastModifierSaver_v._saveNewModifier()"
		append nodes _node
		
		append modifiers index_of_modifier
	),
	
	/** Repalce modifier
	 */
	function _replaceModifier index_of_node index_of_modifier =
	(
		--format "\n"; print "LastModifierSaver_v._replaceModifier()"
		modifiers[index_of_node] = index_of_modifier
	),

	/**  
	 */
	on create do
	(
	)

)



global LAST_MODIFIER_SAVER = LastModifierSaver_v()
