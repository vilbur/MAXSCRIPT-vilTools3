MacroScript _quadmenu_test
--enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
    ButtonText:"_QuadMenu Test" 
    Category:"_QuadMenu Test" 
    internalCategory:"_QuadMenu Test" 
    Tooltip:"Convert to Editable Mesh" 
    --Icon:#("Max_edit_modifiers",1)
(

	-- Active in any SO level:
	On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2..5}
	On IsVisible Return Filters.Is_EPolySpecifyLevel #{2..5}
	On IsChecked Do (
		try (
	
		)
		catch ( false )
	)

	On Execute Do (
		Try (
			messageBox "Yupiii" beep:false
		)
		Catch()
	)
	On AltExecute type do (
		Try (
			messageBox "YEEEEEEEEEEEEEs" beep:false
		
		)
		Catch()
	)

)


/*

https://forums.cgsociety.org/t/mxs-adding-custom-item-to-convert-to-quad-menu/1870495
https://forums.cgsociety.org/t/menuman-registermenucontext/1265878/2
https://forums.cgsociety.org/t/how-can-i-do-this-and-this/1134217/49


*/ 
fn GetConvertToMenu =
(    
    --quadMenu = menuMan.getQuadMenu  1;
    --quadMenu = menuMan.findQuadMenu "Custom                    [Shift+Ctrl+RMB]";
    --quadMenu = menuMan.findQuadMenu "Viewports";
    --quadMenu = menuMan.findQuadMenu "MassFX";
	
	
	
	--for i = 1 to (menuMan.numQuadMenus()) do
	--(
	--	quadMenu = menuMan.getQuadMenu  i;
	--	--format "quadMenu = % \n" quadMenu
	--
	--	if quadMenu != undefined then
	--	(
	--		menu_name = menuMan.getQuadMenuName quadMenu
	--		
	--		format "menu_name = % \n" menu_name
	--	)
	--	
	--)
	

	--
	--QuadMenu = menuMan.createQuadMenu "vilbur" "quad1Name" "quad2Name" "quad3Name" "quad4Name" 
	--
	--
	--
	--
	--menuMan.setViewportRightClickMenu #nonePressed QuadMenu
	--
	
-- This example adds a new command to MAX's default right-click quad menu
----if menuMan.registerMenuContext 0x36690115 then
--(
	-- Get the default viewport right-click quad menu
    --quadMenu = menuMan.findQuadMenu "Default Viewport Quad";
	-- quadMenu = menuMan.getViewportRightClickMenu #nonePressed
	---- Get the lower-left menu from the quad
	-- _menu = quadMenu.getMenu 1
	---- create a menu item that calls the sample macroScript
	-- testItem = menuMan.createActionItem "_quadmenu_test" "_QuadMenu Test"
	---- Add the item to the menumenu.addItem testItem -1
	----format "testItem = % \n" testItem
	--_menu.addItem testItem 1
--)
-- else
-- messageBox "Yupiii" beep:false

	
    --quadMenu = menuMan.findQuadMenu "Default Viewport Quad";
    --quadMenu = menuMan.getQuadMenu  6; --"Modeling"

--    if quadMenu != undefined then
--    (
--		menu_name = menuMan.getQuadMenuName quadMenu
--		
--		format "menu_name = % \n" menu_name
--        mnu = quadMenu.getMenu 2; -- bottom right
--		
--		format "mnu.numItems() = % \n" (mnu.numItems())
--		
--		item = mnu.getitem 1
--		
--		--mnu.removeItem item
--		
--		
--		format "item = % \n" (item.getTitle()) 
--		
--        --if mnu != undefined then
--        --(
--        --    converttoitem = mnu.getitem (mnu.numItems())
--        --    if     converttoitem != undefined then
--        --        return     converttoitem.getSubMenu();
--        --)
--    )
--    undefined;
)  

GetConvertToMenu()



--
--
--fn GetConvertToMenu =
--(    
--    quadMenu = menuMan.findQuadMenu "Default Viewport Quad";
--    if quadMenu != undefined then
--    (
--        mnu = quadMenu.getMenu 1; -- bottom right    
--        if mnu != undefined then
--        (
--            converttoitem = mnu.getitem (mnu.numItems())
--            if     converttoitem != undefined then
--                return     converttoitem.getSubMenu();
--        )
--    )
--    undefined;
--)   
--
--
--MacroScript Convert_to_Mesh 
--enabledIn:#("max", "viz", "vizr") --pfb: 2003.12.12 added product switch
--    ButtonText:"Convert to Editable Mesh" 
--    Category:"Modifier Stack" 
--    internalCategory:"Modifier Stack" 
--    Tooltip:"Convert to Editable Mesh" 
--    Icon:#("Max_edit_modifiers",1)
--(    
--
--    On isEnabled return (Try(Selection.count != 0 and CanConvertTo Selection[1] Mesh)Catch())
--    On isVisible return (Try(Selection.count != 0 and CanConvertTo Selection[1] Mesh)Catch()) 
--    On Execute Do    
--    (
--        SuspendEditing()
--        for obj in selection do
--        (
--            Try(ConvertToMesh obj)Catch() 
--        )
--        ResumeEditing()
--        Max modify mode
--    )
--)  
--
--   if menuMan.registerMenuContext 0x36690115 then
--(
--    converttomenu = GetConvertToMenu();
--
--    if converttomenu  != undefined then
--    (    
--        local convertItem = menuMan.createActionItem "Convert_to_Mesh" "Convert to EditableMesh vilbur" -- this will be your type
--        converttomenu.addItem convertItem  -1
--    )
--) 