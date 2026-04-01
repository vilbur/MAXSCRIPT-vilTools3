clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../SceneStateLoader.ms" )	--"./../SceneStateLoader.ms"

-- USAGE:
mySceneStates = SceneStateLoader_v()
--mySceneStates.save()
 mySceneStates.load()