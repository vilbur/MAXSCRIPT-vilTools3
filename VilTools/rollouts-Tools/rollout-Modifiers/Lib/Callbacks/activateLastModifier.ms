/** Last active modifier
 *
 * 1) Save node and index of modifier to LastActiveModifier
 *
 * TODO:
 * 	1) Reset after file open
 *
 */
struct LastActiveModifier_v
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
	
	/** Set node
	 */
	function setNode obj =
	(
		print ("LastActiveModifier_v.setNode " +  obj.name)
		appendIfUnique nodes obj

		_node = obj
		
		if not( this.modifierIndexExists() ) then 
			modifiers[this.indexNode()] = undefined
	),
	
	/** Add
	 */
	function saveModifier current_modifier =
	(
		--print "LastActiveModifier_v.saveModifier()"
		if( superClassOf current_modifier != modifier ) then
			return print "LastActiveModifier_v modifier not saved"
		
		_modifier     = current_modifier
		
		if ( (index_current = modPanel.getModifierIndex _node _modifier) != undefined and this._isTopModifierSelected index_current == false ) then
		(
			
			
			if( (index_from_bottom = this._getIndexFromBottom index_current) != false ) then
				modifiers[this.indexNode()] = index_from_bottom
			
			print "LastActiveModifier_v Modifier saved"
		)
		else
			print "Top Modifier Selected"
	),
	
	
	/** Activate
	 */
	function activate =
	(
		print "LastActiveModifier.activate()"
		
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
		if( _node	!= obj ) then
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



global LastActiveModifier = LastActiveModifier_v()



/** Wait for modifier change callback
 */
function waitForModifierChangeKill =
(
	print "Kill: waitForModifierChangeKill()"
	try(callbacks.removeScripts #modPanelObjPostChange id:#onModifierChanged)catch()
)


/** Wait for modifier change callback
 */
function waitForModifierActivationKill =
(
	print "Kill: waitForModifierActivationKill()"
	try(callbacks.removeScripts #modPanelObjPostChange id:#activateLastModifier)catch()
)


/** Selection changed callback kill
 */
function callbackKillAll =
(
	print "Kill: All Callbacks()"

	waitForModifierChangeKill()
	try(callbacks.removeScripts #modPanelObjPostChange id:#activateLastModifier)catch()
	try(callbacks.removeScripts #selectionSetChanged   id:#onSelectionChanged)catch()	
)






/** waitForSelectionChangeCallback
 */
function waitForSelectionChangedCallback =
(
	print "Start: onSelectionChanged()"
	callbacks.addScript #selectionSetChanged "onSelectionChanged()" id:#onSelectionChanged
)


/** Wait for modifier change callback
 */
function waitForModifierChangeCallback =
(
	print "Start: onModifierChanged()"
	callbacks.addScript #modPanelObjPostChange "onModifierChanged()" id:#onModifierChanged
)


/** Wait when modifier stack will be ready after selection has been changed
 */
function waitForModifierActivationCallback =
(
	print "Start: waitForModifierActivationCallback()"
	callbacks.addScript #modPanelObjPostChange "activateLastModifier()" id:#activateLastModifier
)




/** addScript #modPanelObjPostChange callback when selection is really changed
  *
  * This method avoid re selection of same object
  *
  *
 */
function onSelectionChanged =
(
	print "Callback: onSelectionChanged()"
				
	if( selection.count == 1 ) then
	(
		obj = selection[1]
		
		node_exist =  LastActiveModifier.nodeExists obj
		
		LastActiveModifier.setNode obj
		
		if( node_exist ) then -- Node exists in LastActiveModifier
			waitForModifierActivationCallback() -- Wait if user elect modifier in stack or will select another object
	
		else
			waitForModifierChangeCallback() --  "Node is selected first time"
	)
	else
	(
		print "DESELECT - reset all callbacks"
		
		callbackKillAll()

		LastActiveModifier._node = undefined
		
		waitForSelectionChangedCallback()
	)
)


/** Wait for valid #modPanelObjPostChange callback
  * #modPanelObjPostChange is fired multiple times with undefined modifier
  *
  *
 */
function onModifierChanged =
(
	print "Callback: onModifierChanged()"
	
	max modify mode

	if( (_modifier = modPanel.getCurrentObject()) != undefined ) then
		LastActiveModifier.saveModifier _modifier
)

/** Select last modifier
 */
function activateLastModifier =
(
	print "Callback: activateLastModifier()"
	
	max modify mode

	if( (_modifier = modPanel.getCurrentObject()) != undefined ) then
	(
		print "Callback: activateLastModifier VALID" 
		callbackKillAll()

		LastActiveModifier.activate()
		
		waitForSelectionChangedCallback()
		waitForModifierChangeCallback()
	)
)