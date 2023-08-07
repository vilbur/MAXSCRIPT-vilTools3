/** Execute Loop Tool Operation From https://help.autodesk.com/view/3DSMAX/2024/ENU/?guid=GUID-C1D508AB-A3E5-4965-AAE3-4FA5EC48CA75
  *
  * If Ctrl pressed, then autoloop is used
  */
function executeEpolyLoopTool macro =
(
	format "\n"; print "executeEpolyOperation.ms.executeEpolyOperation()"

	command = "PolyToolsModeling." + macro + " " + keyboard.altPressed as string

	/* If #StraightLoop and Alt pressed then spaceLoop argument is used too */
	if macro == "StraightLoop" then
		command += " " + keyboard.altPressed as string

	--format "command:	% \n" command
	execute( command )
)