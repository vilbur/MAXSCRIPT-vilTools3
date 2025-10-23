clearListener(); print("Cleared in:\n"+getSourceFileName())

	/* 
	  Creates bitArray for sceneStateMgr.Capture
	  Parameters correspond to individual scene elements.
	*/
	
	function getSceneStateBits Materials:false Visibility:false Transform:false ObjectProperties:false LayerState:false Environment:false RenderSettings:false Cameras:false Lights:false Selection:false DisplayMode:false Background:false Effects:false Atmospherics:false = 
	(
		bits = bitArray 14
	
		if Materials        then bits[1]  = true
		if Visibility       then bits[2]  = true
		if Transform        then bits[3]  = true
		if ObjectProperties then bits[4]  = true
		if LayerState       then bits[5]  = true
		if Environment      then bits[6]  = true
		if RenderSettings   then bits[7]  = true
		if Cameras          then bits[8]  = true
		if Lights           then bits[9]  = true
		if Selection        then bits[10] = true
		if DisplayMode      then bits[11] = true
		if Background       then bits[12] = true
		if Effects          then bits[13] = true
		if Atmospherics     then bits[14] = true
	
		bits -- return
	)

/* 
Save Scene State with given name



*/
function saveSceneState state_name state_bits = 
(
	
	--index = sceneStateMgr.FindSceneState state_name
    if ( index = sceneStateMgr.FindSceneState state_name) == 0 then
        sceneStateMgr.Capture state_name state_bits
--    (
		--format "index: %\n" index
--    )
--    else
--    (
--        format "Scene State '%'\n already exists.\n" state_name
--    )
-- return
)

/* 
Load Scene State with given name
*/
function loadSceneState state_name = 
(
    local state_index = sceneStateMgr.getSceneStateIndex state_name
    if state_index != -1 then
    (
        sceneStateMgr.restoreSceneState state_name
    )
    else
    (
        format "Scene State '%'\n not found.\n" state_name
    )
-- return
)

delete objects

-- create a test object
_box = box name:"SceneStateTestBox"

-- move object
_box.pos = [100,0,0]

-- save first state
saveSceneState "State_A" ( getSceneStateBits Transform:true )

---- move object again
--_box.pos = [200,0,0]
--
---- save second state
--saveSceneState "State_B"
--
---- now restore first state
--loadSceneState "State_A"
--
---- check position
--format "Current Position: %\n" _box.pos
--
---- now restore second state
--loadSceneState "State_B"
--
---- check position
--format "Current Position: %\n" _box.pos
--
--

/*
Get array of all Scene State names in scene
*/
function getSceneStateNames =
(
    local names_array = #()
    local count = sceneStateMgr.GetCount()
	format "count: %\n" count
	
    for i = 1 to count do
    (
        --append names_array (sceneStateMgr.getSceneStateName i)
        append names_array (sceneStateMgr.GetSceneState  i)
    )
    
    names_array
-- return
)

-- list all scene state names
all_states = getSceneStateNames()
format "Scene States in Scene: %\n" all_states

