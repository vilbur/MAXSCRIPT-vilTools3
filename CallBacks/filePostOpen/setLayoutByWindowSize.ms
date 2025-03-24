/**
 * https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_C1F6495F_5831_4FC8_A00C_667C5F2EAE36_htm
 */
function setLayoutByWindowSizeCallback =
(
	print "Start: setLayoutByWindowSize()"
	try( callbacks.addScript #filePostOpen "setLayoutByWindowSize()" id:#setLayoutByWindowSize )catch()
)


/** 
 */
function setLayoutByWindowSizeKill =
(
	print "Kill: setLayoutByWindowSize()"
	try( callbacks.removeScripts #filePostOpen id:#setLayoutByWindowSize )catch()
)


/** 
 */
function setLayoutByWindowSize =
(
	--print "setLayoutByWindowSize()"
	format "!!!!!!!!!!!!!!!!!!!!!!! YES\n"
	--if findItem #(#Inches, #Feet, #Miles) units.SystemType > 0 then 
		--messageBox ( "System unit is set to "+ toUpper(units.SystemType as string) + "\n\nUnreal Engine may has problem with scale" ) title:"IMPERIAL UNITS WARNING"  beep:false

	
)