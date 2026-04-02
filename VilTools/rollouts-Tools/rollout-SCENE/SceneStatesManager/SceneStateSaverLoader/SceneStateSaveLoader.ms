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
	ini_files,
	
	validParts_bits = #{}, -- bits of states in this.work_on_parts

    tempDir = (getDir #temp + "\\SceneStateSaveLoader\\"),

	
	/* private */
	/* dependency */

	
	/* reference */
	/* inhered */
	
	
	/** Save
	 */
	function save =
	(
		format "\n"; print "SceneStateSaveLoader_v.save()"
		( SceneStateSaver_v	validParts_bits:validParts_bits tempDir:tempDir ).save()
	),
	
	/** Load
	 */
	function load =
	(
		--format "\n"; print "SceneStateSaveLoader_v.load()"
		--( SceneStateLoader_v	validParts_bits:validParts_bits tempDir:tempDir ).load()
		
		SceneStateLoader = SceneStateLoader_v	validParts_bits:validParts_bits ini_files:ini_files 
		
		SceneStateLoader.load()
	),

	private
	
    /* 
        Collect ini files from temp directory
    */
    function _collectIniFiles =
    (
        result = #()
        files = getFiles (tempDir + "*.ini")

        for f in files do
            append result f

        result -- return
    ),
	

	/**
	 */
	on create do
	(
		--format "\n"; print "SceneStateSaveLoader.onCreate()"
        ini_files = this._collectIniFiles()
		
		for work_on_part in work_on_parts do
			validParts_bits[ sceneStateMgr.MapPartToIndex work_on_part ] = true
	)

)
