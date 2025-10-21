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
	
	ini = getDir #TEMP + "\\named-selection-sets.ini",

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
	
	/** Delete set
	 */
	function deleteSet set_name =
	(
		--format "\n"; print "SelectionSetsManager_v.deleteSet()"
		if sel_sets[set_name] != undefined then
			nsm.RemoveNamedSelSetByIndex sel_sets[set_name]
	),
	
	/** Delete sets
	 */
	function deleteSets =
	(
		--format "\n"; print "SelectionSetsManager_v.deleteSets()"
		for set_name in sel_sets.keys do
			nsm.RemoveNamedSelSetByIndex sel_sets[set_name]
	),
	
	/** Load from ini
	 */
	function loadFromIni =
	(
		format "\n"; print "SelectionSetsManager_v.loadFromIni()"
		for set_name in getINISetting ini do
		(
			--set_index = selection_sets[set_name]
			format "set_index: % set_name: %\n\n" set_index set_name
			objs = for obj_name in getINISetting ini set_name \
						where (obj = getNodeByName obj_name ) != undefined \
							collect obj
			
			this.addObj objs set_name replace:false
		)
	),
	
	/** Save to ini
	 */
	function saveToIni only_selected:false =
	(
		format "\n"; print "SelectionSetsManager_v.saveToIni()"
		if doesFileExist ini then
			deleteFile ini
		
		for set_name in sel_sets.keys do
		(
			format "set_name: %\n" set_name
			objs_in_set = this.getObjectsInSet set_name

			--for obj in objs_in_set where obj != undefined do
			for obj in objs_in_set do
				if not only_selected \	-- collect all objects if nothing selectded
				or ( only_selected and obj.isSelected ) then
					setINISetting ini set_name obj.name ""
			
		)
		--format "ini: %\n" ini

		msg = "Named Selection Sets\n\nHas been saved"
		
		format "%:\n%\n" msg ini
	),
	
	/** Get sets by objects
	 */
	function getSetsByObjects objs =
	(
		--format "\n"; print "SelectionSetsManager_v.getSetsByObjects()"
		if classOf objs != Array then objs = #(objs)

		sel_sets_by_obj	= Dictionary #STRING -- KEY:set_name VALUE:index
		
		
		for set_name in sel_sets.keys while sel_sets_by_obj[set_name] == undefined do
		(
			objs_in_set = this.getObjectsInSet set_name
			
			for obj in objs while sel_sets_by_obj[set_name] == undefined do 
				sel_sets_by_obj[set_name] = sel_sets[set_name] -- assign index of set
			
		)
		
		sel_sets_by_obj --return
	),
	
	/** Open ini le
	 */
	function openIniLe =
	(
		--format "\n"; print "SelectionSetsManager_v.openIniLe()"
		ShellLaunch ini ""
	),
	
	/** Get objects in set
	 */
	function getObjectsInSet set_name =
	(
		--format "\n"; print "SelectionSetsManager_v.getObjectsInSet()"
		for n = 0 to nsm.GetNamedSelSetItemCount sel_sets[set_name] \
			where ( obj = nsm.GetNamedSelSetItem sel_sets[set_name] n ) != undefined \
				collect obj
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
