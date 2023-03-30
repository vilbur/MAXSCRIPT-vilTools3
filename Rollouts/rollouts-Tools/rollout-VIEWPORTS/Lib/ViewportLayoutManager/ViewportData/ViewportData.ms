/** store viewport data
 */
struct ViewportData_v
(
	type	= #view_none,
	start_pos	= [0,0,0],
	end_pos	= [0,0,0],
	view_size	= [0,0],
	field_of_view	= 0.0,
	focal_distance	= 0.0
	--transform	= ( matrix3 [1,0,0] [0,0,-1] [0,1,0] [0,0,0] )
)

matrix3