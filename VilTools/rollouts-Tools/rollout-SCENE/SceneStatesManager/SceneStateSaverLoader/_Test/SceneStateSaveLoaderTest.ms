clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../SceneStateSaveLoader.ms" )	--"./../SceneStateSaveLoader.ms"





-- USAGE:
mySceneStates = SceneStateSaveLoader_v()
--mySceneStates.save()
 mySceneStates.load()