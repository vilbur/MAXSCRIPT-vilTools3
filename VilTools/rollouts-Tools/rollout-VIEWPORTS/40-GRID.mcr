/** SET GRID
 */
macroscript	viewport_grid_toggle
category:	"_Viewports-Setup-Grid"
buttontext:	"Grid ON \ OFF"
tooltip:	"Toggle grid in all views"
icon:	"across:3|MENU:true"
(
	on isChecked do viewport.getGridVisibility (viewport.activeViewport)
	
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-VIEWPORTS\40-GRID.mcr"
		
		grid_state = viewport.getGridVisibility (viewport.activeViewport)
	
		
		for i = 1 to viewport.numViews do
			viewport.setGridVisibility i (not grid_state)
	)
) 

/** SET GRID
 */
macroscript	viewport_set_grid_spacing
category:	"_Viewports-Setup-Grid"
buttontext:	"Set Grid Spacing"
tooltip:	"Set grid spacing in milimeters: 0.05 | 1 | 10 | 100\n\n0.05 is resolution of 3D printer`s LCD Creality LD-006"
icon:	"MENU:true"
(
	on execute do
	(
		--clearListener();

		grid_spacings = #( 0.05, 0.1, 1.0, 10.0, 100.0  ) -- SPACING OF GRID IN mm units
		
		display_units = case units.SystemType of -- convert to milimeters
		(
			#millimeters:	1
			#centimeters:	10
			#meters:	1000
			#kilometers:	1000000
			default:	1 -- non metric units
		)
		
		index = findItem grid_spacings (GetGridSpacing())
		
		next_index = if index == grid_spacings.count then 1 else index + 1 
		
		grid_spacing = grid_spacings[next_index] / display_units
		
		SetGridSpacing grid_spacing

		SetGridMajorLines 10
		
		/* remove float zero "1.0" >>> "1" */ 			
		if mod grid_spacing 1 == 0 then
			grid_spacing = grid_spacing as integer

		--format "grid_spacing: %\n" grid_spacing
		
		grid_size = case of
		(
			(grid_spacing <= 0.1): 1000
			default: 10
		)
		--format "\nGRID_SIZE: %\n" grid_size
		
		gridPrefs.perspViewGridExtents = grid_size
			
		format "GRID SPACING: % mm\n" grid_spacing
	)
)

/**
 */
macroscript	viewport_set_perspective_grid_size
category:	"_Viewports-Setup-Grid"
buttontext:	"Set Grid Size"
tooltip:	"Set grid size in perspective view.\n\nFit grid size to selected objects or all visible objects if nothing selected"
icon:	"MENU:true"
(
	/*
		Get X and Y size of bounding box of all visible geometry
		
		This function collects all visible geometry objects,
		computes their world-space bounding box, and returns
		the X and Y size as a Point2.
	*/
	function getSceneXYSizeVisibleOnly objects_input =
	(
	
	
		if objects_input.count == 0 then
		(
			format "No visible geometry objects found.\n"
			return undefined -- return
		)
	
		-- initialize with first valid bbox
		bbox = undefined
		for obj in objects_input while bbox == undefined do
		(
			b = nodeGetBoundingBox obj ( Matrix3 1) -- return array of min\max positions E.G.: bbox[1].z | bbox[2].z
		   
			if b != undefined then bbox = b
		)
	
		if bbox == undefined then
		(
			format "No valid bounding boxes found.\n"
			return undefined -- return
		)
	
		min_pt = bbox[1]
		max_pt = bbox[2]
	
		for obj in objects_input do
		(
			b = nodeGetBoundingBox obj (obj.transform)
			if b != undefined then
			(
				min_pt = [amin min_pt.x b[1].x, amin min_pt.y b[1].y, amin min_pt.z b[1].z]
				max_pt = [amax max_pt.x b[2].x, amax max_pt.y b[2].y, amax max_pt.z b[2].z]
			)
		)
	
		x_size = max_pt.x - min_pt.x
		y_size = max_pt.y - min_pt.y
	
		[x_size, y_size] -- return as Point2
	)
	
	/** Show grid in perspective view
	 */
	function showGridInPerspectiveView =
	(
		--format "\n"; print ".showGridInPerspectiveView()"
		for i = 1 to viewport.numViews where viewport.getType index:i == #view_persp_user do persp_view = i

		if persp_view != undefined then
			viewport.setGridVisibility persp_view true
	)

	on execute do
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
		--format "EventFired:	% \n" EventFired
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-viltools3\VilTools\rollouts-Tools\rollout-VIEWPORTS\40-GRID.mcr"
		
		showGridInPerspectiveView()

		
		ahk_path = getDir #USERSCRIPTS + "\\MAXSCRIPT-viltools3\\VilTools\\rollouts-Tools\\rollout-VIEWPORTS\\Ahk\\set-perspective-grid-size.ahk"	--"./Ahk/set-perspective-grid-size.ahk"
		
		objects_input = if selection.count > 0 then selection as Array else for obj in geometry where not obj.isHidden collect obj
		
		xy_size = getSceneXYSizeVisibleOnly( objects_input )
		
		if xy_size != undefined then
		(
			longer_side = amax xy_size[1] xy_size[2]
			format "longer_side: %\n" longer_side
			
			/* GRID SIZE IS DEFINED BY ITS HALF SIZE */ 
			grid_size = ( longer_side / 2 ) / GetGridSpacing()
			format "grid_size: %\n" grid_size
			
			rounded_size = if grid_size > 100 then  floor((grid_size + 50) / 100.0) * 100 else floor((grid_size + 5) / 10.0) * 10
			format "rounded_size: %\n" rounded_size
			
			hwnd_grid_settings = (for child in ( windows.getChildrenHWND 0 parent:#max) where child[5] == "Grid and Snap Settings" collect child[1])[1]
			format "HWND_GRID_SETTINGS: %\n" hwnd_grid_settings
			
			if hwnd_grid_settings == undefined then
				actionMan.executeAction 0 "40024"  -- Snaps: Grid and Snap Settings Toggle
			
			command = "\""+ahk_path+"\"" 
			--params = (hwnd_grid_settings  as string)+ " "+ ((rounded_size as integer ) as string ) 
			params = (rounded_size as integer ) as string
			
			ShellLaunch command params
		)
	)
)

--/**
-- */
--macroscript	viewport_set_perspective_grid_size
--category:	"_3D-Print"
--buttontext:	"SIZE"
--tooltip:	""
--icon:	"control:spinner|id:SPIN_grid_zie|fieldwidth:32|range:[ 1, 9999, 10 ]|scale:1|width:90|offset:[ -32, 4 ]|tooltip:"
--(
--	on execute do
--	(
--		--format "EventFired:	% \n" EventFired
--		
--		ahk_path = ( getFilenamePath(getSourceFileName()) + "/Ahk/set-perspective-grid-size.ahk" )	--"./Ahk/set-perspective-grid-size.ahk"
--		
--		DOSCommand ("start \"\" \""+ahk_path+"\" 333"  )
--		
--	)
--)
