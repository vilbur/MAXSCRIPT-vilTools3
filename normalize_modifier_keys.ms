clearListener(); print("Cleared in: "+getSourceFileName())




/*
Normalize quad modifier.
Example: #shiftAndControlAndAltPressed -> "ShiftAltCtrl"
*/
function normalizeQuadModifier modifier_value =
(
	/** Join array to string
	 */
	function arrayToString arr delimeter:"" = ( _string = ""; for item in arr do _string += item as string  + delimeter; substring _string 1 (_string.count-delimeter.count))
	
	valid_mods =  #("shift", "alt", "control", "none")
	
	modifier_string = toLower( modifier_value as string )

	if (matchPattern modifier_string pattern:"*Pressed") then
		modifier_string	= substring modifier_string 1 (( findString modifier_string "Pressed" ) - 1)

	modifier_string = substituteString modifier_string "and" "-"
	
	mod_keys_valid = for mod_key in sort (filterString modifier_string "-") where findItem valid_mods mod_key collect mod_key 

	if ( mod_keys_count = mod_keys_valid.count) > 0 then
	(
		normalized_key = if mod_keys_count > 1 then arrayToString mod_keys_valid else mod_keys_valid[1]

		normalized_mod = case normalized_key of
		(
			"altshift":	#ShiftAndAltPressed
			"altcontrol":	#ControlAndAltPressed
			"controlshift":	#ShiftAndControlPressed
			"altcontrolshift":	#ShiftAndAltAndControlPressed
			
			default: (normalized_key + "Pressed") as name
		)
		normalized_mod --return
	)
)


modifier_names_input = #( #none, #shift, #control, #altPressed, #Controlandshift, #AltandshiftPressed, #controlAndAltPressed, #shiftAndAltAndControlPressed)
modifier_names_valid = #( #nonePressed, #shiftPressed, #controlPressed, #altPressed, #shiftAndControlPressed, #shiftAndAltPressed, #controlAndAltPressed, #shiftAndAltAndControlPressed)


for modifier_name in modifier_names_input do
(
	normalized_mod = normalizeQuadModifier modifier_name
	
	format "%: normalized_mod: %\n" ( findItem modifier_names_valid normalized_mod >0 ) normalized_mod
)
