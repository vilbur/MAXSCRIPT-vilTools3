
/** SET GRID
 */
macroscript	viewport_set_grid_spacing
category:	"_Viewports-Setup"
buttontext:	"Set Grid"
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
category:	"_3D-Print"
buttontext:	"SIZE"
tooltip:	""
icon:	"control:spinner|id:SPIN_grid_zie|fieldwidth:32|range:[ 1, 9999, 10 ]|scale:1|width:90|offset:[ -32, 4 ]|tooltip:"
(
	on execute do
	(
		--format "EventFired:	% \n" EventFired
		
		ahk_path = ( getFilenamePath(getSourceFileName()) + "/Ahk/set-perspective-grid-size.ahk" )	--"./Ahk/set-perspective-grid-size.ahk"
		
		DOSCommand ("start \"\" \""+ahk_path+"\" 333"  )
		
	)
)
