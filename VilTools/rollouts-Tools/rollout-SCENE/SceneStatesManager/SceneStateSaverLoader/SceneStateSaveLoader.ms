filein( getFilenamePath(getSourceFileName()) + "/SceneStateSaver/SceneStateSaver.ms" )	--"./SceneStateSaver/SceneStateSaver.ms"
filein( getFilenamePath(getSourceFileName()) + "/SceneStateLoader/SceneStateLoader.ms" )	--"./SceneStateLoader/SceneStateLoader.ms"

/** Scene state save loader
 */
struct SceneStateSaveLoader_v
(
	/* construct */
	work_on_parts = #("Object Properties", "Layer Properties", "Layer Assignment"),
	
	/* required */
	
	
	/* properties */
	valid_parts = #{}, -- bits of states in this.work_on_parts

    temp_dir = (getDir #temp + "\\SceneStateSaveLoader\\"),

	
	/* private */
	/* dependency */

	
	/* reference */
	/* inhered */
	
	
	/** Save
	 */
	function save =
	(
		format "\n"; print "SceneStateSaveLoader_v.save()"
		( SceneStateSaver_v	valid_parts:valid_parts temp_dir:temp_dir ).save()
	),
	
	/** Load
	 */
	function load =
	(
		--format "\n"; print "SceneStateSaveLoader_v.load()"
		--( SceneStateLoader_v	valid_parts:valid_parts temp_dir:temp_dir ).load()
		
		SceneStateLoader = SceneStateLoader_v	valid_parts:valid_parts temp_dir:temp_dir 
		
		SceneStateLoader.load()
	),

	private
	

	/**
	 */
	on create do
	(
		--format "\n"; print "SceneStateSaveLoader.onCreate()"
        ini_files = this._collectIniFiles()
		
		for work_on_part in work_on_parts do
			valid_parts[ sceneStateMgr.MapPartToIndex work_on_part ] = true
	)

)
