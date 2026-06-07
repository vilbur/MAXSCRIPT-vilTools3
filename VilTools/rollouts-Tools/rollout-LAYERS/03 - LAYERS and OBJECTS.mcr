/**
 */
macroscript	_layers_sort_objects_to_layer
category:	"_Layers-Select"
buttontext:	"Sort OBJ TO LAYERS"
tooltip:	"Sort selected objects to layer with same BASE NAME"
icon:	"across:1|MENU:false"
--autoUndoEnabled:true
(
	on execute do
	(
		/*
		Move nodes to layers matched by object name.
		Case-insensitive, ignores whitespace, dash and underscore delimiters.
		*/
		function moveSelectedObjectsToSameNameLayers nodes:(selection as array) =
		(
			local result_array = #()
			local layer_data_array = #()
			local delimiter_array = #(" ", "\t", "\r", "\n", "-", "_")
			local source_text = ""
			local normalized_text = ""
			local char_text = ""
			local layer_value = undefined
			local layer_mask = ""
			local node_mask = ""
			local match_pos = undefined
			local is_prefix = false
			local best_layer = undefined
			local best_length = 0
			local best_is_prefix = false
			local accept_layer = false
		
			for layer_index = 0 to (LayerManager.count - 1) do
			(
				layer_value = LayerManager.getLayer layer_index
		
				if layer_value != undefined then
				(
					source_text = toLower (layer_value.name as string)
					normalized_text = ""
		
					for char_index = 1 to source_text.count do
					(
						char_text = substring source_text char_index 1
		
						if (findItem delimiter_array char_text) == 0 then
						(
							normalized_text += char_text
						)
					)
		
					if normalized_text.count > 0 then
					(
						append layer_data_array #(layer_value, normalized_text, normalized_text.count)
					)
				)
			)
		
			for node_value in nodes do
			(
				if isValidNode node_value then
				(
					source_text = toLower (node_value.name as string)
					node_mask = ""
		
					for char_index = 1 to source_text.count do
					(
						char_text = substring source_text char_index 1
		
						if (findItem delimiter_array char_text) == 0 then
						(
							node_mask += char_text
						)
					)
		
					best_layer = undefined
					best_length = 0
					best_is_prefix = false
		
					if node_mask.count > 0 then
					(
						for layer_data in layer_data_array do
						(
							layer_value = layer_data[1]
							layer_mask = layer_data[2]
							match_pos = findString node_mask layer_mask
		
							if match_pos != undefined then
							(
								is_prefix = match_pos == 1
								accept_layer = false
		
								if best_layer == undefined then
								(
									accept_layer = true
								)
								else
								(
									if is_prefix and (not best_is_prefix) then
									(
										accept_layer = true
									)
									else if is_prefix == best_is_prefix then
									(
										if layer_data[3] > best_length then
										(
											accept_layer = true
										)
									)
								)
		
								if accept_layer then
								(
									best_layer = layer_value
									best_length = layer_data[3]
									best_is_prefix = is_prefix
								)
							)
						)
					)
		
					if best_layer != undefined then
					(
						best_layer.addNode node_value
						append result_array #(node_value, best_layer, #moved)
						format "Moved: %  ->  Layer: %\n" node_value.name best_layer.name
					)
					else
					(
						append result_array #(node_value, undefined, #noLayerMatch)
						format "No layer match: %\n" node_value.name
					)
				)
			)
		
			result_array -- return
		)
		
		moveSelectedObjectsToSameNameLayers()
		
	)

	--on altExecute type do
	--(
	--	current_layer = (LayersManager_v()).getCurrent()
	--
	--	current_layer.addNodes( selection )
	--)
)

/**
 */
macroscript	_layers_group_objects_by_top_layer
category:	"_Layers-Select"
buttontext:	"Group Objects By Top Layer"
tooltip:	"Group Objects By Top Layer"
icon:	"across:1|MENU:false"
--autoUndoEnabled:true
(
	on execute do
	(
	
		/* Group visible objects by their top parent layer.
		   Group name is the top layer name and group head is added to that top layer. */
		function groupVisibleObjectsByTopLayer include_single_object_groups:true =
		(
			top_layer_array = #()
			grouped_node_array = #()
			created_group_array = #()
		
			for source_node in objects do
			(
				visible_result = false
		
				if (isValidNode source_node) then
				(
					if (((isGroupHead source_node) == false) and (source_node.isHiddenInVpt == false)) then
					(
						visible_result = true
					)
				)
		
				if (visible_result) then
				(
					top_layer = source_node.INodeLayerProperties.layer
					parent_layer = top_layer.getParent()
		
					while (parent_layer != undefined) do
					(
						top_layer = parent_layer
						parent_layer = top_layer.getParent()
					)
		
					found_index = 0
					
					--format "top_layer_array: %\n" top_layer_array
		
					if (top_layer_array.count > 0) then
					(
						for layer_index = 1 to top_layer_array.count do
						(
							if (found_index == 0) then
							(
								if (top_layer_array[layer_index] == top_layer) then
								(
									found_index = layer_index
								)
							)
						)
					)
		
					if (found_index == 0) then
					(
						append top_layer_array top_layer
						append grouped_node_array #(source_node)
					)
					else
					(
						node_group = grouped_node_array[found_index]
						append node_group source_node
						grouped_node_array[found_index] = node_group
					)
				)
			)
		
			undo "Group Visible Objects By Top Layer" on
			(
				for group_index = 1 to top_layer_array.count do
				(
					top_layer = top_layer_array[group_index]
					group_nodes = grouped_node_array[group_index]
		
					if ((group_nodes.count > 1) or include_single_object_groups) then
					(
						try
						(
							group_head = group group_nodes name:top_layer.name select:false
							top_layer.addNode group_head
							append created_group_array group_head
						)
						catch
						(
							format "Group failed for top layer \"%\" with % node(s).\n" top_layer.name group_nodes.count
						)
					)
				)
			)
		
			created_group_array -- return
		)
		
		groupVisibleObjectsByTopLayer()
	
	)
)
	
	