/** store viewport data
 */
struct ViewportData_v
(
	type	= #VIEW_NONE,
	start_pos	= [0,0,0],
	end_pos	= [0,0,0],
	view_size	= [0,0],
	field_of_view	= 0.0,
	focal_distance	= 0.0,
	render_mode	= #WIREFRAME,
	camera	= undefined, --string name of camera
	transform	= ( matrix3 [1,0,0] [0,0,-1] [0,1,0] [0,0,0] )
)