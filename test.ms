clearListener(); print("Cleared in:\n"+getSourceFileName())

/** Reinstance sweep modifier
  
	USE CASES OF SWEEP MODIFIER ERROR:
		1) If sweep modifier is added more then once
		2) If sweep modifier is tried to add but modifiers above are enabled 
  
	WORKAROUND:
		1) turn of all modifiers above sweep mod
		2) delete old sweep modifier
		3) add new sweep modifier
		4) reneable modifiers above
  
 */
function reinstanceSweepModifier source_obj for_replace _modifier =
(
	format "\n"; print ".reinstanceSweepModifier()"
	
	disbaled_mods	=  Dictionary #INTEGER -- KEY:modifier_index VALUE:#( modifiers )
	
	for target_obj in for_replace do 
	(
		format "\n\n"
		local target_mod
		--local index_target

		/* DISABLE MODIIERS */ 
		for m = 1 to target_obj.modifiers.count where classOf (target_mod = target_obj.modifiers[m]) != sweep and target_mod.enabled do 
		(
			target_mod.enabled = false
			--format "m: %\n" m
			
			if disbaled_mods[m] == undefined then disbaled_mods[m] = #(target_mod) else appendIfUnique disbaled_mods[m] target_mod
		)
		
		index_target	= modPanel.getModifierIndex target_obj target_mod

		/* MAKE MODIFIERS UNIQUE */ 
		--InstanceMgr.MakeModifiersUnique target_obj target_mod #individual -- {#prompt|#individual|#group}
		if index_target != undefined then
		(
			format "target_obj: %\n" target_obj
			format "target_mod:  %\n" target_mod
			format "index_target: %\n" index_target
		
			--try(
				/* DELETE OLD SWEEP MODIFEIR */ 
				deleteModifier target_obj index_target					
				
				/* ADD INSTANCED SWEEP MODIFEIR */ 
				addModifierWithLocalData target_obj source_mod source_obj source_mod before:index_target
			--
			--)
			--catch
			--(
			--	format "\n************ EXCEPTION ************\n%\n***********************************\n" (getCurrentException())
			--	format "\n**************** EXCEPTION File: % ****************\n\n%\n\n**************************************************************************************************************************************\n" filein_path (getCurrentException())
			--)
			
		)
	)
	
	for mod_index in disbaled_mods.keys do
		for disbaled_mod in disbaled_mods[mod_index] do
			disbaled_mod.enabled = true
)


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
		if classOf _modifier != sweep then
		(
			--for i = 1 to for_replace.count do
			for target_obj in for_replace do 
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
				format "CLASSOF TARGET_MOD: %\n" (classOf target_mod)
				
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
		else /* REINSTANCE SWEEP MODIIFER */
			reinstanceSweepModifier source_obj for_replace _modifier
	)
)
	
macros.run "_Scene" "_scene_temp_open"

select #($'hand-edit-support-1308', $'hand-edit-support-1343', $'hand-edit-support-1373', $'hand-edit-support-1796', $'hand-edit-support-1817', $'hand-edit-support-1163')
--select #($'hand-edit-support-1308', $'hand-edit-support-1343', $'hand-edit-support-1373', $'hand-edit-support-1796', $'hand-edit-support-1163')
--select #($'hand-edit-support-1308', $'hand-edit-support-1343', $'hand-edit-support-1373', $'hand-edit-support-1796' )


reinstanceModifier ( selection as Array ) selection[1].modifiers[#BAR_WIDTH]
--reinstanceModifier ( selection as Array ) selection[1].modifiers[#EXTEND_TOP]

