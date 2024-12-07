/** Toggle constrain type
 */
function toggleConstrainType type EventFired =
(
	format "\n"; print ".toggleConstrainType()"
	format "EventFired: %\n" EventFired
	
	local control_on
	
	types = #( "ConstraintsEdge","ConstraintsFace", "ConstraintsNormal" )
	
	format "ROLLOUT_edit_poly: %\n" ROLLOUT_edit_poly
	
	/* TURN OFF CHECKBUTTONS */ 
	if ROLLOUT_edit_poly != undefined then 
		for control in ROLLOUT_edit_poly.controls do
			if ( control_data = filterString (control as string ) ":")[1] == "CheckButtonControl" \
			and matchPattern control_data[2] pattern:("set_constrain*") then
			(
				if matchPattern control_data[2] pattern:("*"+type as string ) then
					control_on = control
				
				control.checked = false
			)

	/* TOGGLE CONSTRAIN */ 
	if type > 0 and ( modPanel.getCurrentObject()).constrainType != type then
	(
		if control_on != undefined then 
			control_on.checked = true
		
		macros.run "Ribbon - Modeling" types[type]
	)
	else
		macros.run "Ribbon - Modeling" "ConstraintsNone"
)