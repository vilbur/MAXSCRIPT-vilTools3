clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../SceneStateSaveLoader.ms" )	--"./../SceneStateSaveLoader.

/* 
Setup object in isolated layer and store scene state.
Creates layer by object class, assigns object, hides others, saves state.
*/
function setupTestObject obj pos =
(
	obj.pos = pos

    /* get class name */
    obj_class_name = (classof obj as string )

    /* get or create layer */
    layer_mgr = LayerManager
    target_layer = undefined

    for i = 0 to (layer_mgr.count - 1) do
    (
        l = layer_mgr.getLayer i
        if (l.name == obj_class_name) then target_layer = l
    )

    if target_layer == undefined then
    (
        target_layer = layer_mgr.newLayerFromName obj_class_name
    )

    /* assign object to layer */
    target_layer.addNode obj

    /* hide all other objects */
    for o in objects where (o != obj) do
    (
        o.isHidden = true
    )

    /* hide all other layers */
    for i = 0 to (layer_mgr.count - 1) do
    (
        l = layer_mgr.getLayer i
        if (l != target_layer) then
        (
            l.isHidden = true
        )
    )

    /* ensure target layer visible */
    target_layer.isHidden = false
    obj.isHidden = false

    /* create scene state */
    state_name = obj_class_name + "_state"

	/* delete old */ 
    if  sceneStateMgr.FindSceneState state_name > 0 then
        sceneStateMgr.Delete  state_name

    /* create new */
    sceneStateMgr.Capture state_name #{1..10}

   	obj --return

)

if objects.count > 0 then
	resetMaxFile #noPrompt

setupTestObject ( box() )	[ 100,	0, 0]
setupTestObject ( sphere() )	[ -100,	0, 0]

-- USAGE:
--SceneStateSaveLoader = SceneStateSaveLoader_v()

/* SAVE */ 
--SceneStateSaveLoader.save()

/* LAOD */ 
--SceneStateSaveLoader.load()
