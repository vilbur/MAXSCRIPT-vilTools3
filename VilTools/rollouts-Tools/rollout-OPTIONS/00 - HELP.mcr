/*
Generates markdown help from rollout.
Loops rollout, sub-rollouts, groupboxes and controls.
*/
function generateRolloutMarkdownHelp rollout_value \
	output_path:undefined \
	include_empty_tooltips:false \
	use_colors:true \
	rollout_color:#BLUE \
	nested_rollout_color:#GREEN \
	group_color:#YELLOW \
	control_color:#MAGENTA \
	tooltip_color:#GRAY \
	level:1 \
	markdown_lines:undefined \
	is_child:false =
(
	
	COLOR_NAMES = Dictionary \
	#( 	#GREEN, 		color 90		190		120	) \
	#( 	#RED, 			color 225	95		95	) \
	#( 	#BLUE, 		color 95		150		225	) \

	#( 	#GREEN_LIGHT, 	color 165	225		175	) \
	#( 	#GREEN_DARK, 	color 45		135		95	) \

	#( 	#ORANGE,		color 235	145		70	) \
	#( 	#MAGENTA,		color 205	110		205	) \
	#( 	#PINK, 		color 220	135		165	) \
	#( 	#CYAN, 		color 95		200		220	) \
	#( 	#YELLOW, 		color 230	210		100	) \
	#( 	#BROWN, 		color 160	110		75	) \
	#( 	#GRAY, 		color 145	150		160	) \
	#( 	#GREY, 		color 145	150		160	) \
	#( 	#BLACK, 		color 40		44		52	) \
	#( 	#WHITE, 		color 235	238		245	)

	
	
	if (markdown_lines == undefined) then
	(
		markdown_lines = #()
	)

	if (level < 1) then
	(
		level = 1
	)

	if (level > 6) then
	(
		level = 6
	)

	resolved_rollout_color = rollout_color
	resolved_nested_rollout_color = nested_rollout_color
	resolved_group_color = group_color
	resolved_control_color = control_color
	resolved_tooltip_color = tooltip_color

	if ((classOf resolved_rollout_color) == Name) then
	(
		try
		(
			if (HasDictValue COLOR_NAMES resolved_rollout_color) then
			(
				resolved_rollout_color = COLOR_NAMES[resolved_rollout_color]
			)
		)
		catch()
	)

	if ((classOf resolved_nested_rollout_color) == Name) then
	(
		try
		(
			if (HasDictValue COLOR_NAMES resolved_nested_rollout_color) then
			(
				resolved_nested_rollout_color = COLOR_NAMES[resolved_nested_rollout_color]
			)
		)
		catch()
	)

	if ((classOf resolved_group_color) == Name) then
	(
		try
		(
			if (HasDictValue COLOR_NAMES resolved_group_color) then
			(
				resolved_group_color = COLOR_NAMES[resolved_group_color]
			)
		)
		catch()
	)

	if ((classOf resolved_control_color) == Name) then
	(
		try
		(
			if (HasDictValue COLOR_NAMES resolved_control_color) then
			(
				resolved_control_color = COLOR_NAMES[resolved_control_color]
			)
		)
		catch()
	)

	if ((classOf resolved_tooltip_color) == Name) then
	(
		try
		(
			if (HasDictValue COLOR_NAMES resolved_tooltip_color) then
			(
				resolved_tooltip_color = COLOR_NAMES[resolved_tooltip_color]
			)
		)
		catch()
	)

	rollout_css_color = "#88C0D0"
	nested_rollout_css_color = "#A3BE8C"
	group_css_color = "#EBCB8B"
	control_css_color = "#B48EAD"
	tooltip_css_color = "#9298A3"

	if ((classOf resolved_rollout_color) == Color) then
	(
		rollout_css_color = "rgb(" + ((resolved_rollout_color.r as integer) as string) + "," + ((resolved_rollout_color.g as integer) as string) + "," + ((resolved_rollout_color.b as integer) as string) + ")"
	)
	else
	(
		if ((classOf resolved_rollout_color) == String) then
		(
			rollout_css_color = resolved_rollout_color
		)
	)

	if ((classOf resolved_nested_rollout_color) == Color) then
	(
		nested_rollout_css_color = "rgb(" + ((resolved_nested_rollout_color.r as integer) as string) + "," + ((resolved_nested_rollout_color.g as integer) as string) + "," + ((resolved_nested_rollout_color.b as integer) as string) + ")"
	)
	else
	(
		if ((classOf resolved_nested_rollout_color) == String) then
		(
			nested_rollout_css_color = resolved_nested_rollout_color
		)
	)

	if ((classOf resolved_group_color) == Color) then
	(
		group_css_color = "rgb(" + ((resolved_group_color.r as integer) as string) + "," + ((resolved_group_color.g as integer) as string) + "," + ((resolved_group_color.b as integer) as string) + ")"
	)
	else
	(
		if ((classOf resolved_group_color) == String) then
		(
			group_css_color = resolved_group_color
		)
	)

	if ((classOf resolved_control_color) == Color) then
	(
		control_css_color = "rgb(" + ((resolved_control_color.r as integer) as string) + "," + ((resolved_control_color.g as integer) as string) + "," + ((resolved_control_color.b as integer) as string) + ")"
	)
	else
	(
		if ((classOf resolved_control_color) == String) then
		(
			control_css_color = resolved_control_color
		)
	)

	if ((classOf resolved_tooltip_color) == Color) then
	(
		tooltip_css_color = "rgb(" + ((resolved_tooltip_color.r as integer) as string) + "," + ((resolved_tooltip_color.g as integer) as string) + "," + ((resolved_tooltip_color.b as integer) as string) + ")"
	)
	else
	(
		if ((classOf resolved_tooltip_color) == String) then
		(
			tooltip_css_color = resolved_tooltip_color
		)
	)

	rollout_title = ""
	try
	(
		if (rollout_value.title != undefined) then
		(
			rollout_title = rollout_value.title as string
		)
	)
	catch()

	if (rollout_title == "") then
	(
		try
		(
			rollout_title = rollout_value.name as string
		)
		catch()
	)

	if (rollout_title == "") then
	(
		rollout_title = "Rollout"
	)

	rollout_title = substituteString rollout_title "\r\n" " "
	rollout_title = substituteString rollout_title "\n" " "
	rollout_title = substituteString rollout_title "\r" " "
	rollout_title = substituteString rollout_title "\t" " "
	rollout_title_html = substituteString rollout_title "&" "&amp;"
	rollout_title_html = substituteString rollout_title_html "<" "&lt;"
	rollout_title_html = substituteString rollout_title_html ">" "&gt;"

	header_marker = ""
	for i = 1 to level do
	(
		header_marker += "#"
	)

	if (use_colors) then
	(
		append markdown_lines (header_marker + " <span style=\"color:" + rollout_css_color + "\"><b>" + rollout_title_html + "</b></span>")
	)
	else
	(
		append markdown_lines (header_marker + " " + rollout_title)
	)

	append markdown_lines ""

	control_array = #()
	try
	(
		control_array = rollout_value.controls
	)
	catch()

	group_box_array = #()

	for control_item in control_array do
	(
		class_text = ""
		control_name_text = ""
		is_ignored = false
		is_group_box = false

		try
		(
			class_text = (classOf control_item) as string
		)
		catch()

		try
		(
			control_name_text = control_item.name as string
			control_name_text = substituteString control_name_text "#" ""
		)
		catch()

		if (matchPattern class_text pattern:"*Label*" ignoreCase:true) then
		(
			is_ignored = true
		)

		if (matchPattern class_text pattern:"*ColorPicker*" ignoreCase:true) then
		(
			is_ignored = true
		)

		if (matchPattern class_text pattern:"*Color*Picker*" ignoreCase:true) then
		(
			is_ignored = true
		)

		if (matchPattern control_name_text pattern:"fake*" ignoreCase:true) then
		(
			is_ignored = true
		)

		if (matchPattern class_text pattern:"*GroupBox*" ignoreCase:true) then
		(
			is_group_box = true
		)

		if (is_group_box and not is_ignored) then
		(
			append group_box_array control_item
		)
	)

	control_group_array = #()

	for control_item in control_array do
	(
		class_text = ""
		control_name_text = ""
		is_ignored = false
		is_group_box = false

		try
		(
			class_text = (classOf control_item) as string
		)
		catch()

		try
		(
			control_name_text = control_item.name as string
			control_name_text = substituteString control_name_text "#" ""
		)
		catch()

		if (matchPattern class_text pattern:"*Label*" ignoreCase:true) then
		(
			is_ignored = true
		)

		if (matchPattern class_text pattern:"*ColorPicker*" ignoreCase:true) then
		(
			is_ignored = true
		)

		if (matchPattern class_text pattern:"*Color*Picker*" ignoreCase:true) then
		(
			is_ignored = true
		)

		if (matchPattern control_name_text pattern:"fake*" ignoreCase:true) then
		(
			is_ignored = true
		)

		if (matchPattern class_text pattern:"*GroupBox*" ignoreCase:true) then
		(
			is_group_box = true
		)

		if (not is_group_box and not is_ignored) then
		(
			best_group_box = undefined
			best_group_area = 999999999.0

			control_pos = [0,0]
			control_width = 0
			control_height = 0

			try
			(
				control_pos = control_item.pos
			)
			catch()

			try
			(
				control_width = control_item.width
			)
			catch()

			try
			(
				control_height = control_item.height
			)
			catch()

			control_center_x = control_pos.x + (control_width / 2.0)
			control_center_y = control_pos.y + (control_height / 2.0)

			for group_box in group_box_array do
			(
				group_pos = [0,0]
				group_width = 0
				group_height = 0

				try
				(
					group_pos = group_box.pos
				)
				catch()

				try
				(
					group_width = group_box.width
				)
				catch()

				try
				(
					group_height = group_box.height
				)
				catch()

				if
				(
					control_center_x >= group_pos.x and
					control_center_x <= (group_pos.x + group_width) and
					control_center_y >= group_pos.y and
					control_center_y <= (group_pos.y + group_height)
				)
				then
				(
					group_area = group_width * group_height

					if (group_area < best_group_area) then
					(
						best_group_area = group_area
						best_group_box = group_box
					)
				)
			)

			append control_group_array #(control_item, best_group_box)
		)
	)

	for control_data in control_group_array where control_data[2] == undefined do
	(
		control_item = control_data[1]

		class_text = ""
		try
		(
			class_text = (classOf control_item) as string
		)
		catch()

		is_sub_rollout = false

		if (matchPattern class_text pattern:"*SubRollout*" ignoreCase:true) then
		(
			is_sub_rollout = true
		)

		try
		(
			if (control_item.rollouts != undefined) then
			(
				is_sub_rollout = true
			)
		)
		catch()

		if (is_sub_rollout) then
		(
			sub_rollout_title = ""
			try
			(
				sub_rollout_title = control_item.title as string
			)
			catch()

			try
			(
				if (sub_rollout_title == "") then
				(
					sub_rollout_title = control_item.name as string
					sub_rollout_title = substituteString sub_rollout_title "#" ""
				)
			)
			catch()

			if (sub_rollout_title == "") then
			(
				sub_rollout_title = "Nested Rollout"
			)

			sub_rollout_title_html = substituteString sub_rollout_title "&" "&amp;"
			sub_rollout_title_html = substituteString sub_rollout_title_html "<" "&lt;"
			sub_rollout_title_html = substituteString sub_rollout_title_html ">" "&gt;"

			nested_level = level + 1
			if (nested_level > 6) then
			(
				nested_level = 6
			)

			nested_header_marker = ""
			for i = 1 to nested_level do
			(
				nested_header_marker += "#"
			)

			if (use_colors) then
			(
				append markdown_lines (nested_header_marker + " <span style=\"color:" + nested_rollout_css_color + "\"><b>Nested rollout: " + sub_rollout_title_html + "</b></span>")
			)
			else
			(
				append markdown_lines (nested_header_marker + " Nested rollout: " + sub_rollout_title)
			)

			append markdown_lines ""

			child_rollout_array = #()
			try
			(
				child_rollout_array = control_item.rollouts
			)
			catch()

			for child_rollout in child_rollout_array do
			(
				generateRolloutMarkdownHelp child_rollout \
					include_empty_tooltips:include_empty_tooltips \
					use_colors:use_colors \
					rollout_color:rollout_color \
					nested_rollout_color:nested_rollout_color \
					group_color:group_color \
					control_color:control_color \
					tooltip_color:tooltip_color \
					level:(level + 2) \
					markdown_lines:markdown_lines \
					is_child:true
			)
		)
		else
		(
			control_title = ""
			tooltip_text = ""

			try
			(
				control_title = control_item.text as string
			)
			catch()

			if (control_title == "") then
			(
				try
				(
					control_title = control_item.caption as string
				)
				catch()
			)

			if (control_title == "") then
			(
				try
				(
					control_title = control_item.title as string
				)
				catch()
			)

			if (control_title == "") then
			(
				try
				(
					control_title = control_item.name as string
					control_title = substituteString control_title "#" ""
				)
				catch()
			)

			if (control_title == "") then
			(
				control_title = class_text
			)

			try
			(
				tooltip_text = control_item.tooltip as string
			)
			catch()

			if (tooltip_text == "") then
			(
				try
				(
					tooltip_text = control_item.toolTip as string
				)
				catch()
			)

			control_title = substituteString control_title "\r\n" " "
			control_title = substituteString control_title "\n" " "
			control_title = substituteString control_title "\r" " "
			control_title = substituteString control_title "\t" " "

			tooltip_text = substituteString tooltip_text "\r\n" " "
			tooltip_text = substituteString tooltip_text "\n" " "
			tooltip_text = substituteString tooltip_text "\r" " "
			tooltip_text = substituteString tooltip_text "\t" " "

			control_title_html = substituteString control_title "&" "&amp;"
			control_title_html = substituteString control_title_html "<" "&lt;"
			control_title_html = substituteString control_title_html ">" "&gt;"

			tooltip_text_html = substituteString tooltip_text "&" "&amp;"
			tooltip_text_html = substituteString tooltip_text_html "<" "&lt;"
			tooltip_text_html = substituteString tooltip_text_html ">" "&gt;"

			if (use_colors) then
			(
				append markdown_lines ("- <span style=\"color:" + control_css_color + "\"><b>" + control_title_html + "</b></span>")
			)
			else
			(
				append markdown_lines ("- **" + control_title + "**")
			)

			if (tooltip_text != "") then
			(
				if (use_colors) then
				(
					append markdown_lines ("  <span style=\"color:" + tooltip_css_color + "\"><i>" + tooltip_text_html + "</i></span>")
				)
				else
				(
					append markdown_lines ("  *" + tooltip_text + "*")
				)
			)
			else
			(
				if (include_empty_tooltips) then
				(
					if (use_colors) then
					(
						append markdown_lines ("  <span style=\"color:" + tooltip_css_color + "\"><i>No tooltip.</i></span>")
					)
					else
					(
						append markdown_lines "  *No tooltip.*"
					)
				)
			)

			append markdown_lines ""
		)
	)

	for group_box in group_box_array do
	(
		group_title = ""

		try
		(
			group_title = group_box.text as string
		)
		catch()

		if (group_title == "") then
		(
			try
			(
				group_title = group_box.caption as string
			)
			catch()
		)

		if (group_title == "") then
		(
			try
			(
				group_title = group_box.name as string
				group_title = substituteString group_title "#" ""
			)
			catch()
		)

		if (group_title == "") then
		(
			group_title = "Group"
		)

		group_title_html = substituteString group_title "&" "&amp;"
		group_title_html = substituteString group_title_html "<" "&lt;"
		group_title_html = substituteString group_title_html ">" "&gt;"

		group_level = level + 1
		if (group_level > 6) then
		(
			group_level = 6
		)

		group_header_marker = ""
		for i = 1 to group_level do
		(
			group_header_marker += "#"
		)

		if (use_colors) then
		(
			append markdown_lines (group_header_marker + " <span style=\"color:" + group_css_color + "\"><b>" + group_title_html + "</b></span>")
		)
		else
		(
			append markdown_lines (group_header_marker + " " + group_title)
		)

		append markdown_lines ""

		for control_data in control_group_array where control_data[2] == group_box do
		(
			control_item = control_data[1]

			class_text = ""
			try
			(
				class_text = (classOf control_item) as string
			)
			catch()

			is_sub_rollout = false

			if (matchPattern class_text pattern:"*SubRollout*" ignoreCase:true) then
			(
				is_sub_rollout = true
			)

			try
			(
				if (control_item.rollouts != undefined) then
				(
					is_sub_rollout = true
				)
			)
			catch()

			if (is_sub_rollout) then
			(
				child_rollout_array = #()
				try
				(
					child_rollout_array = control_item.rollouts
				)
				catch()

				for child_rollout in child_rollout_array do
				(
					generateRolloutMarkdownHelp child_rollout \
						include_empty_tooltips:include_empty_tooltips \
						use_colors:use_colors \
						rollout_color:rollout_color \
						nested_rollout_color:nested_rollout_color \
						group_color:group_color \
						control_color:control_color \
						tooltip_color:tooltip_color \
						level:(level + 2) \
						markdown_lines:markdown_lines \
						is_child:true
				)
			)
			else
			(
				control_title = ""
				tooltip_text = ""

				try
				(
					control_title = control_item.text as string
				)
				catch()

				if (control_title == "") then
				(
					try
					(
						control_title = control_item.caption as string
					)
					catch()
				)

				if (control_title == "") then
				(
					try
					(
						control_title = control_item.title as string
					)
					catch()
				)

				if (control_title == "") then
				(
					try
					(
						control_title = control_item.name as string
						control_title = substituteString control_title "#" ""
					)
					catch()
				)

				if (control_title == "") then
				(
					control_title = class_text
				)

				try
				(
					tooltip_text = control_item.tooltip as string
				)
				catch()

				if (tooltip_text == "") then
				(
					try
					(
						tooltip_text = control_item.toolTip as string
					)
					catch()
				)

				control_title = substituteString control_title "\r\n" " "
				control_title = substituteString control_title "\n" " "
				control_title = substituteString control_title "\r" " "
				control_title = substituteString control_title "\t" " "

				tooltip_text = substituteString tooltip_text "\r\n" " "
				tooltip_text = substituteString tooltip_text "\n" " "
				tooltip_text = substituteString tooltip_text "\r" " "
				tooltip_text = substituteString tooltip_text "\t" " "

				control_title_html = substituteString control_title "&" "&amp;"
				control_title_html = substituteString control_title_html "<" "&lt;"
				control_title_html = substituteString control_title_html ">" "&gt;"

				tooltip_text_html = substituteString tooltip_text "&" "&amp;"
				tooltip_text_html = substituteString tooltip_text_html "<" "&lt;"
				tooltip_text_html = substituteString tooltip_text_html ">" "&gt;"

				if (use_colors) then
				(
					append markdown_lines ("- <span style=\"color:" + control_css_color + "\"><b>" + control_title_html + "</b></span>")
				)
				else
				(
					append markdown_lines ("- **" + control_title + "**")
				)

				if (tooltip_text != "") then
				(
					if (use_colors) then
					(
						append markdown_lines ("  <span style=\"color:" + tooltip_css_color + "\"><i>" + tooltip_text_html + "</i></span>")
					)
					else
					(
						append markdown_lines ("  *" + tooltip_text + "*")
					)
				)
				else
				(
					if (include_empty_tooltips) then
					(
						if (use_colors) then
						(
							append markdown_lines ("  <span style=\"color:" + tooltip_css_color + "\"><i>No tooltip.</i></span>")
						)
						else
						(
							append markdown_lines "  *No tooltip.*"
						)
					)
				)

				append markdown_lines ""
			)
		)
	)

	if (is_child) then
	(
		markdown_lines
	)
	else
	(
		markdown_text = ""

		for i = 1 to markdown_lines.count do
		(
			markdown_text += markdown_lines[i]

			if (i < markdown_lines.count) then
			(
				markdown_text += "\n"
			)
		)

		if (output_path != undefined) then
		(
			output_file = createFile output_path
			format "%" markdown_text to:output_file
			close output_file
		)

		markdown_text
	) -- return
)

/** Generate help document
 */
function generateHelpDocument refresh:false =
(
	--format "\n"; print ".generateHelpDocument()"
	help_file_path = ( getFilenamePath(getSourceFileName()) + "\\rollout_help_colored.md")
	
	
	if refresh and doesFileExist help_file_path then
		deleteFile help_file_path
	
	--format "%\n" markdown_text
	
	if not doesFileExist help_file_path then

		markdown_text = generateRolloutMarkdownHelp DIALOG_viltools \
			output_path:help_file_path \
			rollout_color:(color 120 170 230) \
			nested_rollout_color:(color 120 200 150) \
			group_color:(color 235 190 95) \
			control_color:(color 200 140 210) \
			tooltip_color:(color 150 155 165)
	
	
	
	ShellLaunch help_file_path ""
)



/**
 */
macroscript	_miscellaneous_help
category:	"_miscellaneous"
buttontext:	"H E L P"
tooltip:	"Open help file\n\nCTRL: Generate Help"
icon:	"width:128|height:48"
(
	on execute do
	( 
		generateHelpDocument refresh:keyboard.controlPressed
						
	)
)




