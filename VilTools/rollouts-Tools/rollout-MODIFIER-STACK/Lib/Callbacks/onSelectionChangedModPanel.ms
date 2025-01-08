/*------------------------------------------------------------------------------------------------------------------------------------------------------------

	Works on real change of selection and wait for modify panel is ready


	#modPanelObjPostChange fires on every change of modify panel but callback of onSelectionChangedModPanel is called only when object selection is changed


	Sequence of calling functions:

		1) onSelectionChangedModPanel	-- Add callback and start waitOnSelectionChanged()
		2) waitOnSelectionChanged	-- When selection is changed then call isNewSelectionCreated()
		3) isNewSelectionCreated	-- Test if objects are selected or deselected, if selected then waitOnModifiyStackIsReady()
		4) waitOnModifiyStackIsReady	-- It takes some time then modify panel is loaded on new selection
		5) onModifyStackReady	-- When modify stack is ready, then execute callback function
	

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/


global ON_MOD_PANEL_CHANGED_CALLBACKS = #()


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
	
	CALLBACKMANAGER.start "isNewSelectionCreated" 
)

/** Kill event onSelectionChangedModPanel()
 */
function onSelectionChangedModPanelKill callbackFn =
(
	--format "\n"; print (".onSelectionChangedModPanelKill(\""+callbackFn+"\")")
	--format "ON_MOD_PANEL_CHANGED_CALLBACKS: %\n" ON_MOD_PANEL_CHANGED_CALLBACKS
	--format "index: %\n" (findItem ON_MOD_PANEL_CHANGED_CALLBACKS callbackFn)
	
	if (index = findItem ON_MOD_PANEL_CHANGED_CALLBACKS callbackFn) > 0 then
		deleteItem ON_MOD_PANEL_CHANGED_CALLBACKS index

	if ON_MOD_PANEL_CHANGED_CALLBACKS.count == 0 then
		CALLBACKMANAGER.kill "isNewSelectionCreated" 
)