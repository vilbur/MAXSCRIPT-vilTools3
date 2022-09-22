/* Import sub substructs */

/** Selection_v
 */
struct Selection_v
(
	/** Get instances of objects
	  *
	  * @param	array|collection	_objects	for finding their instances
	  * @param	boolean	visible	if true only visible objects are returned
	 */
	function getInstances _objects visible:false =
	(
		--format "\n"; print "Selection_v.selectInstances()"
		
		instances = #()
		
		for obj in _objects do
		(	
			local obj_instance
			
			InstanceMgr.GetInstances obj &obj_instance
			
			join instances obj_instance	
		)
		
		if visible == 1 then
			for o in instances where  o.visibility == false do deleteItem instances (findItem instances o )
		
		instances --return
	),
	
	/** Get references
	 */
	function getReferences node1 =
	(
		--format "\n"; print "Selection_v.selectInstances()"
		references = #()

		instances = #()
			
		InstanceMgr.GetInstances node1 &instances
	
		instances = deleteItem instances (findItem instances node1)
	
		--for node2 in instances where not (areNodesInstances node1 node2) and (findItem instances node2) != 0) do
		for node2 in instances where not (areNodesInstances node1 node2)  do
			appendIfUnique references node2
		
		references --return
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
			--format "obj_instances = % \n" obj_instances.count

			if( obj_instances.count > 1 ) then
			(
				deleteItem obj_instances (findItem obj_instances obj)
				deselect obj_instances
			)
		)
		
		selection as Array --return
	),
	
	/** Get selection of geometry 
	 *	@return	collection	
	 */
	function geometry =
	(
		for o in selection where superclassof o == GeometryClass collect o
	),

	/**  
	  *	
	  */
	function areNodesReferences node1 node2 = 
	(
		local instances
		
		InstanceMgr.GetInstances node1 &instances
		
		(node1 != node2) and not (areNodesInstances node1 node2) and (finditem instances node2) != 0
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
	 */
	on create do
	(
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop ) 
	)
)