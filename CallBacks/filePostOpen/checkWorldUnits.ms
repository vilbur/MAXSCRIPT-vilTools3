/**
 * https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_C1F6495F_5831_4FC8_A00C_667C5F2EAE36_htm
 */
function checkWorldUnitsCallback =
(
	print "Start: checkWorldUnits()"
	try( callbacks.addScript #filePostOpen "checkWorldUnits()" id:#checkWorldUnits )catch()
)


/** 
 */
function checkWorldUnitsKill =
(
	print "Kill: checkWorldUnits()"
	try( callbacks.removeScripts #filePostOpen id:#checkWorldUnits )catch()
)


/** 
 */
function checkWorldUnits =
(
	--print "checkWorldUnits()"
	
	if findItem #(#Inches, #Feet, #Miles) units.SystemType > 0 then 
		messageBox ( "System unit is set to "+ toUpper(units.SystemType as string) + "\n\nUnreal Engine may has problem with scale" ) title:"IMPERIAL UNITS WARNING"  beep:false
	
)