clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../ModifyStack.ms" )


/** Create test objets
 */
function createTestObjets =
(
	delete objects
	
	--Box lengthsegs:1 widthsegs:1 heightsegs:1 length:33.8732 width:36.4541 height:38.1323 mapcoords:on pos:[-16.6444,-115.727,0] isSelected:on

	_box = box()
	
	select _box
	
	
	modPanel.addModToSelection (Chamfer ()) ui:on
	
	modPanel.addModToSelection (Edit_Poly ()) ui:on
	
	modPanel.setCurrentObject _box.modifiers[#Edit_Poly]
	
	maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
	select nnl
	move $ [0, 50, 0]
	
	select objects
	
	modPanel.addModToSelection (meshsmooth ()) ui:on -- ADD INSTANCED MODIFIERS
	modPanel.addModToSelection (meshsmooth ()) ui:on

	--modpanel.setPinStack true
	
	deselect selection
	
	redrawViews()
)


/** Mod panel obj post change callback
 */
function selectionSetChangedCallback =
(
	try(callbacks.removeScripts #modPanelObjPostChange id:#modPanelObjPostChangeCallback)catch()
	print "selectionSetChangedCallback"
		--format "modPanelSelChanged.notificationParam() = % \n" (callbacks.notificationParam())
	--print ( modPanel.getCurrentObject() )
		----format "selection = % \n" selection[1] as string  

	if( selection.count > 0 ) then
		--print (getUserProp selection[1] "active-modifier" )
		modPanel.setCurrentObject selection[1].modifiers[#Edit_Poly]
		--setUserProp selection[1] "active-modifier" ( modPanel.getCurrentObject() )
callbacks.addScript #modPanelObjPostChange "modPanelObjPostChangeCallback()" id:#modPanelObjPostChangeCallback

)

function modPanelObjPostChangeCallback =
(
	print "modPanelObjPostChange"
	if ( ( cutrent_obj = modPanel.getCurrentObject() ) != undefined ) then
	(
		print "SAVE PROP"		
		setUserProp selection[1] "active-modifier" ( cutrent_obj )
	)

)

/** Kill callbacks
 */
function killCallbacks =
(
	try(callbacks.removeScripts #SelectionSetChanged id:#selectionSetChangedCallback)catch()
	try(callbacks.removeScripts #modPanelObjPostChange id:#modPanelObjPostChangeCallback)catch()	
)


/** Run callbacks
 */
function runCallbacks =
(
	callbacks.addScript #SelectionSetChanged "selectionSetChangedCallback()" id:#selectionSetChangedCallback
	callbacks.addScript #modPanelObjPostChange "modPanelObjPostChangeCallback()" id:#modPanelObjPostChangeCallback	
)



killCallbacks()
createTestObjets()
runCallbacks()
