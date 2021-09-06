

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
		print ("LastActiveModifier_v.setNode " + _node.name)
		_node = obj
	),
	
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
	function saveModifier current_modifier =
	(
		print "LastActiveModifier_v.saveModifier()"
		format "superClassOf current_modifier = % \n" (superClassOf current_modifier)
		if( superClassOf current_modifier != modifier ) then
			return false

		
		
		_modifier = current_modifier

		modifiers[this.findNode()] = this._getIndexFromBottom( modPanel.getModifierIndex _node _modifier )
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
		
		if( index == undefined ) then
			return false
		
		
		_node.modifiers.count + 1 - ( index )
	),

	/** Activate
	 */
	function activate =
	(
		--clearListener()
		print "LastActiveModifier.activate()"
		format "_node = % \n" _node
		format "_modifier = % \n" _modifier
		format "LastActiveModifier = % \n" LastActiveModifier

		if( _modifier == undefined ) then
			return false

		format "node_index = % \n" (this.findNode())

		index_from_bottom = this._getIndexFromBottom(modifiers[this.findNode()])
		format "index_from_bottom = % \n" index_from_bottom
		modPanel.setCurrentObject _node.modifiers[index_from_bottom] ui:true

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

	/**  
	 */
	on create do
	(
	)

)

global LastActiveModifier = LastActiveModifier_v()



/** addScript #modPanelObjPostChange callback when selection is really changed
  *
  * This method avoid re selection of same object
  *
  *
 */
function selectionChangedModifierActivate =
(
	--clearListener()
	print "Callback: SelectionSetChanged()"
	try(callbacks.removeScripts #modPanelObjPostChange id:#watchModifyChange)catch()
	--print GLOBAL_SELECTION_LAST as string
	if( selection.count == 1 ) then
	(
		obj = selection[1]
		format "LastActiveModifier = % \n" LastActiveModifier
		--try(callbacks.removeScripts #selectionSetChanged id:#selectionChangedModifierActivate)catch()

		if( LastActiveModifier.nodeExists selection[1] ) then
		(
			print "Node exists in LastActiveModifier"
			
			if ( LastActiveModifier.selectionChanged obj ) then -- avoid reselect of same node
			(
				print "SELECTION CHANGED"
				LastActiveModifier.setNode obj
				
				try(callbacks.removeScripts #modPanelObjPostChange id:#watchModifyChange)catch()
				
			)else
				print "RE-SELECT"
				
			callbacks.addScript #modPanelObjPostChange "selectLastActiveModifier()" id:#selectLastActiveModifier

		)
		else
		(
			print "Node Does not exists in LastActiveModifier"

			LastActiveModifier.addNode obj

			callbacks.addScript #modPanelObjPostChange "watchModifyChange()" id:#watchModifyChange
		)

	)
		--GLOBAL_MODIFIER_LAST = for o in selection collect o
	else
	(

		print "DESELECT"
		
		--try(callbacks.removeScripts #modPanelObjPostChange id:#watchModifyChange)catch()
		LastActiveModifier._node = undefined 
	)

)

/** Select last modifier
 */
function selectLastActiveModifier =
(
	print "Callback: selectLastActiveModifier()"
	max modify mode

	if( (_modifier = modPanel.getCurrentObject()) != undefined ) then
	(
		--print ("Stack is ready " + _modifier as string)
		print "Callback: selectLastActiveModifier VALID" 

		format "LastActiveModifier = % \n" LastActiveModifier
		--callbacks.removeScripts #modPanelObjPostChange id:#selectLastActiveModifier
		--try(callbacks.removeScripts #selectionSetChanged id:#selectionChangedModifierActivate)catch()

		LastActiveModifier.setNode selection[1]
		
		try(callbacks.removeScripts #modPanelObjPostChange id:#selectLastActiveModifier)catch()

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

	if( (_modifier = modPanel.getCurrentObject()) != undefined ) then
	(
		print ("Active modifier " + _modifier as string)

		if( LastActiveModifier.modifierExists selection[1] ) then 
			 LastActiveModifier.saveModifier _modifier -- "Modifier exists in LastActiveModifier"
		
		else
			LastActiveModifier.saveModifier _modifier -- "Modifier don`t exists in LastActiveModifier"
			
		--format "LastActiveModifier = % \n" LastActiveModifier
	)

)

try(callbacks.removeScripts #selectionSetChanged id:#selectionChangedModifierActivate)catch()
try(callbacks.removeScripts #modPanelObjPostChange id:#watchModifyChange)catch()
try(callbacks.removeScripts #modPanelObjPostChange id:#selectLastActiveModifier)catch()



callbacks.addScript #selectionSetChanged "selectionChangedModifierActivate()" id:#selectionChangedModifierActivate
--callbacks.removeScripts #modPanelObjPostChange id:#watchModifyChange

