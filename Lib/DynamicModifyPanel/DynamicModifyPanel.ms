/** Last active modifier
 *
 * 1) Save node and index of modifier to DynamicModifyPanel
 *
 * TODO:
 * 	1) Reset after file open
 *
 */
struct DynamicModifyPanel_v
(
	--__construct = #(  ),

	/* required */
	/* dependency */
	/* reference */
	/* properties */
	_node,
	_modifier,

	nodes     = #(),
	modifiers = #(),
	
	
	/** Selection changed
	 */
	function selectionChanged obj =
	(
		_node != obj
	),
	
	/** Set node
	 */
	function setNode obj =
	(
		print ("DynamicModifyPanel_v.setNode " +  obj.name)
		appendIfUnique nodes obj

		_node = obj
		
		if not( this.modifierIndexExists() ) then 
			modifiers[this.indexNode()] = undefined
	),
	
	/** Add
	 */
	function saveModifier current_modifier =
	(
		--print "DynamicModifyPanel_v.saveModifier()"
		if( superClassOf current_modifier != modifier ) then
			return print "DynamicModifyPanel_v modifier not saved"
		
		_modifier     = current_modifier
		
		if ( (index_current = modPanel.getModifierIndex _node _modifier) != undefined and this._isTopModifierSelected index_current == false ) then
		(
			if( (index_from_bottom = this._getIndexFromBottom index_current) != false ) then
				modifiers[this.indexNode()] = index_from_bottom
			
			print "DynamicModifyPanel_v Modifier saved"
		)
		else
			print "Top Modifier Selected"
	),
	
	
	/** Activate
	 */
	function activate =
	(
		print "DynamicModifyPanel.activate()"
		
		if( _modifier == undefined or (this.modifierIndexExists()) == false ) then
			return false

		index_from_bottom = this._getIndexFromBottom(modifiers[this.indexNode()])

		modPanel.setCurrentObject _node.modifiers[index_from_bottom] ui:true
	),

	/** Find object in this.nodes #()
	  *
	  * @return	int	index of object in arrray
	 */
	function nodeExists obj =
	(
		(findItem nodes obj > 0) --return
	),
	
	/** Find object in this.nodes #()
	  *
	  * @return	int	index of object in arrray
	 */
	function indexNode =
	(
		findItem nodes _node --return
	),

	/** Mode exists
	 */
	function modifierIndexExists =
	(
		modifiers[this.indexNode()] != undefined --return
	),

	/** Get index from bottom
	 */
	function _getIndexFromBottom index =
	(
		_node.modifiers.count + 1 - ( index )
	),

	/** Is top modifiers selected
	 */
	function _isTopModifierSelected index =
	(
		index == 1 --return
	),

	/** Set obj
	 */
	function wasSelectionChanged obj =
	(
		if( _node != obj ) then
		(
			_node	= obj
			true --return
		)
		else
			false --return
	),

	/**  
	 */
	on create do
	(
	)

)



global DynamicModifyPanel = DynamicModifyPanel_v()
