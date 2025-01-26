clearListener(); print("Cleared in:\n"+getSourceFileName())



--print("Cleared in:\n"+getSourceFileName())

	grid_spacings = #( 0.05, 0.1, 1.0, 10.0, 100.0  ) -- SPACING OF GRID IN mm units
	
	display_units = case units.SystemType of -- convert to milimeters
	(
		#millimeters:	1
		#centimeters:	10
		#meters:	1000
		#kilometers:	1000000
		default:	1 -- non metric units
	)
	
	format "units.SystemType: %\n" units.SystemType
	format "display_units: %\n" display_units
	format "grid_spacing: %\n" (GetGridSpacing())
	
	format "\n"
	format "index: %\n" (findItem grid_spacings (GetGridSpacing()))
	
	index = findItem grid_spacings (GetGridSpacing())
	
	next_index = if index == grid_spacings.count then 1 else index + 1 
	
	format "next_index: %\n" next_index
	
	--format "grid_spacings[next_index]: %\n" grid_spacings[next_index]
	--format "display_units: %\n" display_units
	grid_spacing = grid_spacings[next_index] / display_units
	
	SetGridSpacing grid_spacing
			if mod grid_spacing 1 == 0 then
				grid_spacing = grid_spacing as integer
		
	--SetGridMajorLines 10
	format "GRID SPACING: % mm\n" grid_spacing