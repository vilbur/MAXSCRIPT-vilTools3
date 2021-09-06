

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
	
	
	/** Find object in this.nodes #()
	  *
	  * @return	int	index of object in arrray
	 */
	function nodeExists obj =
	(
		(findItem nodes obj > 0) --return
	),
	/** Add
	 */
	function addNode obj =
	(
		print "LastActiveModifier_v.addNode()"
		
		appendIfUnique nodes obj
		
		_node = obj
		
		format "nodes = % \n" nodes

	),
	/** Add
	 */
	function saveModifier modifier =
	(
		print "LastActiveModifier_v.saveModifier()"
		_modifier = modifier
		--
		----appendIfUnique nodes _node
		----		clearListener()
		------this.find obj --ret this._getIndexFromBottom()urn
		---- --this._getIndexFromBottom()
		node_index = this.findNode()
		
				
		--format "node_index = % \n" node_index
		---- format "this._getIndexFromBottom() = % \n" (this._getIndexFromBottom())
		--format "this.findNode() = % \n" (this.findNode())
		----modifiers[this.findNode()] = this._getIndexFromBottom()
		--format "nodes = % \n" nodes
		--
		--if( this._modifierExists node_index ) then 
		--(
		--	print "modifier exists"
		--	modifiers[node_index]


		--)
		--else
		--(
		--	print "modifier Dont exists"
			modifiers[node_index] = this._getIndexFromBottom( modPanel.getModifierIndex _node _modifier )
		--)
		
		
		--format "this.index() = % \n" (this.index())
		--modPanel.setCurrentObject _node.modifiers[this.index()] ui:true

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
	function modifierExists node_index =
	(
		--print "modeExists()"
		--node_index = this.findNode()

		
		
		modifiers[this.findNode()] != undefined --return
	),
	
	/** Get index of modifier from modify stack
	 */
	function index =
	(
		modPanel.getModifierIndex _node _modifier
	),	
	
	/** Get index from bottom
	 */
	function _getIndexFromBottom index =
	(
		format "_modifier = % \n" _modifier
		_node.modifiers.count + 1 - ( index )
	),
	
	/** Activate
	 */
	function activate =
	(
		--clearListener()
		print "LastActiveModifier.activate()"
		format "modifier = % \n" modifier
		
		node_index = this.findNode()
		
		format "node_index = % \n" node_index
		
		stack_index = this._getIndexFromBottom(modifiers[node_index])
		-- format "this._getIndexFromBottom() = % \n" (this._getIndexFromBottom())
		--format "this.findNode() = % \n" (this.findNode())
		----modifiers[this.findNode()] = this._getIndexFromBottom()
		--format "nodes = % \n" nodes
		--
		--if( this._modifierExists node_index ) then 
		--(
		--	print "modifier exists"
		--	modifiers[node_index]
		--
		--)
		modPanel.setCurrentObject _node.modifiers[stack_index] ui:true

			--callbacks.addScript #selectionSetChanged "activateLastModifier()" id:#activateLastModifier

		
		--format "LastActiveModifier = % \n" LastActiveModifier
		--
	
	),
	
	/** Set obj
	 */
	function selectionChanged obj =
	(
		if( _node	!= obj ) then
		(
			_node	= obj
			true --return
		)
		else
			false --return   
		
	),
	
	--/** Set current modifier
	-- */
	--function _setCurrentModifier =
	--(
	--	max modify mode
	--	
	--	_modifier = modPanel.getCurrentObject()
	--	format "_modifier = % \n" _modifier
	--	
	--),
	

	/**  
	 */
	on create do
	(
	)
	
)

global LastActiveModifier = LastActiveModifier_v()


/** Select last modifier
 */
function selectLastModifier =
(
	print "Callback: selectLastModifier()"
	max modify mode
	--format "_modifier = % \n" _modifier
		
	if( (_modifier = modPanel.getCurrentObject()) != undefined ) then
	(
		print ("Stack is ready " + _modifier as string)
		
		callbacks.removeScripts #modPanelObjPostChange id:#selectLastModifier
		
		LastActiveModifier.activate()
		
		callbacks.addScript #modPanelObjPostChange "watchModifyChange()" id:#watchModifyChange


	)
)


/** Wait for valid #modPanelObjPostChange callback
  * #modPanelObjPostChange is fired multiple times with undefined modifier
  *
  *
 */
function watchModifyChange =
(
	print "Callback: watchModifyChange()"
	max modify mode
		
--_modifier = modPanel.getCurrentObject()
	--format "_modifier = % \n" _modifier
		
	if( (_modifier = modPanel.getCurrentObject()) != undefined ) then
	(
		print ("Modifier changed to " + _modifier as string)
		
		--LastActiveModifier.saveModifier _modifier
		
		if( LastActiveModifier.modifierExists selection[1] ) then 
		(
			print "modifier exists"
			LastActiveModifier.saveModifier _modifier

		)
		else
		(
			print "Modifier Don`t exists"
			LastActiveModifier.saveModifier _modifier
		)
		format "LastActiveModifier.modifiers = % \n" LastActiveModifier.modifiers
		
	)

	--format "LastActiveModifier = % \n" LastActiveModifier

)


/** addScript #modPanelObjPostChange callback when selection is really changed
  *
  * This method avoid re selection of same object
  *
  *
 */
function selectionChangedModifierActivate =
(
	clearListener()
	print "Callback: SelectionSetChanged()"
	try(callbacks.removeScripts #modPanelObjPostChange id:#watchModifyChange)catch()
	--print GLOBAL_SELECTION_LAST as string
	if( selection.count > 0 ) then
	(
		--format "LastActiveModifier = % \n" LastActiveModifier
		

		if( LastActiveModifier.nodeExists selection[1] ) then
		(
			print "Node Exists"
			--LastActiveModifier.addNode selection[1]
			print "addScript #modPanelObjPostChange selectLastModifier()"
			callbacks.addScript #modPanelObjPostChange "selectLastModifier()" id:#selectLastModifier

		)
		else
		(
			LastActiveModifier.addNode selection[1]
			print "addScript #modPanelObjPostChange watchModifyChange()"
			callbacks.addScript #modPanelObjPostChange "watchModifyChange()" id:#watchModifyChange
			
		)
		
	)
		--GLOBAL_MODIFIER_LAST = for o in selection collect o
	else
	(
		
		print "Deselected objects"
		try(callbacks.removeScripts #modPanelObjPostChange id:#watchModifyChange)catch()

	)

)



callbacks.addScript #selectionSetChanged "selectionChangedModifierActivate()" id:#selectionChangedModifierActivate
--callbacks.removeScripts #modPanelObjPostChange id:#watchModifyChange







































