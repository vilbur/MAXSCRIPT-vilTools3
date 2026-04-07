filein( getFilenamePath(getSourceFileName()) + "/../../../../../MAXSCRIPT-UI-framework/Lib/MarkdownGenerator/MarkdownGenerator.ms" )	--"./../../../../../MAXSCRIPT-UI-framework/Lib/MarkdownGenerator/MarkdownGenerator.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../../../../MAXSCRIPT-UI-framework/Lib/Hotkeys/HotkeysOfQuadMenus/HotkeysOfQuadMenus.ms" )	--"./../../../../../MAXSCRIPT-UI-framework/Lib/Hotkeys/getHotkeysOfQuadMenus/getHotkeysOfQuadMenus.ms"

/** Show quad menu hotkeys
 */
function showQuadMenuHotkeys =
(
	--format "\n"; print ".showQuadMenuHotkeys()"
	
	myHotkeys = HotkeysOfQuadMenus_v debug:true
	--myHotkeys = HotkeysOfQuadMenus_v debug:false
	hotkeys_and_quad_data = myHotkeys.getHotkeysOfQuadMenus()
	
	--hotkeys_and_quad_data = getHotkeysOfQuadMenus debug:true
	
	
	hotkeys_list = for hotkey in sort hotkeys_and_quad_data.keys collect
	--hotkeys_list = for hotkey in hotkeys_and_quad_data.keys collect
	(
		quad_data = hotkeys_and_quad_data[hotkey]
		
		menu_name = quad_data[#MENU_NAME]
		
		clr = if matchPattern hotkey pattern:("*RMB*") then "lightgreen" else "#4da3ff"
		
		html_text = "<span style=\"color:"+clr+"\"><b>"+ hotkey +"</b></span>   <b>"+ menu_name +"</b>"
		
		--if quad_data[#QUADS] != undefined then
			--html_text += "<b>    QUADS: </b>"+ quad_data[#QUADS]
		
		html_text --return
	)
	
	
	md_file_path = getDir #TEMP + "/md-generator-test.md"
	
	--format "hotkeys_and_quad_data.keys: %\n" (sort hotkeys_and_quad_data.keys)
	/*------------------------------------------------------------------------------
		RUN TEST
	--------------------------------------------------------------------------------*/
	MarkdownGenerator = MarkdownGenerator_v(md_file_path)
	
	
	
	--MarkdownGenerator.generate hotkeys_and_quad_data
	MarkdownGenerator.generate ( Dictionary #( "Hotkeys of Quad menus ", hotkeys_list ))
	
	
	/*------------------------------------------------------------------------------
		OPEN MARKDOWN FILE
	--------------------------------------------------------------------------------*/
	
	DOSCommand ("\""+md_file_path+"\"")
		
)

/* QUICK TEST
	
	showQuadMenuHotkeys()
*/
clearListener(); print("Cleared in: "+getSourceFileName())
	showQuadMenuHotkeys()