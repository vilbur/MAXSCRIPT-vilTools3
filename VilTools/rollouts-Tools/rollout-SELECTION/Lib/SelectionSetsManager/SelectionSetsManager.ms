filein( getFilenamePath(getSourceFileName()) + "/addSelectionSetsToQuadMenu.ms" )	--"./addSelectionSetsToQuadMenu.ms"

/** Selection sets manager
  
	
	NamedSelectionSetManager: https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-6CC6500C-FD5C-4646-A880-BC34E852CA2B
	
	SelectionSet Values: https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-2BBC8C79-6E94-4C93-A491-E0DA5A5E5A0C
  
	SelectionSetArray Values: https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-90C7FC22-30E6-4465-B199-9FF98B275751
  
 */
struct SelectionSetsManager_v
(
	/* construct */
	
	/* required */
	
	/* properties */
	nsm = NamedSelectionSetManager,

	sel_sets, --Dictionary #STRING key:"set_name" value:index of set
	
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
	
	--/** Delete sets
	-- */
	--function deleteSets =
	--(
	--	format "\n"; print "SelectionSetsManager_v.deleteSets()"
	--	this.chooseSetRollout "Delete"
	--),
	--
	--/** Remove from set
	-- */
	--function removeFromSet =
	--(
	--	format "\n"; print "SelectionSetsManager_v.removeFromSet()"
	--	
	--	this.chooseSetRollout "Remove"
	--),
	
	/** Choose set rollout
	 */
	function chooseSetRollout callback selected_sets:undefined =
	(
		format "\n"; print "SelectionSetsManager_v.chooseSetRollout()"
		format "selected_sets: %\n" selected_sets
		sel_sets_by_objects = this.getSetsByObjects ( selection as Array )
		
		case callback as name of
		(
			#ADDTO: (
				for sel_set in sel_sets_by_objects.keys do 
					RemoveDictValue this.sel_sets sel_set

			)
			#REMOVE: this.sel_sets = sel_sets_by_objects
			--default: 
		)
		
		try( destroyDialog rlTestMultiList )catch()
		
		rollout rlTestMultiList "MultiList Exec"
		(
			multilistbox lb_items items:(sort sel_sets.keys) height:sel_sets.keys.count
			
			button bt_exec "FOO" width:80 height:40
			
			on bt_exec pressed do
			(
				selected_items = (for i in lb_items.selection collect lb_items.items[i])
				
				cmd =" (SelectionSetsManager_v())."+bt_exec.text+"Set" + selected_items as string
				--format "cmd: %\n" cmd
				
				execute cmd
				
				addSelectionSetsToQuadMenu()
				
				try( destroyDialog rlTestMultiList )catch()
			)
			
		)
		
		--CreateDialog rlTestMultiList position:mouse.pos --height:(( sel_sets.keys.count * 16 ) + 40 )
		CreateDialog rlTestMultiList position:mouse.pos height:(( sel_sets.keys.count * 16 ) + 48 )
		
		sel_indexes = if selected_sets != undefined then
		(
			if classOf selected_sets != Array then selected_sets = #(selected_sets)
			
			for selected_set in selected_sets where (index = findItem rlTestMultiList.lb_items.items selected_set) > 0 collect index
		)
		else #{}
		
		
		rlTestMultiList.lb_items.selection = sel_indexes
		
		rlTestMultiList.bt_exec.text = callback
	),
	
	/** Add object to set
	 */
	function addObj objs set_name replace:false =
	(
		--format "\n---------------------------------------------\n"
		--format "\n"; print "SelectionSetsManager_v.addObj()"
		
		if classOf objs != Array then objs = #(objs)
		
		/* NEW SET */ 
		if sel_sets[set_name] == undefined then
		(
			this.addNewSet objs set_name

			addSelectionSetsToQuadMenu()
		)
		/* UPDATE SET */ 
		else
			this.updateObjectsInSet objs set_name replace:replace
	),
	
	/** Delete set
	 */
	function deleteSet set_names =
	(
		--format "\n"; print "SelectionSetsManager_v.deleteSet()"
		if classOf set_names != Array then set_names = #(set_names)
		
		for set_name in set_names where sel_sets[set_name] != undefined do
			nsm.RemoveNamedSelSetByIndex sel_sets[set_name]
	),
	
	/** Delete sets
	 */
	function deleteAllSets =
	(
		--format "\n"; print "SelectionSetsManager_v.deleteSets()"
		for set_name in sel_sets.keys do
			nsm.RemoveNamedSelSetByIndex sel_sets[set_name]
	),
	
	/** Remove selection from sets
	 */
	function RemoveSet set_names =
	(
		format "\n"; print "SelectionSetsManager_v.removeSelectionFromSets()"
		--_selection = selection as Array
		if classOf set_names != Array then set_names = #(set_names)

		for set_name in set_names do
		(
			format "set_name: %\n" set_name
			/* REMOVE SELECTED OBJECTS FROM SET */ 
			objs_in_set = for obj in this.getObjectsInSet set_name where not obj.isSelected collect obj
			format "objs_in_set: %\n" objs_in_set
			/* REWRITE SET */ 
			nsm.ReplaceNamedSelSetByName objs_in_set set_name
		)
	),
	
	/** Add to set
	 */
	function addToSet =
	(
		format "\n"; print "SelectionSetsManager_v.addToSet()"
		if classOf set_names != Array then set_names = #(set_names)

		_selection = selection as Array
		
		for set_name in set_names do
		(
			format "set_name: %\n" set_name
			/* REMOVE SELECTED OBJECTS FROM SET */ 
			objs_in_set = for obj in this.getObjectsInSet set_name where not obj.isSelected collect obj
			format "objs_in_set: %\n" objs_in_set
			/* REWRITE SET */ 
			nsm.ReplaceNamedSelSetByName this.getObjectsInSet set_name set_name
		)
		
		
	),
	
	/** Load from ini
	 */
	function loadFromIni =
	(
		--format "\n"; print "SelectionSetsManager_v.loadFromIni()"
		for set_name in getINISetting ini do
		(
			--set_index = selection_sets[set_name]
			--format "set_index: % set_name: %\n\n" set_index set_name
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
		--format "\n"; print "SelectionSetsManager_v.saveToIni()"
		if doesFileExist ini then
			deleteFile ini
		
		/* GET NAME OF SELECTED SETS OR SINGLE SET IT IS SELECTED */ 
		sets_names = if ( selected_set = this.getSelectedSet() ) != undefined then #(selected_set) else sel_sets.keys
		
		for set_name in sets_names do
		(
			--format "set_name: %\n" set_name
			objs_in_set = this.getObjectsInSet set_name

			--for obj in objs_in_set where obj != undefined do
			for obj in objs_in_set do
				if not only_selected \	-- collect all objects if nothing selectded
				or ( only_selected and obj.isSelected ) then
					setINISetting ini set_name obj.name ""
			
		)
		--format "ini: %\n" ini

		msg = "Named Selection Sets\n\nHas been saved"
		
		--format "%:\n%\n" msg ini
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
			--format "set_name: %\n" set_name
			/* GET OBJECTS IN SET */ 
			objs_in_set = this.getObjectsInSet set_name
			--format "objs_in_set: %\n" objs_in_set
			
			for obj in objs while sel_sets_by_obj[set_name] == undefined do
				if findItem objs_in_set obj > 0 then
					sel_sets_by_obj[set_name] = sel_sets[set_name]
		)
		
		sel_sets_by_obj --return
	),
	
	/** Test if all objects of selection set are selected
	  *
	  * @return string|undefined name of selected set
	 */
	function getSelectedSet =
	(
		--format "\n"; print "SelectionSetsManager_v.getSelectedSet()"
		fn compareArrays arr1 arr2 = with PrintAllElements on ( sort(for o in arr1 collect o.name) ) as string == ( sort(for o in arr2 collect o.name) ) as string
		
		selected_set = undefined
		
		_selection = selection as Array
		
		for set_name in sel_sets.keys \
		where _selection.count == (objs_in_set = this.getObjectsInSet set_name).count \
		while selected_set == undefined do
			if compareArrays _selection objs_in_set then
				selected_set = set_name
		
		selected_set --return
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
		objs_in_set = for n = 0 to nsm.GetNamedSelSetItemCount sel_sets[set_name] \
			where ( obj = nsm.GetNamedSelSetItem sel_sets[set_name] n ) != undefined \
				collect obj
		--format "OBJS_IN_SET: %\n" objs_in_set
		objs_in_set --return
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
		--format "\n"; print "SelectionSetsManager_v.updateObjectsInSet()"

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
