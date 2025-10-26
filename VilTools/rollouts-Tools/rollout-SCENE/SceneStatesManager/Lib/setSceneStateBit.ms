
--global SCENE_STATE_BITS = BitArray 10
global SCENE_STATE_BITS

/** Set scene state bit
  
   Callback for 
 */
function setSceneStateBit _bit =
(
	format "\n"; print ".setSceneStateBit()"
	format "_bit: %\n" _bit
	ini = Ini_v(getDir #TEMP + "\\ini_files\\SCENE_STATE_BITS.ini" )
	format "INI: %\n" (Ini.getPath())

    
    -- return result_string
	SCENE_STATE_BITS = ini.load "_section" "SCENE_STATE_BITS" default:( BitArray 10 ) 
	
	if _bit != undefined then
	(
		SCENE_STATE_BITS[_bit] = not SCENE_STATE_BITS[_bit]
		
		ini.save "_section" "SCENE_STATE_BITS" SCENE_STATE_BITS
	)
)
