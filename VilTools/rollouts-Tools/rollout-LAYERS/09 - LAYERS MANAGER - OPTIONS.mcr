/** EXPAND SELECTED LAYERS
 */
macroscript	_layers_manager_configure
category:	"_Layers-Manager"
buttontext:	"CONFIGURE Layers Manager"
tooltip:	"Auto CONFIGURE layers manager.\n\nRESTART of 3Ds Max is REQUIRED"
icon:	"across:1"
(
	on execute do
	(
		if not queryBox ("CONFIGURE LAYER MANAGER COLUMNS ?") title:"LAYERS MANGER ETUP" then
			return false
		
		VisibleColumns	= ""
		ColumnWidth	= ""
		
		layer_manager_ini = getDir #hardwareShadersCache + "\ExplorerConfig\SceneExplorer\DefaultLayerExplorer.ini" -- HELP: https://help.autodesk.com/view/MAXDEV/2023/ENU/?guid=GUID-F7577416-051E-478C-BB5D-81243BAAC8EC
		
		
		columns_and_widths	= Dictionary #STRING -- KEY:"Columns name" VALUE:integer width of column
		
		/* ORDER OF COLUMNS */
		columns = #(
			"Name",
			
			"Frozen",
			"Color",
			
			"RenderByLayer",
			"Render",
			
			"DisplayByLayer",
			"Display as Box",
			
			""
		)
		
		/* SET WIDTHS */ 
		columns_and_widths["Name"]	= 280
		columns_and_widths["Color"]	= 35
		columns_and_widths["Render"]	= 25
		columns_and_widths["Frozen"]	= 25
		columns_and_widths["Display as Box"]	= 25
		columns_and_widths["DisplayByLayer"]	= 25
		columns_and_widths["RenderByLayer"]	= 25
		
		/* SERIALIZE DICTIONARY */ 
		for column in columns where ( width = columns_and_widths[column] ) != undefined do
		(
			VisibleColumns	+= column + ","
			
			ColumnWidth	+= ( width as string ) + ","
		)
		
		/* TRIM "," */ 
		VisibleColumns	= trimRight VisibleColumns	","
		ColumnWidth	= trimRight ColumnWidth	","
		
		/* SAVE DATA TO INI */ 
		setINISetting layer_manager_ini "Explorer" "VisibleColumns" VisibleColumns
		setINISetting layer_manager_ini "Explorer" "ColumnWidth"    ColumnWidth
		
		/* RESTART 3DS MAX */ 
		if maxFileName == "" or queryBox ("RESTART OF MAX IS NEEDED\n\nRESTART NOW ?") title:"RESTART 3DS MAX" then
		(
			pid = (( dotNetClass "System.Diagnostics.Process").GetCurrentProcess()).Id

			max_path = (getDir #maxroot) + "3dsmax.exe"

			file_path = if maxFileName != "" then "\"" + maxFilePath + maxFileName +"\"" else ""

			/* START NEW MAX */ 		
			DOSCommand ("start \"\" \""+ max_path +"\" "+ file_path)
			
			/* KILL CURRENT MAX */ 			
			DOSCommand ("cmd /c start \"\" taskkill /f /pid " + pid as string)
		)
	)
)