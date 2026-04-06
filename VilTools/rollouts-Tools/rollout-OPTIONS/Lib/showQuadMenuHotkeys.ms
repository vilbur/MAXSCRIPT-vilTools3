filein( getFilenamePath(getSourceFileName()) + "/../../../../../MAXSCRIPT-UI-framework/Lib/MarkdownGenerator/MarkdownGenerator.ms" )	--"./../../../../../MAXSCRIPT-UI-framework/Lib/MarkdownGenerator/MarkdownGenerator.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../../../../MAXSCRIPT-UI-framework/Lib/Hotkeys/getHotkeysOfQuadMenus/getHotkeysOfQuadMenus.ms" )	--"./../../../../../MAXSCRIPT-UI-framework/Lib/Hotkeys/getHotkeysOfQuadMenus/getHotkeysOfQuadMenus.ms"

/** Show quad menu hotkeys
 */
function showQuadMenuHotkeys =
(
	--format "\n"; print ".showQuadMenuHotkeys()"
	
	hotkeys_of_quad_menus = getHotkeysOfQuadMenus debug:true
	
	
	hotkeys_list = for menu_name in sort hotkeys_of_quad_menus.keys collect
	(
		quad_data = hotkeys_of_quad_menus[menu_name]
		
		hotkey = quad_data[#HOTKEY]
		
		clr = if matchPattern hotkey pattern:("*RMB*") then "lightgreen" else "#4da3ff"
		
		html_text = "<span style=\"color:"+clr+"\"><b>"+ hotkey +"</b></span>   <b>"+ menu_name +"</b>"
		
		--if quad_data[#QUADS] != undefined then
			--html_text += "<b>    QUADS: </b>"+ quad_data[#QUADS]
		
		html_text --return
	)
	
	
	md_file_path = getDir #TEMP + "/md-generator-test.md"
	
	--format "hotkeys_of_quad_menus.keys: %\n" (sort hotkeys_of_quad_menus.keys)
	/*------------------------------------------------------------------------------
		RUN TEST
	--------------------------------------------------------------------------------*/
	MarkdownGenerator = MarkdownGenerator_v(md_file_path)
	
	
	
	--MarkdownGenerator.generate hotkeys_of_quad_menus
	MarkdownGenerator.generate ( Dictionary #( "Hotkeys of Quad menus ", hotkeys_list ))
	
	
	/*------------------------------------------------------------------------------
		OUTPUT
	--------------------------------------------------------------------------------*/
	
	DOSCommand ("\""+md_file_path+"\"")
		
)

/* QUICK TEST
	
	showQuadMenuHotkeys()
*/
	showQuadMenuHotkeys()