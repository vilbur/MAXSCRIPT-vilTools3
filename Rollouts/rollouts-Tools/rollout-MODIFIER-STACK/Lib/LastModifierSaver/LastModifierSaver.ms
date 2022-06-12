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
	--__construct = #(  ),

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
		format "\n\n";
		print "LastModifierSaver_v.saveModifier()"

		for obj in selection do
			this._saveModifierForEachNode(obj)
	),
	
		
	private
	
	
	/** Save modifier for each node
	 */
	function _saveModifierForEachNode _node =
	(
		--format "\n";
		print "LastModifierSaver_v._saveModifierForEachNode()"
		--format "_node	= % \n" _node
		--format "_modifier	= % \n" _modifier
		index_of_modifier = modPanel.getModifierIndex _node ( modPanel.getCurrentObject() )
		
		if (index_of_node = findItem nodes _node) == 0 then;
			this._saveNewModifier(_node)(index_of_modifier)
		
		else
			this._replaceModifier(index_of_node)(index_of_modifier)

		format "nodes	= % \n" nodes
		format "modifiers	= % \n" modifiers
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
		format "\n"; print "LastModifierSaver_v._replaceModifier()"
		
		modifiers[index_of_node] = index_of_modifier
	),
	--/** Find object in this.nodes #()
	--  *
	--  * @return	int	index of object in arrray
	-- */
	--function indexNode =
	--(
	--	findItem nodes _node --return
	--),
	
	--/** Activate
	-- */
	--function activate =
	--(
	--	print "LastModifierSaver.activate()"
	--	
	--	if( _modifier == undefined or (this.modifierIndexExists()) == false ) then
	--		return false
	--
	--	index_from_bottom = this._getIndexFromBottom(modifiers[this.indexNode()])
	--
	--	modPanel.setCurrentObject _node.modifiers[index_from_bottom] ui:true
	--),

	--/** Find object in this.nodes #()
	--  *
	--  * @return	int	index of object in arrray
	-- */
	--function nodeExists obj =
	--(
	--	(findItem nodes obj > 0) --return
	--),
	--

	--
	--/** Mode exists
	-- */
	--function modifierIndexExists =
	--(
	--	modifiers[this.indexNode()] != undefined --return
	--),
	--
	--/** Get index from bottom
	-- */
	--function _getIndexFromBottom index =
	--(
	--	_node.modifiers.count + 1 - ( index )
	--),
	--
	--/** Is top modifiers selected
	-- */
	--function _isTopModifierSelected index =
	--(
	--	index == 1 --return
	--),
	--
	--/** Set obj
	-- */
	--function wasSelectionChanged obj =
	--(
	--	if( _node != obj ) then
	--	(
	--		_node	= obj
	--		true --return
	--	)
	--	else
	--		false --return
	--),

	/**  
	 */
	on create do
	(
	)

)



global LAST_MODIFIER_SAVER = LastModifierSaver_v()
