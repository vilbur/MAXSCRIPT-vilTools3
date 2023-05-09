


/** Mange Layer States
  *
  * https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_9BF5F52D_105D_46BA_8F24_D6B56529ED99_htm
 */
struct LayerStates_v
(
	
	
	/** get scene states
	 */
	function getSceneStates =
	(
		print "LayerStates_v.getSceneStates()"
		
		for i = 1 to sceneStateMgr.GetCount() collect sceneStateMgr.GetSceneState i
	),
	
	
	/** Set states count
	 */
	function _setStatesCount =
	(
		states_count = sceneStateMgr.GetCount()
	),
	

	on create do
	(
		
	)
)
