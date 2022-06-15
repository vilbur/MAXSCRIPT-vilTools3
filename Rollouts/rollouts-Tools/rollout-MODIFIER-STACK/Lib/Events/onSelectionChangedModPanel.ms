/*------------------------------------------------------------------------------
	
	
	Works on real change of selection and wait for modify panel is ready
	
	#modPanelObjPostChange fires on every change of modify panel but callback of onSelectionChangedModPanel is called only when object selection is changed
	
	
	
	Sequence of calling functions:

		1) onSelectionChangedModPanel	-- Add callback and start waitOnSelectionChanged()
		2) waitOnSelectionChanged	-- When selection is changed then call testNewSelection()
		3) testNewSelection	-- Test if objects are selected or deselected, if selected then waitOnModifiyStackIsReady()
		4) waitOnModifiyStackIsReady	-- It takes some time then modify panel is loaded on new selection
		5) onModifyStackReady	-- When modify stack is ready, then execute callback function

--------------------------------------------------------------------------------*/


global ON_MOD_PANEL_CHANGED_CALLBACKS = #()


/*------------------------------------------------------------------------------
	WAIT ON SELECTION CHANGED
--------------------------------------------------------------------------------*/

/** Wait for selection change callback
 */
function waitOnSelectionChanged =
(
	print "Start: waitOnSelectionChanged()"
	callbacks.addScript #selectionSetChanged "testNewSelection()" id:#testNewSelection
)

/** Kill callback
 */
function waitOnSelectionChangedKill =
(
	print "Kill: waitOnSelectionChangedKill()"
	try(callbacks.removeScripts #selectionSetChanged   id:#testNewSelection)catch()	
)


/*------------------------------------------------------------------------------
	ON SELECTION CHANGED
--------------------------------------------------------------------------------*/

/** On selection changed mod panel is updated
  *
  * @property	string	callbackFn	function called on modify panel changed
 */
function onSelectionChangedModPanel callbackFn =
(
	appendIfUnique ON_MOD_PANEL_CHANGED_CALLBACKS callbackFn
	
	waitOnSelectionChanged()
)

/** Kill event onSelectionChangedModPanel()
 */
function onSelectionChangedModPanelKill callbackFn =
(
	--format "\n"; print ".onSelectionChangedModPanel()"
	if (index = findItem ON_MOD_PANEL_CHANGED_CALLBACKS callbackFn) > 0 then
		deleteItem ON_MOD_PANEL_CHANGED_CALLBACKS index
	
	if ON_MOD_PANEL_CHANGED_CALLBACKS.count == 0 then 
		waitOnSelectionChangedKill()
)



/** Wait when modifier stack will be ready
 */
function waitOnModifiyStackIsReady =
(
	print "Start: waitOnModifiyStackIsReady()"
	callbacks.addScript #modPanelObjPostChange "onModifyStackReady()" id:#onModifyStackReady
)

/** 
 */
function waitOnModifiyStackIsReadyKill =
(
	print "Kill: waitOnModifiyStackIsReadyKill()"
	try(callbacks.removeScripts #modPanelObjPostChange id:#onModifyStackReady)catch()
)



/*--------------------------------------------------------------------------------
	TEST SELECTION
--------------------------------------------------------------------------------*/

/** addScript #modPanelObjPostChange callback when selection is really changed
  *
  * This method avoid re selection of same object
  *
  *
 */
function testNewSelection =
(
	--format "\n"; print "Callback: testNewSelection()"
				
	if( selection.count > 0 ) then
	(
		--format "GLOBAL_SELECTION_LAST	= % \n" GLOBAL_SELECTION_LAST
		if( GLOBAL_SELECTION_LAST != selection ) then -- if new selection has been created
		(
			--print "Selection changed"
		
			waitOnModifiyStackIsReady()
			
		) else
		(
			--print "Object reselected"
		)
	)
	else -- if( selection.count == 0 ) then
	(
		--print "DESELECTED ALL"
		
		waitOnModifiyStackIsReadyKill()
	)
)


/*------------------------------------------------------------------------------
		EXECUTE CALLBACKS
--------------------------------------------------------------------------------*/

/** Call callback when mod panel is fully loaded
 */
function onModifyStackReady =
(
	--print "Callback: onModifyStackReady WAIT"
	
	max modify mode

	if( (_modifier = modPanel.getCurrentObject()) != undefined ) then -- current object is undefined than Modify panel is fully loaded
	(
		print "Callback: onModifyStackReady READY"
		
		waitOnModifiyStackIsReadyKill()
		
		for callback in ON_MOD_PANEL_CHANGED_CALLBACKS do 
			execute(callback+"()")
	)
)


/* KILL ON STARTUP */ 
waitOnModifiyStackIsReadyKill()
