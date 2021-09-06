

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
	_obj,
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
		
		_obj = obj
		
		format "nodes = % \n" nodes

	),
	/** Add
	 */
	function saveModifier modifier =
	(
		print "LastActiveModifier_v.saveModifier()"
		_modifier = modifier
		
		--appendIfUnique nodes _obj
		--		clearListener()
		----this.find obj --ret this._getIndexFromBottom()urn
		-- --this._getIndexFromBottom()
		node_index = this.findNode()
		format "node_index = % \n" node_index
		-- format "this._getIndexFromBottom() = % \n" (this._getIndexFromBottom())
		format "this.findNode() = % \n" (this.findNode())
		--modifiers[this.findNode()] = this._getIndexFromBottom()
		format "nodes = % \n" nodes

		if( this._modifierExists node_index ) then 
		(
			print "modifier exists"
			modifiers[node_index]

		)
		else
		(
			print "modifier Dont exists"
			modifiers[node_index] = modifier
		)
		
		
		--format "this.index() = % \n" (this.index())
		--modPanel.setCurrentObject _obj.modifiers[this.index()] ui:true

	),

		
	/** Find object in this.nodes #()
	  *
	  * @return	int	index of object in arrray
	 */
	function findNode =
	(
		findItem nodes _obj --return
	),
	
	/** Mode exists
	 */
	function _modifierExists node_index =
	(
		--print "modeExists()"
		modifiers[node_index] != undefined --return
	),
	
	/** Get index of modifier from modify stack
	 */
	function index =
	(
		modPanel.getModifierIndex _obj _modifier
	),	
	
	/** Get index from bottom
	 */
	function _getIndexFromBottom =
	(
		format "_modifier = % \n" _modifier
		index_current = _obj.modifiers.count + 1 - ( modPanel.getModifierIndex _obj _modifier )

		
		
	),
	
	/** Activate
	 */
	function activate modifier =
	(
		--clearListener()
		print "LastActiveModifier.activate()"
		format "modifier = % \n" modifier
		
		--for mod in obj.modifiers where do
		
		--selection_changed = this.setObj obj
		--format "selection_changed = % \n" selection_changed
		--
		--if( selection_changed ) then 
		--(
		--	--this._setCurrentModifier()
		--	--this._addModifier()
		--	try
		--	(
		--		callbacks.removeScripts #modPanelObjPostChange id:#watchModifyChange
		--	)
		--	catch()
		--print "addScript LastActiveModifier.activate()"
		--
		--	callbacks.addScript #modPanelObjPostChange "watchModifyChange()" id:#watchModifyChange
		--
		--	
		--)
		--format "LastActiveModifier = % \n" LastActiveModifier
		--
	
	),
	
	/** Set obj
	 */
	function selectionChanged obj =
	(
		if( _obj	!= obj ) then
		(
			_obj	= obj
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



/** Wait for valid #modPanelObjPostChange callback
  * #modPanelObjPostChange is fired multiple times with undefined modifier
  *
  *
 */
function watchModifyChange =
(
	print "watchModifyChange()"
	max modify mode
		
--_modifier = modPanel.getCurrentObject()
	--format "_modifier = % \n" _modifier
		
	if( (_modifier = modPanel.getCurrentObject()) != undefined ) then
	(
		print ("Modifier changed " + _modifier as string)
		
		LastActiveModifier.saveModifier _modifier
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
	print "SelectionSetChanged()"
	--print GLOBAL_SELECTION_LAST as string
	if( selection.count > 0 ) then
	(
		--format "LastActiveModifier = % \n" LastActiveModifier
		
		try(callbacks.removeScripts #modPanelObjPostChange id:#watchModifyChange)catch()

		if( LastActiveModifier.nodeExists selection[1] ) then
		(
			print "Node Exists"

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







































