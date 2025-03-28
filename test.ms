clearListener(); print("Cleared in:\n"+getSourceFileName())




/** Reinstance modifier
 */
function reinstanceModifier _objects _modifier =
(
	format "\n"; print ".reinstanceModifier()"
	format "_modifier: %\n" _modifier
	fn compareArrays arr1 arr2 = with printAllElements on ( sort(arr1) ) as string == ( sort(arr2) ) as string
	
	--max modify mode
	max create mode

	pointers_objs =  (for obj in _objects collect (getHandleByAnim obj) as string )
	
		
	--instances = sort( for obj in refs.dependentNodes(_modifier) where obj.modifiers[_modifier.name] == _modifier collect (getHandleByAnim obj) as string )
	pointers_mods = ( for obj in refs.dependentNodes(_modifier) where obj.modifiers[_modifier.name] == _modifier collect (getHandleByAnim obj) as string )
	
	
	format "pointers_mods: %\n" (sort(pointers_mods))
	format "pointers_objs: %\n" (sort(pointers_objs))

	
	--format "compareArrays: %\n" ( compareArrays pointers_objs pointers_mods )
	
	all_mods_of_instance_selected = compareArrays (pointers_objs) (pointers_mods)
	
	format "all_mods_of_instance_selected: %\n" all_mods_of_instance_selected
	
	if not ( compareArrays (pointers_objs) (pointers_mods) ) then
	(
		
		source_obj	= _objects[1]

		for_replace = deleteItem _objects 1
		
		source_mod = source_obj.modifiers[_modifier.name]
		format "source_obj: %\n" source_obj
		format "source_mod: %\n" source_mod
		
		index_source	= modPanel.getModifierIndex source_obj source_mod
		--index_source = getModifierIndex source_obj _modifier
		format "index_source: %\n" index_source
		
		/* MAKE MODIFIERS UNIQUE */ 
		--InstanceMgr.MakeModifiersUnique source_obj source_mod #individual -- {#prompt|#individual|#group}
		
		
		/* REINSTANCE MODIIFER */ 
		for i = 1 to for_replace.count do
		(
			format "\n"
			target_obj	= for_replace[i]
			target_mod	= target_obj.modifiers[_modifier.name]
			index_target	= modPanel.getModifierIndex target_obj target_mod

			/* MAKE MODIFIERS UNIQUE */ 
			--InstanceMgr.MakeModifiersUnique target_obj target_mod #individual -- {#prompt|#individual|#group}
		
			--format "TARGET_OBJ:  %\n" target_obj
			--format "target_mod:  %\n" target_mod
			format "index_target: %\n" index_target
			--
			try(
			
				addModifierWithLocalData target_obj source_mod source_obj source_mod before:index_target
				
				deleteModifier target_obj index_target					
			)
			catch
			(
				format "\n************ EXCEPTION ************\n%\n***********************************\n" (getCurrentException())
				format "\n**************** EXCEPTION File: % ****************\n\n%\n\n**************************************************************************************************************************************\n" filein_path (getCurrentException())
			)
		
		)
	
		
	)
	
	
)
	

select #($'hand-edit-support-1308', $'hand-edit-support-1343', $'hand-edit-support-1373', $'hand-edit-support-1796', $'hand-edit-support-1817', $'hand-edit-support-1163')
--select #($'hand-edit-support-1308', $'hand-edit-support-1343', $'hand-edit-support-1373', $'hand-edit-support-1796', $'hand-edit-support-1163')
--select #($'hand-edit-support-1308', $'hand-edit-support-1343', $'hand-edit-support-1373', $'hand-edit-support-1796' )


--reinstanceModifier ( selection as Array ) selection[1].modifiers[#BAR_WIDTH]
reinstanceModifier ( selection as Array ) selection[1].modifiers[#EXTEND_TOP]

