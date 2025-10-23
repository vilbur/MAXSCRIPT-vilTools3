clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../SceneStatesManager.ms" )	--"./../SceneStatesManager.ms"

/*------------------------------------------------------------------------------
	PREPARE SCENE
--------------------------------------------------------------------------------*/

delete objects

-- create a test object
_box = box name:"SceneStateTestBox"

-- move object
--_box.pos = [100,0,0]

-- save first state
--saveSceneState "State_A" ( getSceneStateBits Transform:true )

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



StateMgr = SceneStatesManager_v()

--StateMgr.openDialog()



StateMgr.saveState "position_A" Transform:true

_box.pos = [100,0,0]

StateMgr.saveState "position_B" Transform:true


--sceneStateMgr.CaptureAllParts "TEST STATE"

--parts = sceneStateMgr.GetParts "TEST STATE"

--for i = 1 to 10 do
--(
--	
--	state_name = sceneStateMgr.MapIndexToPart i
--	
--	state_name = substituteString state_name " " ""
--	
--	format "if %	then bits[%]  = true\n" state_name i
----format "%: %\n" i ( sceneStateMgr.MapIndexToPart i )
--	
--)


--StateMgr.addObj _box	"first_set"
--StateMgr.addObj _teapot	"first_set" 
--StateMgr.addObj _shpere	"first_set" replace:true
