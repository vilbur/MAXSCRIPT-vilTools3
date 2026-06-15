(
	global AlignSelectedToSameName_version
	global alignSameNameStripNumberedLayerSuffix
	global alignSameNameLayerHasNumberedSuffix
	global alignSameNameAppendUnique
	global alignSameNameGetLayerParent
	global alignSameNameGetLayerPathLayers
	global alignSameNameCollectSceneNodes
	global alignSameNameCollectNodeTree
	global alignSameNameCollectNodeLayers
	global alignSameNameFindChildLayerByBaseName
	global alignSameNameMoveMemberNodeLayerToGroupLayer
	global alignSameNameDeleteEmptyTouchedLayers
	global alignSelectedToSameName
	global createAlignSelectedToSameNameTestScene

	AlignSelectedToSameName_version = "0.16"

	/*
	Remove trailing numeric unique suffix from layer name.
	Example: "Foo.001" becomes "Foo".
	*/
	function alignSameNameStripNumberedLayerSuffix layer_name =
	(
		local result_name = layer_name
		local dot_index = 0

		for char_index = layer_name.count to 1 by -1 while (dot_index == 0) do
		(
			if ((substring layer_name char_index 1) == ".") then
			(
				dot_index = char_index
			)
		)

		if ((dot_index > 1) and (dot_index < layer_name.count)) then
		(
			local suffix_text = substring layer_name (dot_index + 1) (layer_name.count - dot_index)
			local suffix_is_number = true

			for suffix_index = 1 to suffix_text.count while (suffix_is_number == true) do
			(
				local suffix_char = substring suffix_text suffix_index 1

				if ((findString "0123456789" suffix_char) == undefined) then
				(
					suffix_is_number = false
				)
			)

			if (suffix_is_number) then
			(
				result_name = substring layer_name 1 (dot_index - 1)
			)
		)

		result_name
		-- return
	)

	/*
	Detect if layer name has trailing numeric unique suffix.
	Example: "Foo.001" returns true.
	*/
	function alignSameNameLayerHasNumberedSuffix layer_name =
	(
		local base_name = alignSameNameStripNumberedLayerSuffix layer_name
		local result_value = (base_name != layer_name)

		result_value
		-- return
	)

	/*
	Append item only when it is not already in array.
	Returns changed array.
	*/
	function alignSameNameAppendUnique target_array item_value =
	(
		if ((findItem target_array item_value) == 0) then
		(
			append target_array item_value
		)

		target_array
		-- return
	)

	/*
	Get layer parent safely.
	Returns undefined when parent is not available.
	*/
	function alignSameNameGetLayerParent layer_item =
	(
		local parent_layer = undefined

		try
		(
			parent_layer = layer_item.getParent()
		)
		catch
		(
			parent_layer = undefined
		)

		parent_layer
		-- return
	)

	/*
	Return full layer path as layer array from current layer to root.
	Used for safe cleanup of touched target layers.
	*/
	function alignSameNameGetLayerPathLayers layer_item =
	(
		local path_layers = #()
		local path_layer = layer_item

		while (path_layer != undefined) do
		(
			alignSameNameAppendUnique path_layers path_layer
			path_layer = alignSameNameGetLayerParent path_layer
		)

		path_layers
		-- return
	)

	/*
	Collect all scene nodes recursively.
	Includes nodes hidden inside groups.
	*/
	function alignSameNameCollectSceneNodes =
	(
		local result_nodes = #()
		local node_stack = #(rootNode)

		while (node_stack.count > 0) do
		(
			local parent_node = node_stack[node_stack.count]
			deleteItem node_stack node_stack.count

			for child_node in parent_node.children do
			(
				append result_nodes child_node
				append node_stack child_node
			)
		)

		result_nodes
		-- return
	)

	/*
	Collect node and all child nodes recursively.
	Used to process group members and protect node names.
	*/
	function alignSameNameCollectNodeTree root_node =
	(
		local result_nodes = #()
		local node_stack = #(root_node)

		while (node_stack.count > 0) do
		(
			local current_node = node_stack[node_stack.count]
			deleteItem node_stack node_stack.count

			if (isValidNode current_node) then
			(
				alignSameNameAppendUnique result_nodes current_node

				for child_node in current_node.children do
				(
					append node_stack child_node
				)
			)
		)

		result_nodes
		-- return
	)

	/*
	Collect layers from node and child nodes.
	Used as read-only source layer protection.
	*/
	function alignSameNameCollectNodeLayers root_node =
	(
		local result_layers = #()
		local node_tree = alignSameNameCollectNodeTree root_node

		for tree_node in node_tree do
		(
			if ((isValidNode tree_node) and (tree_node.layer != undefined)) then
			(
				local node_path_layers = alignSameNameGetLayerPathLayers tree_node.layer

				for node_layer in node_path_layers do
				(
					alignSameNameAppendUnique result_layers node_layer
				)
			)
		)

		result_layers
		-- return
	)

	/*
	Find direct child layer under parent by exact unsuffixed name.
	Already suffixed layers are not accepted as destination layers.
	*/
	function alignSameNameFindChildLayerByBaseName parent_layer base_name exclude_layer:undefined =
	(
		local result_layer = undefined
		local layer_count = LayerManager.count

		for layer_index = 0 to (layer_count - 1) while (result_layer == undefined) do
		(
			local test_layer = LayerManager.getLayer layer_index

			if ((test_layer != undefined) and (test_layer != exclude_layer)) then
			(
				local test_parent_layer = alignSameNameGetLayerParent test_layer

				if ((test_parent_layer == parent_layer) and (test_layer.name == base_name)) then
				(
					result_layer = test_layer
				)
			)
		)

		result_layer
		-- return
	)

	/*
	Move one group member by simple group layer rule.
	Member layers are resolved directly under aligned group head layer.
	*/
	function alignSameNameMoveMemberNodeLayerToGroupLayer member_node group_layer protected_source_layers cleanup_layers =
	(
		local fixed_value = false

		if ((isValidNode member_node) and (group_layer != undefined)) then
		(
			local member_layer = member_node.layer

			if (member_layer != undefined) then
			(
				local member_layer_name = member_layer.name
				local member_base_name = alignSameNameStripNumberedLayerSuffix member_layer_name
				local member_parent_layer = alignSameNameGetLayerParent member_layer
				local existing_layer = alignSameNameFindChildLayerByBaseName group_layer member_base_name exclude_layer:member_layer

				alignSameNameAppendUnique cleanup_layers member_layer
				alignSameNameAppendUnique cleanup_layers member_parent_layer

				if ((member_parent_layer == group_layer) and (member_layer.name == member_base_name)) then
				(
					fixed_value = true
				)

				if ((fixed_value == false) and (existing_layer != undefined)) then
				(
					existing_layer.addNode member_node
					fixed_value = true
				)

				if (fixed_value == false) then
				(
					local layer_is_source = ((findItem protected_source_layers member_layer) > 0)

					if (layer_is_source == false) then
					(
						try
						(
							member_layer.setParent group_layer
						)
						catch
						(
						)

						existing_layer = alignSameNameFindChildLayerByBaseName group_layer member_base_name exclude_layer:member_layer

						if (existing_layer != undefined) then
						(
							existing_layer.addNode member_node
						)
						else if (member_layer.name != member_base_name) then
						(
							try
							(
								member_layer.setName member_base_name
							)
							catch
							(
							)
						)

						fixed_value = true
					)
				)
			)
		)

		fixed_value
		-- return
	)

	/*
	Delete empty layers touched by target processing.
	Protected source layers are never deleted.
	*/
	function alignSameNameDeleteEmptyTouchedLayers layer_candidates protected_source_layers =
	(
		local removed_count = 0

		for layer_item in layer_candidates do
		(
			if (layer_item != undefined) then
			(
				if ((findItem protected_source_layers layer_item) == 0) then
				(
					local layer_nodes = #()

					try
					(
						layer_item.nodes &layer_nodes
					)
					catch
					(
						layer_nodes = #()
					)

					if (layer_nodes.count == 0) then
					(
						local layer_deleted = false

						try
						(
							layer_deleted = LayerManager.deleteLayerByName layer_item.name
						)
						catch
						(
							layer_deleted = false
						)

						if (layer_deleted) then
						(
							removed_count += 1
						)
					)
				)
			)
		)

		removed_count
		-- return
	)

	/*
	Align selected objects to matching unselected masters.
	Master name can be selected object name plus any suffix; classOf and group-head state must match.
	When master is group head, original master group and its members are deleted on success.
	*/
	function alignSelectedToSameName position_tolerance:0.001 rotation_tolerance_degrees:0.001 scale_tolerance:0.0001 show_report:true =
	(
		local version_text = AlignSelectedToSameName_version
		local all_nodes = alignSameNameCollectSceneNodes()
		local selected_nodes_raw = selection as array
		local selected_group_heads = #()
		local selected_nodes = #()
		local success_lines = #()
		local missing_lines = #()
		local ignored_lines = #()
		local used_master_nodes = #()
		local cleanup_layers = #()
		local protected_source_layers = #()
		local result_text = ""
		local invalid_forwarded_name = "No forwarded item name"

		for selected_node in selected_nodes_raw do
		(
			if (isGroupHead selected_node) then
			(
				append selected_group_heads selected_node
			)
		)

		for selected_node in selected_nodes_raw do
		(
			local use_node = true
			local parent_node = selected_node.parent

			while ((parent_node != undefined) and (use_node == true)) do
			(
				if ((findItem selected_group_heads parent_node) > 0) then
				(
					use_node = false
				)

				parent_node = parent_node.parent
			)

			if (use_node) then
			(
				alignSameNameAppendUnique selected_nodes selected_node
			)
			else
			(
				append ignored_lines ("- " + selected_node.name)
			)
		)

		if (selected_nodes.count > 0) then
		(
			select selected_nodes
		)

		if (selected_nodes.count == 0) then
		(
			result_text = "NOT ALIGNED\n-----------"
		)
		else
		(
			undo "Align Selected To Same Name" on
			(
				for target_node in selected_nodes do
				(
					if (isValidNode target_node) then
					(
						local target_original_name = target_node.name
						local target_tree = alignSameNameCollectNodeTree target_node
						local protected_names = #()
						local master_node = undefined
						local target_name = target_original_name
						local target_name_count = target_name.count

						for target_tree_node in target_tree do
						(
							append protected_names target_tree_node.name

							if ((isValidNode target_tree_node) and (target_tree_node.layer != undefined)) then
							(
								local target_path_layers = alignSameNameGetLayerPathLayers target_tree_node.layer

								for target_path_layer in target_path_layers do
								(
									alignSameNameAppendUnique cleanup_layers target_path_layer
								)
							)
						)

						for scene_node in all_nodes do
						(
							if ((isValidNode scene_node) and (scene_node != target_node)) then
							(
								local scene_name = scene_node.name
								local name_match = false

								if (scene_name.count >= target_name_count) then
								(
									if ((substring scene_name 1 target_name_count) == target_name) then
									(
										name_match = true
									)
								)

								if (name_match) then
								(
									if ((classOf scene_node) == (classOf target_node)) then
									(
										if ((isGroupHead scene_node) == (isGroupHead target_node)) then
										(
											if (((findItem selected_nodes_raw scene_node) == 0) and ((findItem used_master_nodes scene_node) == 0)) then
											(
												if (master_node == undefined) then
												(
													master_node = scene_node
												)
												else
												(
													local current_exact = (master_node.name == target_name)
													local new_exact = (scene_name == target_name)
													local use_new_master = false

													if ((new_exact == true) and (current_exact == false)) then
													(
														use_new_master = true
													)
													else if (new_exact == current_exact) then
													(
														if (scene_name.count < master_node.name.count) then
														(
															use_new_master = true
														)
													)

													if (use_new_master) then
													(
														master_node = scene_node
													)
												)
											)
										)
									)
								)
							)
						)

						if (master_node == undefined) then
						(
							append missing_lines ("- " + target_original_name)
						)
						else
						(
							append used_master_nodes master_node

							local source_layers = alignSameNameCollectNodeLayers master_node
							local master_delete_nodes = alignSameNameCollectNodeTree master_node

							for source_layer in source_layers do
							(
								alignSameNameAppendUnique protected_source_layers source_layer
							)

							target_node.transform = master_node.transform

							if (master_node.layer != undefined) then
							(
								master_node.layer.addNode target_node
							)

							if (isGroupHead target_node) then
							(
								local target_group_layer = target_node.layer
								local target_member_tree = alignSameNameCollectNodeTree target_node

								for target_member_node in target_member_tree do
								(
									if ((isValidNode target_member_node) and (target_member_node != target_node)) then
									(
										alignSameNameMoveMemberNodeLayerToGroupLayer target_member_node target_group_layer protected_source_layers cleanup_layers
									)
								)
							)

							for delete_node in master_delete_nodes do
							(
								if (isValidNode delete_node) then
								(
									delete delete_node
								)
							)

							for protected_index = 1 to target_tree.count do
							(
								local protected_node = target_tree[protected_index]
								local protected_name = protected_names[protected_index]

								if ((isValidNode protected_node) and (protected_node.name == invalid_forwarded_name) and (protected_name != invalid_forwarded_name)) then
								(
									protected_node.name = protected_name
								)
							)

							append success_lines ("- " + target_original_name)
						)
					)
				)

				if (success_lines.count > 0) then
				(
					alignSameNameDeleteEmptyTouchedLayers cleanup_layers protected_source_layers
				)
			)

			result_text = ""

			if (success_lines.count > 0) then
			(
				result_text += "ALIGNED\n"
				result_text += "-------\n"

				for line_text in success_lines do
				(
					result_text += line_text + "\n"
				)
			)

			if (missing_lines.count > 0) then
			(
				if (success_lines.count > 0) then
				(
					result_text += "\n"
				)

				result_text += "NOT ALIGNED\n"
				result_text += "-----------\n"

				for line_text in missing_lines do
				(
					result_text += line_text + "\n"
				)
			)
		)

		if (ignored_lines.count > 0) then
		(
			if (result_text != "") then
			(
				result_text += "\n"
			)

			result_text += "IGNORED\n"
			result_text += "-------\n"

			for line_text in ignored_lines do
			(
				result_text += line_text + "\n"
			)
		)

		if (result_text == "") then
		(
			result_text = "NOT ALIGNED\n-----------"
		)

		if (show_report) then
		(
			messageBox result_text title:("Align Selected To Same Name v" + version_text)
		)

		print result_text

		result_text
		-- return
	)

	/*
	Create test scene for alignSelectedToSameName.
	Includes group member layer following group head.
	*/
	function createAlignSelectedToSameNameTestScene =
	(
		delete objects

		local source_root_layer = LayerManager.newLayerFromName "DWG"
		local source_group_layer = LayerManager.newLayerFromName "group_layer"
		local source_member_layer = LayerManager.newLayerFromName "members_layer"
		local target_root_layer = LayerManager.newLayerFromName "0"
		local target_group_layer = LayerManager.newLayerFromName "group_layer.001"
		local target_member_layer = LayerManager.newLayerFromName "members_layer.001"
		local target_unique_member_layer = LayerManager.newLayerFromName "members_layer_unique"
		local source_box_layer = LayerManager.newLayerFromName "ALIGN_TEST_BOX_LAYER"
		local target_box_layer = LayerManager.newLayerFromName "ALIGN_TEST_BOX_LAYER.001"

		try
		(
			source_group_layer.setParent source_root_layer
			source_member_layer.setParent source_group_layer
			target_group_layer.setParent target_root_layer
			target_member_layer.setParent target_group_layer
			target_unique_member_layer.setParent target_group_layer
		)
		catch
		(
		)

		/* Box test: selected box moves to master layer and old master is deleted. */
		local master_box = box name:"ALIGN_TEST_OBJECT_oldMaster" pos:[100,0,0] width:20 length:20 height:20
		master_box.rotation = eulertoquat (eulerAngles 0 0 45)
		master_box.scale = [2.0,1.5,1.0]
		source_box_layer.addNode master_box

		local new_box = box name:"ALIGN_TEST_OBJECT" pos:[0,0,0] width:20 length:20 height:20
		target_box_layer.addNode new_box

		/* Group test: member layers resolve directly under final group layer, old master group and members are deleted. */
		local master_group_member_a = box name:"ALIGN_TEST_MASTER_GROUP_MEMBER_A" pos:[300,300,0] width:20 length:20 height:20
		local master_group_member_b = box name:"ALIGN_TEST_MASTER_GROUP_MEMBER_B" pos:[330,300,0] width:20 length:20 height:20
		local master_group = group #(master_group_member_a, master_group_member_b) name:"ALIGN_TEST_GROUP_old"
		master_group.pos = [300,300,50]
		master_group.rotation = eulertoquat (eulerAngles 0 0 30)
		master_group.scale = [1.5,1.5,1.5]
		source_group_layer.addNode master_group
		source_member_layer.addNode master_group_member_a
		source_member_layer.addNode master_group_member_b

		local new_group_member_a = box name:"ALIGN_TEST_NEW_GROUP_MEMBER_A" pos:[-300,-300,0] width:20 length:20 height:20
		local new_group_member_b = box name:"ALIGN_TEST_NEW_GROUP_MEMBER_B" pos:[-330,-300,0] width:20 length:20 height:20
		local new_group = group #(new_group_member_a, new_group_member_b) name:"ALIGN_TEST_GROUP"
		new_group.pos = [-300,-300,0]
		new_group.rotation = eulertoquat (eulerAngles 0 0 0)
		new_group.scale = [1.0,1.0,1.0]
		target_group_layer.addNode new_group
		target_member_layer.addNode new_group_member_a
		target_unique_member_layer.addNode new_group_member_b

		/* Wrong class test: prefix match exists, but classOf is different. */
		local wrong_class_master = sphere name:"ALIGN_TEST_WRONG_CLASS_old" pos:[200,0,0] radius:20
		local new_wrong_class = box name:"ALIGN_TEST_WRONG_CLASS" pos:[0,100,0] width:20 length:20 height:20
		source_box_layer.addNode wrong_class_master
		target_box_layer.addNode new_wrong_class

		/* Missing master test. */
		local missing_new = box name:"ALIGN_TEST_MISSING" pos:[0,200,0] width:20 length:20 height:20
		target_box_layer.addNode missing_new

		select #(new_box, new_group, new_group_member_a, new_group_member_b, new_wrong_class, missing_new)

		alignSelectedToSameName()

		"Test scene created and alignSelectedToSameName executed."
		-- return
	)
)
