/* Import sub substructs */

/** Selection_v
 */
struct Selection_v
(

	/** Get instances
	  *
	  * @param	node	obj	for finding instances
	  * @param	boolean	visible	if true only visible objects are returned
	  *
	  * @param	#ALL|#INSTANCE|#REFERENCE type mode for selecting instances or references
	  * 	#All:	Default, get instances & references of obj
	  * 	#INSTANCE:	Get only instances  of obj without references
	  * 	#REFERENCE:	Get only references of obj without instances
	 */
	function getInstances obj type:#ALL visible:false  =
	(
		--format "\n"; print "Selection_v.getInstances()"
		--instances = #()

		InstanceMgr.GetInstances obj &instances

		result = case type of
		(
			#INSTANCE:	this._getReferences obj instances true --return
			#REFERENCE:	this._getReferences obj instances false --return
			default:	instances --return
		)

		if visible == true then
			for o in result where o.isHidden == false do deleteItem result (findItem result o )  --return

		result --return

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


	/** Get selection of geometry
	 *	@return	collection
	 */
	function geometry =
	(
		for o in selection where superclassof o == GeometryClass collect o
	),


	private


	/** Get references
	 */
	function _getReferences obj instances test =
	(
		--format "\n"; print "Selection_v._getReferences()"
		references = #()

		for _instance in instances where  (areNodesInstances obj _instance) == test  do
			appendIfUnique references _instance

		references --return
	),

	/**
	 */
	on create do
	(
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)
)