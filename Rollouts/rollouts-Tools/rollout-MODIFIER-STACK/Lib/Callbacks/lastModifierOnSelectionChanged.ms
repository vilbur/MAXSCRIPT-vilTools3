

/*------------------------------------------------------------------------------
	SAVE MODIFIER
--------------------------------------------------------------------------------*/

/** 
 */
function saveLastModifierStart =
(
	print "Start: saveLastModifierStart()"
	callbacks.addScript #modPanelObjPostChange "saveLastModifier()" id:#saveLastModifier
)

/** 
 */
function saveLastModifierKill =
(
	print "Kill: saveLastModifierKill()"
	try(callbacks.removeScripts #modPanelObjPostChange id:#saveLastModifier)catch()
)

/** Wait for valid #modPanelObjPostChange callback
  * #modPanelObjPostChange is fired multiple times with undefined modifier
  *
  *
 */
function saveLastModifier =
(
	--print "Callback: saveLastModifier()"
	
	if superClassOf ( modPanel.getCurrentObject() ) == modifier then
		LAST_MODIFIER_SAVER.saveModifier()
)

/* KILL ON STARTUP */ 
saveLastModifierOnSelectionChangedKill()



/*------------------------------------------------------------------------------
	LOAD MODIFIER
--------------------------------------------------------------------------------*/

/** 
 */
function loadLastModifierStart =
(
	print "Start: loadLastModifierStart()"
	callbacks.addScript #selectionSetChanged "loadLastModifier()" id:#loadLastModifier
)

/** 
 */
function loadLastModifierKill =
(
	print "Kill: loadLastModifierKill()"
	try(callbacks.removeScripts #selectionSetChanged id:#loadLastModifier)catch()
)

/** Load last modifier
 */
function loadLastModifier =
(
	format "\n"; print ".loadLastModifier()"
	
	if selection.count == 1 then
	(
		format "LAST_MODIFIER_SAVER.nodes	= % \n" LAST_MODIFIER_SAVER.nodes
		format "LAST_MODIFIER_SAVER.modifiers	= % \n" LAST_MODIFIER_SAVER.modifiers
		
		
	)
	
	
)





