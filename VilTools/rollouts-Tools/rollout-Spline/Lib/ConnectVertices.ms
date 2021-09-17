/** Create line between 2 selected vertices on spline 
 *	New knots are weld
 */
function ConnectVertices_v = 
(
	obj = selection[1]
	
    if selection.count == 1 and isKindOf obj Shape then
    (
		knot_count = 0
		knot_positons = #()

		select_splines = #()
		select_knots   = #()
		new_knots      = #()

        for spline = 1 to ( numSplines obj )
            where (local selected_knots = getKnotSelection obj spline).count > 0 do
            (
				append select_splines spline
				append select_knots   selected_knots
				
				
                join knot_positons (for knot in selected_knots collect getKnotPoint obj spline knot)

                if (knot_count += selected_knots.count) > 2 do exit
            )
	
        if knot_count == 2 then
		(
			index = addNewSpline obj
			
			append new_knots	(addKnot obj index #corner #line knot_positons[1])
			append new_knots	(addKnot obj index #corner #line knot_positons[2])
            
			updateShape obj

			for spline = 1 to select_splines.count do
				setKnotSelection obj select_splines[spline] select_knots[spline] 

			setKnotSelection obj index new_knots
			
			weldSpline obj 1
			
			updateShape obj
		)
        else
		    messageBox "Exactly 2 vertices have to be selected."
		

    )
)