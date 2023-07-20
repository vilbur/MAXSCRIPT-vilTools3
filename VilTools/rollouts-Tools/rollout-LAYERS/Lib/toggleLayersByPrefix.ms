
/** Toggle layers by prefix
 */
function toggleLayersByPrefix state =
(
	--format "\n"; print ".toggleLayerByPrefix()"
	LayersManager = LayersManager_v()

	selected_layers = LayersManager.getSelectedLayers()

	if selected_layers.count == 0 then
		selected_layers = LayersManager.getLayersByObjects( selection )

	--format "selected_layers = % \n" selected_layers
	--	for layer in selected_layers do
	--		format "layer.name = % \n" layer.name

	if selected_layers.count > 0 do
	(
		layer_name = trimLeft selected_layers[1].name

		matches = ( dotNetClass "System.Text.RegularExpressions.RegEx" ).matches layer_name "^([^A-Za-z]+).*" ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase

		if matches.count > 0 then
			prefix = matches.item[0].groups.item[1].value -- get second item from firs array

		else if (string_split = filterString layer_name "-_ ").count > 0 then
			prefix = string_split[1]
		else
			prefix = layer_name

		format "prefix = % \n" prefix
		matching_layers = LayersManager.getLayers(prefix+"*")

		LayersManager.setVisibility(matching_layers)(state)


	)

)