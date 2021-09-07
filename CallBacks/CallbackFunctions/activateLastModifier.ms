

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

		--LastActiveModifier.setNode selection[1]
		
		LastActiveModifier.activate()

		
		waitForSelectionChangedCallback()
		waitForModifierChangeCallback()
	)
)

/** addScript #modPanelObjPostChange callback when selection is really changed
  *
  * This method avoid re selection of same object
  *
  *
 */
function onSelectionChanged =
(
	--clearListener()
	print "Callback: onSelectionChanged()"
	--selectionChangedCallbackKill()
				
	if( selection.count == 1 ) then
	(
		

		if( LastActiveModifier.nodeExists (obj = selection[1]) ) then
		(
			--print "Node exists in LastActiveModifier"
			--format "LastActiveModifier.wasSelectionChanged obj = % \n" ((LastActiveModifier.wasSelectionChanged obj))
			
			if ( (LastActiveModifier.wasSelectionChanged obj) == true ) then -- avoid reselect of same node
			(
			
				print "SELECTION CHANGED"
				LastActiveModifier.setNode obj
				
				callbacks.addScript #modPanelObjPostChange "activateLastModifier()" id:#activateLastModifier -- Wait if user elect modifier in stack or will select another object
			
			)
			else
			(
				
				print "RE-SELECT"
			)
				
		)
		else
		(
			print "Node Does not exists in LastActiveModifier"

			LastActiveModifier.setNode obj
			
			callbacks.addScript #modPanelObjPostChange "onModifierChanged()" id:#onModifierChanged
		)
	)
	else
	(
		print "DESELECT - reset all callbacks"
		
		callbackKillAll()

		LastActiveModifier._node = undefined
		
		waitForSelectionChangedCallback()
	)

)

/** Last active modifier

  1) Save node and index of modifier to LastActiveModifier

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

		format "nodes = % \n" nodes
	),
	
	/** Find object in this.nodes #()
	  *
	  * @return	int	index of object in arrray
	 */
	function nodeExists obj =
	(
		(findItem nodes obj > 0) --return
	),
	
	/** Is top modifiers selected
	 */
	function _isTopModifierSelected index =
	(
		index == 1 --return
	),
	
	/** Add
	 */
	function saveModifier current_modifier =
	(
		--print "LastActiveModifier_v.saveModifier()"
		--format "current_modifier = % \n" (current_modifier)
		if( superClassOf current_modifier != modifier ) then
			return print "LastActiveModifier_v modifier not saved"
		
		_modifier = current_modifier
		
		index = modPanel.getModifierIndex _node _modifier
		
		if not( this._isTopModifierSelected index or index == undefined ) then
		(
			index_from_bottom = this._getIndexFromBottom index
			
			if( index_from_bottom != false ) then
				modifiers[this.findNode()] = index_from_bottom
			
			print "LastActiveModifier_v Modifier saved"
		)
		else
			print "Top Modifier Selected"
	),
	
	/** Find object in this.nodes #()
	  *
	  * @return	int	index of object in arrray
	 */
	function findNode =
	(
		findItem nodes _node --return
	),

	/** Mode exists
	 */
	function modifierIndexExists =
	(
		modifiers[this.findNode()] != undefined --return
	),

	/** Get index from bottom
	 */
	function _getIndexFromBottom index =
	(
		_node.modifiers.count + 1 - ( index )
	),

	/** Activate
	 */
	function activate =
	(
		print "LastActiveModifier.activate()"
		
		if( _modifier == undefined or (this.modifierIndexExists()) == false ) then
			return false

		format "node_index = % \n" (this.findNode())

		index_from_bottom = this._getIndexFromBottom(modifiers[this.findNode()])
		format "index_from_bottom = % \n" index_from_bottom
		modPanel.setCurrentObject _node.modifiers[index_from_bottom] ui:true
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


/** Select last active modifier callback start
 */
function waitForModifierActivationCallbackStart =
(
	print "Start: waitForModifierActivationCallbackStart()"
	callbacks.addScript #modPanelObjPostChange "activateLastModifier()" id:#activateLastModifier
)



callbackKillAll()

waitForSelectionChangedCallback()



