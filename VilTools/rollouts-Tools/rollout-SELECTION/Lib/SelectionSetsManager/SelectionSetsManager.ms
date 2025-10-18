/** Selection sets manager
  
  https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-6CC6500C-FD5C-4646-A880-BC34E852CA2B
  
 */
struct SelectionSetsManager_v
(
	/* construct */
	
	/* required */
	
	/* properties */
	nsm = NamedSelectionSetManager,

	sel_sets, --Dictionary #STRING key:"set_name" value:index
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	/** Open dialog
	 */
	function openDialog =
	(
		--format "\n"; print "SelectionSetsManager_v.openDialog()"
		macros.run "Edit" "namedSelSets"
	),
	/** Add object to set
	 */
	function addObj objs set_name replace:false =
	(
		format "\n---------------------------------------------\n"
		format "\n"; print "SelectionSetsManager_v.addObj()"
		
		if classOf objs != Array then objs = #(objs)
		
		/* NEW SET */ 
		if sel_sets[set_name] == undefined then
			this.addNewSet objs set_name
		/* UPDATE SET */ 
		else
			this.updateObjectsInSet objs set_name replace:replace
	),
	
	/** Get selection set
	 */
	function getSelectionSet set_name =
	(
		--format "\n"; print "SelectionSetsManager_v.getSelectionSet()"
		
	),
	
	/** Get objects in set
	 */
	function getObjectsInSet set_name =
	(
		--format "\n"; print "SelectionSetsManager_v.getObjectsInSet()"
		for n = 0 to nsm.GetNamedSelSetItemCount sel_sets[set_name] collect
			nsm.GetNamedSelSetItem sel_sets[set_name] n 
	),
	
	private
	
	/** Add new set
	 */
	function addNewSet objs set_name  =
	(
		--format "\n"; print "SelectionSetsManager_v.addNewSet()"
		nsm.AddNewNamedSelSet objs set_name

		this.setSelectionSets()
	),
	
	/** Update objects in st
	 */
	function updateObjectsInSet objs set_name replace:false =
	(
		format "\n"; print "SelectionSetsManager_v.updateObjectsInSet()"

		if not replace then
		(
			objs_in_set = this.getObjectsInSet set_name
			
			objs = makeUniqueArray( objs_in_set + objs )
		)

		nsm.ReplaceNamedSelSetByName objs set_name
	),
	
	
	/** Get selection sets
	 */
	function setSelectionSets =
	(
		--format "\n"; print "SelectionSetsManager_v.setSelectionSets()"
		this.sel_sets = Dictionary #STRING
		
		for i = 0 to nsm.GetNumNamedSelSets() -1 do
			this.sel_sets[nsm.GetNamedSelSetName i] = i
	),

	/**
	 */
	on create do
	(
		this.setSelectionSets()
		--format "\n"; print "SelectionSetsManager.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
