clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../SceneStateSaveLoader.ms" )	--"./../SceneStateSaveLoader.

/* 
	Setup object in isolated layer and store scene state.
	Creates layer by object class, assigns object, hides others, saves state.
*/
function setupTestObject obj pos =
(
	obj.pos = pos

	obj.wirecolor = color (random 0 255) (random 0 255) (random 0 255)

    target_layer = LayerManager.newLayerFromName ((classof obj) as string )

    /* assign object to layer */
    target_layer.addNode obj
)

/** Create scene states
 */
function createSceneStates objs =
(
	for obj in objs do
	(
		/* hide all other objects */
		for o in objects where (o != obj) do
			o.isHidden = true
	
		/* hide all other layers */
		for i = 0 to (LayerManager.count - 1) do
		(
			l = LayerManager.getLayer i
			if (l != obj.layer) then
				l.isHidden = true
		)
	
		/* ensure target layer visible */
		obj.layer.isHidden = false
		obj.isHidden = false
	
		/* create scene state */
		state_name = ( classof obj ) as string + "-state"
		format "state_name: %\n" state_name
		/* delete old */ 
		if  sceneStateMgr.FindSceneState state_name > 0 then
			sceneStateMgr.Delete  state_name
	
		/* create new */
		sceneStateMgr.Capture state_name #{3,6,7}
		
	)
)

/* 
Reset scene states, unhide all objects and layers
Works for Editable Poly / Edit Poly scenes safely
*/
function resetSceneVisibilityAndStates =
(
    /* 1) remove all scene states */
    local state_count = sceneStateMgr.GetCount()
    for i = state_count to 1 by -1 do
    (
        local state_name = sceneStateMgr.getSceneState i
        sceneStateMgr.Delete  state_name
    )
    
    /* 2) unhide all objects */
    for obj in objects do
    (
        obj.isHidden = false
    )
    
    /* 3) unhide all layers */
    local layer_count = LayerManager.count
    for i = 0 to (layer_count - 1) do
    (
        local lay = LayerManager.getLayer i
        lay.isHidden = false
    )
)

/*==============================================================================

	PREPARE SCENE
	
================================================================================*/

resetMaxFile #noPrompt


/* CREATE OBJECTS */ 
objs = #( box(), sphere(), cylinder() )


/* CREATE LAYERS */ 
for i = 1 to objs.count do
	setupTestObject objs[i]	[ 50 * i,	0, 0]


/* CREATE SCENE STATES */ 
createSceneStates(objs)


/*==============================================================================

	RUN TESTS

================================================================================*/

SceneStateSaveLoader = SceneStateSaveLoader_v()

/*------------------------------------------------------------------------------
	SAVE
--------------------------------------------------------------------------------*/
SceneStateSaveLoader.save()


/*------------------------------------------------------------------------------
	LOAD
------------------------------------------------------------------------------*/

/* SOFT RESET BEFORE LOAD */ 
resetSceneVisibilityAndStates()


/* LOAD SCENE STATES */ 
SceneStateSaveLoader.load()
