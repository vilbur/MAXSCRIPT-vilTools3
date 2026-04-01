clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../SceneStateSaver.ms" )	--"./../SceneStateSaver.ms"

-- USAGE:
mySceneStates = SceneStateSaver_v()
mySceneStates.save()
