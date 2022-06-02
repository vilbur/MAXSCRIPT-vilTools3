/* Import sub substructs */
 
/** Selection_v
 */
struct Selection_v
(
	
	Instance = Instance_v parent:this,
	
	function test =
	(
		messagebox "Selection_v.test()"
	),
	/** Get selection of geometry 
	 *	@return	collection	
	 */
	function geometry =
	(
		for o in selection where superclassof o == GeometryClass collect o
	),
	
	/** Select only Unique objects.
	  *	Deselect mutliple instances
	  *
	  * @return	array selection	
	 */
	function filterUniqueObjects =
	(		
		for obj in selection do 
		(
			local obj_instances
			InstanceMgr.GetInstances obj &obj_instances
			format "obj_instances = % \n" obj_instances.count
			
			if( obj_instances.count > 1 ) then
			(
				deleteItem obj_instances (findItem obj_instances obj)
				deselect obj_instances
			)
		)
		selection as Array --return
		
	),
	
	
	
	/** Collapse selection
	  *
	  *
	  * TODO: MOVE THIS METHOD TO EDIT ROLLOUT
	 */
	function collapse =
	(
		for o in this.geometry() do
			maxOps.CollapseNodeTo o 1 off
	),
	/** Set name to objects
	  *
	  * TODO: set auto name by
	  *		1) GROUP
	  *		2) LAYER
	  *		3) SELECTION SET
	  *		4) FILE NAME
	  *
	 */
	function name _name =
	(
		_selection	= this.geometry()
		
		if( _name=="file" ) then
			_name = getFilenameFile maxFileName 
		
		_name	= ( dotNetObject "System.Text.RegularExpressions.Regex" @"[_-]\d+$" ).Replace _name "" -- remove 
		
		if( _selection.count == 1 ) then 
			selection[1].name = _name
		
		else
			for o in _selection do
				o.name = uniqueName _name
	),
	/**  
	 *	
	 */
	function get =
	(
		--print (this.geometry())
		this.geometry() --return
	),
	/**  
	 *	
	 */
	function test =
	(
		messagebox "Selection.test()"
	)
	
	--function Instance_Test_v doSel _selection =
	--(
	--	if classof _selection != array then
	--		_selection = for o in selection where superclassof o == GeometryClass collect o
	--
	--	instances	= #();
	--	unSelInstances	= #();
	--	finSel	= #();
	--
	--	if _selection.count > 0 then
	--	(
	--		for o in _selection do
	--		(
	--			obj_instances
	--			testInst = (InstanceMgr.GetInstances o &obj_instances)
	--			if testInst > 1 then
	--			(
	--				join instances obj_instances
	--	
	--				for inst in instances do
	--				(
	--					if (finditem unSelInstances inst == 0 ) then
	--						appendifunique finSel o
	--
	--					appendifunique unSelInstances inst
	--				)
	--			)
	--			else
	--				appendifunique finSel o
	--		)
	--	)
	---- 		print ("finSel: " + finSel as string)
	--		if doSel == 1 then select	finSel
	--	finSel	
	--)

	
)