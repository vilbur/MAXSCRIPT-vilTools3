
format "START CALLBACK: setCreatePanelOnUnselectedObjects\n"

/** Switch to modify panel when nothing selected
  *	
  *	It switch modify panel to create mode to prevent lag on selection
  */
function setCreatePanelOnUnselectedObjects =
(
   if selection.count == 0 and GetCommandPanelTaskMode() == #MODIFY then max create mode
)

callbacks.removeScripts id:#preventModifyPanelOnSelection

callbacks.addScript #selectionSetChanged "setCreatePanelOnUnselectedObjects()" id:#preventModifyPanelOnSelection